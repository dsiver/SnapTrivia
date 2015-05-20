class UserController < ApplicationController
  def show
  end

  def index
    name = params[:search]
  @search_results = current_user.playable_users_by_name(name)
  end
end
