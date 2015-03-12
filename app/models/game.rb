class Game < ActiveRecord::Base
  belongs_to :player1, :class_name => 'User', :foreign_key => 'player1_id'
  belongs_to :player2, :class_name => 'User', :foreign_key => 'player2_id'

  validates :player1_id, presence: true
  validates :player2_id, presence: true



  def verify_different_players
    errors.add(:player2, "Player 1 and Player 2 must be different users") if player1==player2
  end


end