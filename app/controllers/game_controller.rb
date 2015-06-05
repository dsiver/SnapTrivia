# noinspection ALL
class GameController < ApplicationController
  include GameHelper

  def index
    @active_games = Game.active_games_by_user(current_user.id)
    @finished_games = Game.finished_games_by_user(current_user.id)
    @playable_users = Game.playable_users(current_user.id)
    if current_user.unread_messages.count > 0
      flash.alert = 'You have unread messages'
    end

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
      unless @game.active?
        flash.notice = 'The game is over.'
        back_to_index
      end
      unless @game.players_turn?(current_user.id)
        back_to_index
      end
      @opponent = @game.opponent(current_user.id)
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
      @game_stat = GameStat.new(game_id: @game.id)
      @game_stat.save!
      @opponent = @game.opponent(current_user.id)
    end
  end

  def end_game
    game_id = params[:game_id].to_i
    if game_id != 0
      @game = Game.find(game_id)
      if @game.active?
        @game.end_game(@game.opponent_id(current_user.id))
      else
        notice = 'The game already ended'
        if @game.winner_id == current_user.id
          notice += '. You won!'
        else
          notice += '.'
        end
        flash.notice = notice
      end
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
      @current_game.game_stat.apply_question_result(subject, result)
      applied_result = current_user.apply_question_results(subject, result)
      check_question_result(applied_result)
      if @current_game.normal_round?
        @bonus = params[:bonus]
        @current_game.bonus = @bonus
        game_result = @current_game.apply_to_normal_round(subject, current_user.id, @result)
        if game_result == Game::TIE
          @current_game.update_attributes(game_status: Game::ACTIVE, bonus: Game::BONUS_FALSE)
          @current_game.save
          wager = @current_game.get_wagerable_trophies(current_user.id).first
          prize = @current_game.get_winnable_trophies(current_user.id).first
          @challenge = Challenge.create_challenge(@current_game.id, current_user.id, @current_game.opponent_id(current_user.id), wager, prize)
          @challenge.save
          redirect_to game_ask_question_path and return
        end
        if @current_game.finished?
          current_user.apply_game_result(@current_game.id)
          @current_game.opponent(current_user.id).apply_game_result(@current_game.id)
          notify_game_outcome(@current_game)
          back_to_index and return
        elsif @current_game.players_turn?(current_user.id)
          back_to_game(@current_game.id)
        else
          check_new_game
          back_to_index and return
        end
      elsif @current_game.challenge_round?
        @challenge = Challenge::get_ongoing_challenge_by_game(@current_game.id)
        if @challenge
          if @challenge.valid_challenge?
            challenge_result = @challenge.apply_question_result(current_user.id, result, @current_game.bonus)
            if challenge_result == Challenge::RESULT_OPPONENT_TURN
              @current_game.increase_turn_count
              @current_game.end_round(current_user.id)
              back_to_index and return
            elsif challenge_result == Challenge::RESULT_TIE && current_user.id == @challenge.opponent_id
              @current_game.bonus = Game::BONUS_TRUE
              @current_game.save!
              ask_another_question(@current_game.id)
            elsif challenge_result == Challenge::RESULT_WINNER
              @current_game.apply_challenge_results(challenge_result, @challenge.challenger_id, @challenge.winner_id, @challenge.wager, @challenge.prize)
              notify_challenge_outcome(@challenge)
              @current_game.end_challenge(current_user.id)
              @current_game.increase_turn_count
              @current_game.end_round(current_user.id)
              back_to_index and return
            else
              ask_another_question(@current_game.id)
            end
          else
            redirect_to game_challenge_path(:game_id => @current_game.id)
          end
        else
          redirect_to game_challenge_path(:game_id => @current_game.id)
        end
      end
    else
      back_to_index
    end
  end

  def check_new_game
    if @current_game.turn_count == 1 && current_user == @current_game.player1 && !@current_game.player1_turn?
      UserMailer.new_game_email(@current_game.player2, @current_game).deliver
    end
  end

  # pops the modal for the question
  def ask_question
    @game_id = params[:game_id]
    @current_game = Game.find(@game_id)
    @bonus = params[:bonus]
    unless @current_game.players_turn?(current_user.id)
      back_to_index and return
    end

    if @current_game.normal_round?
      subject_title = params[:subject]
      @subject = subject_title
      @questions = Question.questions_by_user_experience(current_user.experience_level, @subject)
      @question = @questions.sample
    elsif @current_game.challenge_round?
      @challenge = Challenge::get_ongoing_challenge_by_game(@current_game.id)
      if @challenge
        @question = Question.find(@challenge.get_question_id_by_counter)
        @subject = @question.subject_title
      elsif @challenge.nil?
        wager = params[:wager]
        prize = params[:prize]
        if wager && prize
          @challenge = Challenge.create_challenge(@current_game.id, current_user.id, @current_game.opponent_id(current_user.id), wager, prize)
        else
          redirect_to game_challenge_path(:game_id => @current_game.id)
        end
      end
    end
    if @question
      respond_to do |format|
        format.html
        format.xml { render :xml => @question }
      end
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

  def notify_game_outcome(game)
    if game.winner_id == current_user.id
      flash.notice = 'You won the game!'
    else
      flash.alert = game.opponent(current_user.id).name + ' won the game.'
    end
  end

  def notify_challenge_outcome(challenge)
    won_notice = 'You won the challenge!'
    lost_notice = 'You lost the challenge.'
    if challenge.winner_id == current_user.id
      flash.notice = won_notice
    else
      flash.alert = lost_notice
    end
  end

  def check_question_result(result)
    case result
      when User::NEW_LEVEL
        flash.notice = 'You leveled up!'
      when Merit::BadgeRules::BEGINNER
        flash.notice = 'You achieved ' + Merit::BadgeRules::BEGINNER + ' experience level!'
      when Merit::BadgeRules::INTERMEDIATE
        flash.notice = 'You achieved ' + Merit::BadgeRules::INTERMEDIATE + ' experience level!'
      when Merit::BadgeRules::ADVANCED
        flash.notice = 'You achieved ' + Merit::BadgeRules::ADVANCED + ' experience level!'
      when Merit::BadgeRules::EXPERT
        flash.notice = 'You achieved ' + Merit::BadgeRules::EXPERT + ' experience level!'
    end
  end

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


