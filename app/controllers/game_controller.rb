# noinspection ALL
class GameController < ApplicationController
  include GameHelper

  def index
    @users_games = Game.games_by_user(current_user.id)
    @playable_users = Game.playable_users(current_user.id)
  end

  def update
    @game = Game.find(params[:id])
    @game.update_attributes!(params[:game])
    respond_to do |format|
      #format.html {redirect_to game_index_path}
      format.js
    end
  end

  # accepts game_id if 0 random user if 0 new game if game_id != 0  new game
  def game
    game_id = params[:game_id].to_i

    if game_id != 0
      @game = Game.find(game_id)
    elsif game_id.to_i == 0
      @player2 = User.find(params[:player2_id])
      @game = Game.new(player1_id: current_user.id, player2_id: @player2.id, player1_turn: true, game_status: 'active',
                       art_trophy_p1: false, entertainment_trophy_p1: false, history_trophy_p1: false,
                       geography_trophy_p1: false, science_trophy_p1: false, sports_trophy_p1: false,
                       art_trophy_p2: false, entertainment_trophy_p2: false, history_trophy_p2: false,
                       geography_trophy_p2: false, science_trophy_p2: false, sports_trophy_p2: false)
      @game.save!
    end
  end

  # Will show game stats for game
  def show
    @game = Game.find(params[:game_id])
  end

  # accepts result, game_id, and subject_title increments current_game.turn_count current_game.answers_correct
  # user.subject_total user_correct_questions
  def question_results
    result = params[:result]
    @result = result
    game_id = params[:game_id]
    subject = params[:subject_title]
    @user = User.find(current_user.id)
    @user.total_questions = @user.total_questions + 1
    @user.save!
    @current_game = Game.find(game_id)

    if @current_game.active? && @current_game.players_turn?(current_user.id)
      if @current_game.normal_round?
        @current_game.apply_to_normal_round(subject, current_user.id, @result)
      end
      if @current_game.players_turn?(current_user.id)
        back_to_game(game_id)
      else
        back_to_index
      end
    end
=begin
    elsif result == 'INCORRECT'

      count = @current_game.turn_count += 1
      @current_game.save!
      if subject == "Art"
        art_total = @user.art_total_count + 1
        @user.update_attribute(:art_total_count, art_total)
      end
      if subject == "Entertainment"
        art_entertainment = @user.entertainment_total_count + 1
        @user.update_attribute(:entertainment_total_count, art_entertainment)
      end
      if subject == "History"
        history_total = @user.history_total_count + 1
        @user.update_attribute(:history_total_count, history_total)
      end
      if subject == "Geography"
        geography_total = @user.geography_total_count + 1
        @user.update_attribute(:geography_total_count, geography_total)
      end
      if subject == "Science"
        science_total = @user.science_total_count + 1
        @user.update_attribute(:science_total_count, science_total)
      end
      if subject == "Sports"
        sports_total = @user.sports_total_count + 1
        @user.update_attribute(:sports_total_count, sports_total)
      end
      @user.save!
      @current_game.update_attributes(:bonus => "false")
      @current_game.end_round(@user.id, count)

      redirect_to '/game/index'

    end
=end
  end

  # pops the modal for the question
  def ask_question
    subject_title = params[:subject_title]
    bonus = params[:bonus]
    @game_id = params[:game_id]
    @game = Game.find(@game_id)
    @game.save!
    @game.update_attributes!(:bonus => bonus)
    @subject = subject_title
    @questions = Question.where("questions.subject_title" => subject_title)
    @question = @questions.shuffle.sample
    # set game.bonus to bonus param
    respond_to do |format|
      format.html
      format.xml { render :xml => @question }
    end
  end

  # Creates new game
  def new
  end

  def merit
    # needed for merit to be able to give power_ups
  end

  def end_game
    game_id = params[:game_id].to_i
    if game_id != 0
      @game = Game.find(game_id)
      @game.end_game
      back_to_index
    end
  end

  private

  def back_to_game(game_id)
    redirect_to '/game/game?game_id=' + game_id
  end

  def back_to_index
    redirect_to '/game/index'
  end

  def game_params
    params.require(:game).permit(player1_id: current_user.id, player2_id: @player2.id)
  end

  def answer_from_bonus?(flag)
    flag
  end

end


