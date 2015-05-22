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
      if @game.challenge_round?
        ask_another_question(@game.id)
      end
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
      @game.end_game(@game.opponent_id(current_user.id))
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
    @current_game = Game.find(game_id)
    @current_game.save!

    if @current_game.active? && @current_game.players_turn?(current_user.id)
      if @current_game.normal_round?
        @bonus = params[:bonus]
        @current_game.bonus = @bonus
        game_result = @current_game.apply_to_normal_round(subject, current_user.id, @result)
        if @current_game.players_turn?(current_user.id)
          back_to_game(@current_game.id)
        else
          if game_result == Game::GAME_OVER
            User.apply_game_result(@current_game.id, current_user.id)
          end
          back_to_index and return
        end
      elsif @current_game.challenge_round?
        @challenge = Challenge::get_ongoing_challenge_by_game(@current_game.id)
        if @challenge
          challenge_result = @challenge.apply_question_result(current_user.id, result, @current_game.bonus)
          if challenge_result == Challenge::RESULT_OPPONENT_TURN
            @current_game.end_round(current_user.id)
            back_to_index and return
          elsif challenge_result == Challenge::RESULT_TIE && current_user.id == @challenge.opponent_id
            @current_game.bonus = Game::BONUS_TRUE
            @current_game.save!
            ask_another_question(@current_game.id)
          elsif challenge_result == Challenge::RESULT_WINNER
            @current_game.apply_challenge_results(challenge_result, @challenge.winner_id, @challenge.wager, @challenge.prize)
            @current_game.end_round(current_user.id)
            back_to_index and return
          else
            ask_another_question(@current_game.id)
          end
        end
      end
    end
  end

  # pops the modal for the question
  def ask_question
    @game_id = params[:game_id]
    @current_game = Game.find(@game_id)
    @bonus = params[:bonus]

    if @current_game.normal_round?
      subject_title = params[:subject]
      @subject = subject_title
      @questions = Question.where("questions.subject_title" => subject_title)
      @question = @questions.shuffle.sample
    elsif @current_game.challenge_round?
      @challenge = Challenge::get_ongoing_challenge_by_game(@current_game.id)
      if @challenge
        @question = Question.find(@challenge.get_question_id_by_counter)
        @subject = @question.subject_title
      elsif @challenge.nil?
        wager = params[:wager]
        prize = params[:prize]
        @challenge = Challenge.create_challenge(@current_game.id, current_user.id, @current_game.opponent_id(current_user.id), wager, prize)
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



  def use_power_up_skip_question
    current_user.use_skip_question
  end

  def use_power_up_remove_wrong_answer
    current_user.use_remove_wrong_answer
  end

  def use_power_up_extra_time
    current_user.use_extra_time
  end

  ############################################################
  #####################     PRIVATE     ######################
  ############################################################

  # checks params for new game MUST UPDATE!!!
  private

  def back_to_game(game_id)
    redirect_to '/game/game?game_id=' + game_id.to_s
  end

  def back_to_index
    redirect_to '/game/index'
  end

  def ask_another_question(game_id)
    redirect_to '/game/ask_question?game_id=' + game_id.to_s
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

  def question_rating
    result = params[:result]
    subject = params[:subject]
    game_id = params[:game_id]
    bonus = params[:bonus]
    question_id = params[:question_id]
    rating = params[:rating]

    @question = Question.find(question_id)


    redirect_to 'game/question_rating?result=' + result + "&subject_title=" + subject + "&game_id=" + game_ID + "&bonus=" + bonus + "&question_id=" + question_id;
  end



end


