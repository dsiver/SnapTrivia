class Game < ActiveRecord::Base
  belongs_to :player1, :class_name => 'User', :foreign_key => 'player1_id'
  belongs_to :player2, :class_name => 'User', :foreign_key => 'player2_id'

  validates :player1_id, presence: true
  validates :player2_id, presence: true

  # Verifies that player one and teo are different
  def self.verify_different_players
    errors.add(:player2, "Player 1 and Player 2 must be different users") if :player1_id == :player2_id
  end

  # gets active games by user id
  def self.get_user_games_active(user_id)
    games = Game.where('player1_id=? or player2_id=?', user_id, user_id)
    @active_games = games.where('game_status=?', 'active')
  end

  # gets finished games by user id
  def self.get_user_game_history(user_id)
    games = Game.where('player1_id=? or player2_id=?', user_id, user_id)
    @active_games = games.where('game_status=?', 'game_over')
  end

end
