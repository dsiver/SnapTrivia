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
  def can_challenge?(challenger_id, wager, prize)
    if self.neither_have_trophies?
      false
    elsif
      self.one_has_no_trophies?
      false
    elsif
      self.same_trophies?
      false
    elsif
      !self.same_trophies?
      !no_winnable_trophies?(challenger_id, wager)
    end
  end

  def no_winnable_trophies?(challenger_id, wager)
    case challenger_id
      when self.player1_id
        p1_trophies_minus_wager = self.player1_trophies.select{|trophy| trophy != wager}
        stripped_trophies_equal?(self.player1_id, p1_trophies_minus_wager)
      when self.player2_id
        p2_trophies_minus_wager = self.player2_trophies.select{|trophy| trophy != wager}
        stripped_trophies_equal?(self.player2_id, p2_trophies_minus_wager)
    end
  end

  def neither_have_trophies?
    return true if self.player1_trophies.count < 1 && self.player2_trophies.count < 1
    false
  end

  def one_has_no_trophies?
    return true if self.player1_trophies.count == 0 || self.player2_trophies.count == 0
  end

  def both_more_than_1_trophy?
    return true if self.player1_trophies.count > 1 && self.player2_trophies.count > 1
    false
  end

  def both_have_one_trophy?
    return true if self.player1_trophies.count == 1 && self.player2_trophies.count == 1
    false
  end

  def same_trophies?
    return true if self.player1_trophies.eql?(self.player2_trophies) if !self.neither_have_trophies?
    false
  end

  private

  def stripped_trophies_equal?(player_id, stripped_trophies)
    case player_id
      when self.player1_id
        stripped_trophies.eql?(self.player2_trophies)
      when self.player2_id
        stripped_trophies.eql?(self.player1_trophies)
    end
  end

  def do_something
    # self.column_name = column_new_value
  end

end