class StatisticsController < ApplicationController
  include IndexHelper

  def new
  end

  def user_stats
    @user = User.find(current_user.id)
    @users = User.all.where.not(id: [1, current_user.id]).map { |u| [ u.name, u.id ] }
    if params[:user_id].present?
      @data = User.find(params[:user_id])
    end
  end

  def current_user_games
    @current_user_games = get_user_game_history(current_user.id)
  end

  def opponent_games
    @opponent_games = get_user_game_history(@data)
  end

  def site_stats
    @month_id = params[:month_id]
    @category_header = "Average of Questions Answered Correctly by Category"
  end

  def show
    @user = User.find(params[:user_id])
    @current_user = current_user
  end

  def index
    name = params[:search]
    @search_results = current_user.playable_users_by_name(name)
    @playable_users = Game.playable_users(current_user.id)
  end

end
