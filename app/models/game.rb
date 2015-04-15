class Game < ActiveRecord::Base

  belongs_to :player1, :class_name => 'User', :foreign_key => 'player1_id'
  belongs_to :player2, :class_name => 'User', :foreign_key => 'player2_id'

  validates :player1_id, presence: true
  validates :player2_id, presence: true

  # Verifies that player one and teo are different
  def self.verify_different_players
    errors.add(:player2, "Player 1 and Player 2 must be different users") if :player1_id == :player2_id
  end

  def player1_trophies
    @player1_trophies = Array.new
    @player1_trophies << "Art" if self.art_trophy_p1 == true
    @player1_trophies << "Entertainment" if self.entertainment_trophy_p1 == true
    @player1_trophies << "History" if self.history_trophy_p1 == true
    @player1_trophies << "Geography" if self.geography_trophy_p1 == true
    @player1_trophies << "Science" if self.science_trophy_p1 == true
    @player1_trophies << "Sports" if self.sports_trophy_p1 == true
    return @player1_trophies
  end

  def player2_trophies
    @player2_trophies = Array.new
    @player2_trophies << "Art" if self.art_trophy_p2 == true
    @player2_trophies << "Entertainment" if self.entertainment_trophy_p2 == true
    @player2_trophies << "History" if self.history_trophy_p2 == true
    @player2_trophies << "Geography" if self.geography_trophy_p2 == true
    @player2_trophies << "Science" if self.science_trophy_p2 == true
    @player2_trophies << "Sports" if self.sports_trophy_p2 == true
    return @player2_trophies
  end

  # Checks to see if the current player can start a challenge
  # Looks at current player and opponents trophies to see if
  # challenge can start
  def can_challenge?
    no_winnable_trophies?
  end

  def get_winnable_trophies(player_id)
    case player1_id
      when self.player1_id
        return self.player2_trophies - self.player1_trophies
      when self.player2_id
        return self.player1_trophies - self.player2_trophies
    end
  end

  def get_wagerable_trophies(player_id)
    case player1_id
      when self.player1_id
        return self.player1_trophies - self.player2_trophies
      when self.player2_id
        return self.player2_trophies - self.player1_trophies
    end
  end

  def play_challenge(challenger_id, wager, prize)

  end

  def give_trophy(subject, user_id)
    case subject
      when "Art"
        self.update_attributes(:art_trophy_p1 => true) if user_id == self.player1_id
        self.update_attributes(:art_trophy_p2 => true) if user_id == self.player2_id
      when "Entertainment"
        self.update_attributes(:entertainment_trophy_p1 => true) if user_id == self.player1_id
        self.update_attributes(:entertainment_trophy_p2 => true) if user_id == self.player2_id
      when "History"
        self.update_attributes(:history_trophy_p1 => true) if user_id == self.player1_id
        self.update_attributes(:history_trophy_p2 => true) if user_id == self.player2_id
      when "Geography"
        self.update_attributes(:geography_trophy_p1 => true) if user_id == self.player1_id
        self.update_attributes(:geography_trophy_p2 => true) if user_id == self.player2_id
      when "Science"
        self.update_attributes(:science_trophy_p1 => true) if user_id == self.player1_id
        self.update_attributes(:science_trophy_p2 => true) if user_id == self.player2_id
      when "Sports"
        self.update_attributes(:sports_trophy_p1 => true) if user_id == self.player1_id
        self.update_attributes(:sports_trophy_p2 => true) if user_id == self.player2_id
    end
    self.update_attributes(:answers_correct => 0)
    self.save!
  end

  def end_round(user_id, count)
    self.update_attributes(:player1_turn => false, :answers_correct => 0) if user_id == self.player1_id
    self.update_attributes(:player1_turn => true, :answers_correct => 0) if user_id == self.player2_id
    self.update_attributes(:turn_count => count)
    self.save!
  end

  def end_game
    self.update_attributes(:self_status => 'game_over')
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