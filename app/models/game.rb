class Game < ActiveRecord::Base

  belongs_to :player1, :class_name => 'User', :foreign_key => 'player1_id'
  belongs_to :player2, :class_name => 'User', :foreign_key => 'player2_id'

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
    self.where(game_status: "game_over")
  end

  def self.active_games
    self.where(game_status: "active")
  end

  def finished?
    self.game_status == "game_over"
  end

  def active?
    self.game_status == "active"
  end

  def players_turn?(player_id)
    self.player1_turn? && player1_id == player_id
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
    @all_trophies << "Art"
    @all_trophies << "Entertainment"
    @all_trophies << "History"
    @all_trophies << "Geography"
    @all_trophies << "Science"
    @all_trophies << "Sports"
    @all_trophies
  end

  def player1_trophies
    @player1_trophies = Array.new
    @player1_trophies << "Art" if self.art_trophy_p1
    @player1_trophies << "Entertainment" if self.entertainment_trophy_p1
    @player1_trophies << "History" if self.history_trophy_p1
    @player1_trophies << "Geography" if self.geography_trophy_p1
    @player1_trophies << "Science" if self.science_trophy_p1
    @player1_trophies << "Sports" if self.sports_trophy_p1
    @player1_trophies
  end

  def player2_trophies
    @player2_trophies = Array.new
    @player2_trophies << "Art" if self.art_trophy_p2
    @player2_trophies << "Entertainment" if self.entertainment_trophy_p2
    @player2_trophies << "History" if self.history_trophy_p2
    @player2_trophies << "Geography" if self.geography_trophy_p2
    @player2_trophies << "Science" if self.science_trophy_p2
    @player2_trophies << "Sports" if self.sports_trophy_p2
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
    return self.all_trophies - self.player2_trophies if player_id == self.player2_id
  end

  def get_winnable_trophies(player_id)
    case player_id
      when self.player1_id
        return self.player2_trophies - self.player1_trophies
      when self.player2_id
        return self.player1_trophies - self.player2_trophies
    end
  end

  def get_wagerable_trophies(player_id)
    case player_id
      when self.player1_id
        return self.player1_trophies - self.player2_trophies
      when self.player2_id
        return self.player2_trophies - self.player1_trophies
    end
  end

  def play_challenge(challenger_id, wager, prize)
    @game_challenge = Challenge.new
    @game_challenge.set_game_attributes(self.id, challenger_id, wager, prize)
    @game_challenge.generate_question_ids
    @game_challenge.save
    @game_challenge
  end

  def challenge_round
    @game_challenge
  end

  # @return [true if the challenge has a winner and trophies are swapped accordingly, false if tie]
  def apply_challenge_results
    if @game_challenge
      if @game_challenge.winner_id == self.player1_id
        self.take_trophy(@game_challenge.prize, self.player2_id)
        self.give_trophy(@game_challenge.prize, self.player1_id)
      #  true
      elsif @game_challenge.winner_id == self.player2_id
        self.take_trophy(@game_challenge.wager, self.player1_id)
        self.give_trophy(@game_challenge.wager, self.player2_id)
      #  true
      #elsif @game_challenge.tie?
      #  reset_answers_correct
      #  false
      end
    end
  end

  def give_trophy(subject, user_id)
    change_player_trophy_status(subject, user_id, true)
    reset_answers_correct
  end

  def take_trophy(subject, user_id)
    change_player_trophy_status(subject, user_id, false)
  end

  def end_round(user_id, count)
    self.update_attributes(:player1_turn => false, :answers_correct => 0) if user_id == self.player1_id
    self.update_attributes(:player1_turn => true, :answers_correct => 0) if user_id == self.player2_id
    self.update_attributes(:turn_count => count)
    self.save!
  end

  def end_game
    self.update_attributes(:game_status => 'game_over')
    self.save!
  end

  # Checks to see if player has all trophies
  def player_wins?(player_id)
    case player_id
      when self.player1_id
        return self.art_trophy_p1 && self.entertainment_trophy_p1 && self.history_trophy_p1 && self.geography_trophy_p1 && self.science_trophy_p1 && self.sports_trophy_p1
      when self.player2_id
        return self.art_trophy_p2 && self.entertainment_trophy_p2 && self.history_trophy_p2 && self.geography_trophy_p2 && self.science_trophy_p2 && self.sports_trophy_p2
    end
  end

  private

  def reset_answers_correct
    self.update_attributes(:answers_correct => 0)
    self.save
  end

  def change_player_trophy_status(subject, user_id, flag)
    case subject
      when "Art"
        self.update_attributes(:art_trophy_p1 => flag) if user_id == self.player1_id
        self.update_attributes(:art_trophy_p2 => flag) if user_id == self.player2_id
      when "Entertainment"
        self.update_attributes(:entertainment_trophy_p1 => flag) if user_id == self.player1_id
        self.update_attributes(:entertainment_trophy_p2 => flag) if user_id == self.player2_id
      when "History"
        self.update_attributes(:history_trophy_p1 => flag) if user_id == self.player1_id
        self.update_attributes(:history_trophy_p2 => flag) if user_id == self.player2_id
      when "Geography"
        self.update_attributes(:geography_trophy_p1 => flag) if user_id == self.player1_id
        self.update_attributes(:geography_trophy_p2 => flag) if user_id == self.player2_id
      when "Science"
        self.update_attributes(:science_trophy_p1 => flag) if user_id == self.player1_id
        self.update_attributes(:science_trophy_p2 => flag) if user_id == self.player2_id
      when "Sports"
        self.update_attributes(:sports_trophy_p1 => flag) if user_id == self.player1_id
        self.update_attributes(:sports_trophy_p2 => flag) if user_id == self.player2_id
    end
    self.save
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

  # TODO remove est method to award all trophies to player
  def give_all_trophies(user_id)
    self.update_attributes(:art_trophy_p1 => true, :entertainment_trophy_p1 => true, :history_trophy_p1 => true, :geography_trophy_p1 => true, :science_trophy_p1 => true, :sports_trophy_p1 => true)
    self.save!
  end

end