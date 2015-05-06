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

  def end_game
    game_id = params[:game_id].to_i
    if game_id != 0
      @game = Game.find(game_id)
      @game.end_game
      back_to_index
    end
  end

  # Will challenge game stats for game
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
    @bonus = params[:bonus]
    @user = User.find(current_user.id)
    @user.total_questions = @user.total_questions + 1
    @user.save!
    @current_game = Game.find(game_id)
    @current_game.bonus = @bonus
    @current_game.save!

    if @current_game.active? && @current_game.players_turn?(current_user.id)
      if @current_game.normal_round?
        @current_game.apply_to_normal_round(subject, current_user.id, @result)
      end
    end
    if @current_game.players_turn?(current_user.id)
      back_to_game(game_id)
    else
      back_to_index
    end
  end

  # pops the modal for the question
  def ask_question
    subject_title = params[:subject]
    @game_id = params[:game_id]
    @bonus = params[:bonus]
    @current_game = Game.find(@game_id)
    if @current_game.normal_round?
      @subject = subject_title
      @questions = Question.where("questions.subject_title" => subject_title)
      @question = @questions.shuffle.sample
    end
    if @current_game.challenge_round?
      @challenge = Challenge::get_ongoing_challenge_by_game(@current_game.id)
      if(!@challenge.nil?)
        @question = Question.find(@challenge.get_question_id_by_counter)
        @subject = @question.subject_title
      end
    end
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

  # checks params for new game MUST UPDATE!!!
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

  def challenge
    @game_id = params[:game_id]
    redirect_to 'game/challenge'
  end

end


