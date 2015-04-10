module IndexHelper

  def get_random_player(user_id)
    @users_with_exclusions = User.where("id != ? and  id != ?", 1, user_id)
    @random_player = @users_with_exclusions.shuffle.sample
  end
=begin
  # gets active games by user id
  def get_user_games_active(user_id)
    Game.where('player1_id=? or player2_id=? and game_over = false', user_id, user_id)
  end

  # gets finished games by user id
  def get_user_game_history(user_id)
    Game.where('player1_id=? or player2_id=? and game_over = true', user_id, user_id)
  end
=end
end