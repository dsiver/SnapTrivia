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
    @total_questions = User.pluck(:art_correct_count).inject(:+)
    @total_questions_correct = 0
    @art_total_questions = 0
    @art_questions_correct = 0
    @ent_total_questions = 0
    @ent_questions_correct = 0
    @geog_total_questions = 0
    @geog_questions_correct = 0
    @hist_total_questions = 0
    @hist_questions_correct = 0
    @science_total_questions = 0
    @science_questions_correct = 0
    @sports_total_questions = 0
    @sports_questions_correct = 0
  end


  def show
    @user = User.find(params[:user_id])
  end

  def index
    name = params[:search]
    @search_results = current_user.playable_users_by_name(name)
  end

end
