module GameHelper
  def player_turn?(game, player_id)
    player1_turn = game.player1_turn?
    player1_id = game.player1_id
    player2_id = game.player2_id
    if player1_turn == true
      return true
    else
      return false
    end if player_id == player1_id
    if player1_turn == true
      return false
    else
      return true
    end if player_id == player2_id
  end
end
