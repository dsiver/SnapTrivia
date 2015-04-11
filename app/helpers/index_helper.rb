module IndexHelper

  def get_random_player(user_id)
    @users_with_exclusions = User.where("id != ? and  id != ?", 1, user_id)
    @random_player = @users_with_exclusions.shuffle.sample
  end

  # gets active games by user id
  def get_user_games_active(user_id)
    games = Game.where('player1_id=? or player2_id=?', user_id, user_id)
    @active_games = games.where('game_status=?', 'active')
  end

  # gets finished games by user id
  def get_user_game_history(user_id)
    games = Game.where('player1_id=? or player2_id=?', user_id, user_id)
    @active_games = games.where('game_status=?', 'game_over')
  end

  def get_playable_users(user_id)
    @users_with_exclusions = User.where("id != ? and  id != ?", 1, user_id)
  end


end