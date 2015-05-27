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
=begin
    @total_questions = User.pluck(:art_correct_count).inject(:+)
    @total_questions_correct = User.pluck(:art_correct_count).inject(:+)
    @art_total_questions = User.pluck(:art_correct_count).inject(:+)
    @art_questions_correct = User.pluck(:art_correct_count).inject(:+)
    @ent_total_questions = User.pluck(:art_correct_count).inject(:+)
    @ent_questions_correct = User.pluck(:art_correct_count).inject(:+)
    @geog_total_questions = User.pluck(:art_correct_count).inject(:+)
    @geog_questions_correct = User.pluck(:art_correct_count).inject(:+)
    @hist_total_questions = User.pluck(:art_correct_count).inject(:+)
    @hist_questions_correct = User.pluck(:art_correct_count).inject(:+)
    @science_total_questions = User.pluck(:art_correct_count).inject(:+)
    @science_questions_correct = User.pluck(:art_correct_count).inject(:+)
    @sports_total_questions = User.pluck(:art_correct_count).inject(:+)
    @sports_questions_correct = User.pluck(:art_correct_count).inject(:+)
=end
  end

  def show
    @user = User.find(params[:user_id])
  end

  def index
    name = params[:search]
    @search_results = current_user.playable_users_by_name(name)
  end

end
