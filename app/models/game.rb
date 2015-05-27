class Game < ActiveRecord::Base
  GAME_OVER = 'game_over'
  ACTIVE = 'active'
  BONUS_FALSE = 'false'
  BONUS_TRUE = 'true'
  WINNER = 'winner'
  LOSER = 'loser'
  MAXIMUM_TURNS = 25
  DEFAULT_WINNER_ID = 0
  WINNER_COIN_PRIZE = 5

  belongs_to :player1, :class_name => 'User', :foreign_key => 'player1_id'
  belongs_to :player2, :class_name => 'User', :foreign_key => 'player2_id'
  has_many :challenges
  accepts_nested_attributes_for :player1
  accepts_nested_attributes_for :player2
  validates :player1_id, presence: true
  validates :player2_id, presence: true

  # Verifies that player one and teo are different
  def self.verify_different_players
    errors.add(:player2, "Player 1 and Player 2 must be different users") if :player1_id == :player2_id
  end

  def self.games_by_user(user_id)
    self.active_games_by_user(user_id) + self.finished_games_by_user(user_id)
  end

  def self.finished_games
    self.where(game_status: GAME_OVER)
  end

  def self.active_games
    self.where(game_status: ACTIVE)
  end

  def finished?
    self.game_status == GAME_OVER
  end

  def active?
    self.game_status == ACTIVE
  end

  def proceed?(user_id)
    active? && players_turn?(user_id)
  end

  def set_challenge
    challenge1 = Challenge::get_ongoing_challenge(self.id, self.player1_id, self.player2_id)
    challenge2 = Challenge::get_ongoing_challenge(self.id, self.player2_id, self.player1_id)
    if challenge1.nil? && challenge2.nil?
      self.challenge = Challenge::CHALLENGE_YES
      self.bonus = BONUS_FALSE
      self.save!
      true
    else
      false
    end
  end

  def challenge_round?
    self.challenge == Challenge::CHALLENGE_YES
  end

  def normal_round?
    self.challenge == Challenge::CHALLENGE_NO
  end

  def bonus?
    self.bonus == BONUS_TRUE
  end

  def players_turn?(player_id)
    if player_id == self.player1_id && self.player1_turn == true
      true
    elsif player_id == self.player2_id && self.player1_turn == false
      return true
    else
      false
    end
  end

  def self.playable_users(user_id)
    @playable_users = User.where("id != ? and  id != ?", 1, user_id)
  end

  def self.random_player
    @playable_users.shuffle.sample
  end

  def self.active_games_by_user(user_id)
    Game.active_games.where('player1_id=? or player2_id=?', user_id, user_id)
  end

  def self.finished_games_by_user(user_id)
    Game.finished_games.where('player1_id=? or player2_id=?', user_id, user_id)
  end

  def all_trophies
    @all_trophies = Array.new
    @all_trophies << Subject::ART
    @all_trophies << Subject::ENTERTAINMENT
    @all_trophies << Subject::HISTORY
    @all_trophies << Subject::GEOGRAPHY
    @all_trophies << Subject::SCIENCE
    @all_trophies << Subject::SPORTS
    @all_trophies
  end

  def player1_trophies
    @player1_trophies = Array.new
    @player1_trophies << Subject::ART if self.art_trophy_p1
    @player1_trophies << Subject::ENTERTAINMENT if self.entertainment_trophy_p1
    @player1_trophies << Subject::HISTORY if self.history_trophy_p1
    @player1_trophies << Subject::GEOGRAPHY if self.geography_trophy_p1
    @player1_trophies << Subject::SCIENCE if self.science_trophy_p1
    @player1_trophies << Subject::SPORTS if self.sports_trophy_p1
    @player1_trophies
  end

  def player2_trophies
    @player2_trophies = Array.new
    @player2_trophies << Subject::ART if self.art_trophy_p2
    @player2_trophies << Subject::ENTERTAINMENT if self.entertainment_trophy_p2
    @player2_trophies << Subject::HISTORY if self.history_trophy_p2
    @player2_trophies << Subject::GEOGRAPHY if self.geography_trophy_p2
    @player2_trophies << Subject::SCIENCE if self.science_trophy_p2
    @player2_trophies << Subject::SPORTS if self.sports_trophy_p2
    @player2_trophies
  end

  def opponent_id(player_id)
    @opponent_id = self.player2_id if player_id == self.player1_id
    @opponent_id = self.player1_id if player_id == self.player2_id
    @opponent_id
  end

  # Checks to see if the current player can start a challenge
  # Looks at current player and opponents trophies to see if
  # challenge can start
  def can_challenge?
    no_winnable_trophies?
  end

  def get_available_trophies(player_id)
    return self.all_trophies - self.player1_trophies if player_id == self.player1_id
    self.all_trophies - self.player2_trophies if player_id == self.player2_id
  end

  def get_winnable_trophies(player_id)
    case player_id
      when self.player1_id
        return self.player2_trophies - self.player1_trophies
      when self.player2_id
        return self.player1_trophies - self.player2_trophies
      else

    end
  end

  def get_wagerable_trophies(player_id)
    case player_id
      when self.player1_id
        return self.player1_trophies - self.player2_trophies
      when self.player2_id
        return self.player2_trophies - self.player1_trophies
      else

    end
  end

  def apply_correct_result(subject, user_id)
    correct = self.answers_correct + 1
    if self.bonus?
      give_trophy(subject, user_id)
      self.update_attributes(:bonus => BONUS_FALSE)
      self.save!
    else
      self.update_attributes(:answers_correct => correct)
      self.save!
      if self.answers_correct == 3
        self.update_attributes(:bonus => BONUS_TRUE)
        self.save!
      end
    end
    if self.player_has_all_trophies?(user_id)
      self.end_game(user_id)
    end
  end

  def apply_incorrect_result(user_id)
    new_turn_count = self.turn_count
    new_turn_count += 1
    self.update_attributes!(turn_count: new_turn_count)
    self.save!
    if self.turn_count == MAXIMUM_TURNS
      compare_trophy_count
    end
    unless challenge_round?
      end_round(user_id)
    end
  end

  def apply_to_normal_round(subject, user_id, result)
    case result
      when Question::CORRECT
        apply_correct_result(subject, user_id)
      when Question::INCORRECT
        apply_incorrect_result(user_id)
      else
        # type code here
    end
    self.game_status
  end

  def apply_challenge_results(result, winner_id, wager, prize)
    if result == Challenge::RESULT_WINNER
      if winner_id == self.player1_id
        self.take_trophy(prize, self.player2_id)
        self.give_trophy(prize, self.player1_id)
        #  true
      elsif winner_id == self.player2_id
        self.take_trophy(wager, self.player1_id)
        self.give_trophy(wager, self.player2_id)
      end
    end
    self.challenge = Challenge::CHALLENGE_NO
    self.bonus = BONUS_FALSE
    reset_answers_correct
  end

  def give_trophy(subject, user_id)
    change_player_trophy_status(subject, user_id, true)
    reset_answers_correct
  end

  def take_trophy(subject, user_id)
    change_player_trophy_status(subject, user_id, false)
  end

  def end_round(user_id)
    self.update_attributes!(:answers_correct => 0, :bonus => BONUS_FALSE)
    self.update_attributes(:player1_turn => false) if user_id == self.player1_id
    self.update_attributes(:player1_turn => true) if user_id == self.player2_id
    self.save!
  end

  def end_game(winner_id)
    self.update_attributes(:game_status => GAME_OVER, :winner_id => winner_id)
    self.save!
  end

  def game_over?
    self.game_status == GAME_OVER
  end

  # Checks to see if player has all trophies
  def player_has_all_trophies?(player_id)
    case player_id
      when self.player1_id
        return self.art_trophy_p1 && self.entertainment_trophy_p1 && self.history_trophy_p1 && self.geography_trophy_p1 && self.science_trophy_p1 && self.sports_trophy_p1
      when self.player2_id
        return self.art_trophy_p2 && self.entertainment_trophy_p2 && self.history_trophy_p2 && self.geography_trophy_p2 && self.science_trophy_p2 && self.sports_trophy_p2
      else
        false
    end
  end

  def max_turns?
    self.turn_count == MAXIMUM_TURNS
  end

  # Compares the players trophies and ends the game, setting the winner to the player with the most trophies
  # If they have the same number of trophies, it sets the challenge round attribute
  def compare_trophy_count
    fail 'Cannot compare trophy count while turn_count < 25' unless max_turns?
    fail 'Cannot compare trophy count if turn_count > 25' if self.turn_count > MAXIMUM_TURNS
    if player1_trophies.count > player2_trophies.count
      end_game(self.player1_id)
    elsif player2_trophies.count > player1_trophies.count
      end_game(self.player2_id)
    else
      self.challenge = Challenge::CHALLENGE_YES
      self.save!
    end
  end


  def self.percent_games_won_against_user(current_user_id, player2_id)
    games_won_count = 0
    result = 0
    current_users_games = Game.games_by_user(current_user_id)
    player2_games = Game.games_by_user(player2_id)
    common_games = current_users_games & player2_games

    if common_games.size > 0
      common_games.each do |g|
        if g.winner_id == current_user_id
          games_won_count += 1
        end
      end
      result = games_won_count / common_games.size
    end
    if result != 0
      result * 100
    else
      0
    end
  end

  def self.percent_answered_correct_by_subject(total, correct)
    if total >= 1
      (correct / total) * 100
    else
      0
    end
  end

  ############################################################
  #####################     PRIVATE     ######################
  ############################################################

  private

  def reset_answers_correct
    self.update_attributes(:answers_correct => 0)
    self.save!
  end

  def change_player_trophy_status(subject, user_id, flag)
    case subject
      when Subject::ART
        self.update_attributes(:art_trophy_p1 => flag) if user_id == self.player1_id
        self.update_attributes(:art_trophy_p2 => flag) if user_id == self.player2_id
      when Subject::ENTERTAINMENT
        self.update_attributes(:entertainment_trophy_p1 => flag) if user_id == self.player1_id
        self.update_attributes(:entertainment_trophy_p2 => flag) if user_id == self.player2_id
      when Subject::HISTORY
        self.update_attributes(:history_trophy_p1 => flag) if user_id == self.player1_id
        self.update_attributes(:history_trophy_p2 => flag) if user_id == self.player2_id
      when Subject::GEOGRAPHY
        self.update_attributes(:geography_trophy_p1 => flag) if user_id == self.player1_id
        self.update_attributes(:geography_trophy_p2 => flag) if user_id == self.player2_id
      when Subject::SCIENCE
        self.update_attributes(:science_trophy_p1 => flag) if user_id == self.player1_id
        self.update_attributes(:science_trophy_p2 => flag) if user_id == self.player2_id
      when Subject::SPORTS
        self.update_attributes(:sports_trophy_p1 => flag) if user_id == self.player1_id
        self.update_attributes(:sports_trophy_p2 => flag) if user_id == self.player2_id
      else
        # type code here
    end
    self.save!
  end

  def no_winnable_trophies?
    difference1 = self.player2_trophies - self.player1_trophies
    difference2 = self.player1_trophies - self.player2_trophies
    same_trophies_left?(difference1, difference2)
  end

  def same_trophies_left?(one, two)
    if one.count == 0 || two.count == 0
      false
    else
      !one.eql?(two)
    end
  end
end