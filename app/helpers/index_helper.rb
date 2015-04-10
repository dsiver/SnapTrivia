module IndexHelper

  def get_random_player(user_id)
    @users_with_exclusions = User.where("id != ? and  id != ?", 1, user_id)
    @random_player = @users_with_exclusions.shuffle.sample
  end

end