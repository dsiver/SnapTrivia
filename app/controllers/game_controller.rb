class GameController < ApplicationController

  def index
  end

  def game
    @game_id = params[:game_id]
    users = User.all
    if @game_id.to_i == -1
      player2_id = rand(users.length)
      @player2 = User.find(player2_id)
      @game = Game.new(player1_id: current_user.id, player2_id: @player2.id, player1_turn: true, game_over: false,
                       art_trophy_p1: false, entertainment_trophy_p1: false, history_trophy_p1: false,
                       geography_trophy_p1: false, science_trophy_p1: false, sports_trophy_p1: false,
                       art_trophy_p2: false, entertainment_trophy_p2: false, history_trophy_p2: false,
                       geography_trophy_p2: false, science_trophy_p2: false, sports_trophy_p2: false)
      @game.save!
    else
      if @game_id.to_i == 0
        @player2 = User.find(params[:player2_id])

        @game = Game.new(player1_id: current_user.id, player2_id: @player2.id, player1_turn: true, game_over: false,
                         art_trophy_p1: false, entertainment_trophy_p1: false, history_trophy_p1: false,
                         geography_trophy_p1: false, science_trophy_p1: false, sports_trophy_p1: false,
                         art_trophy_p2: false, entertainment_trophy_p2: false, history_trophy_p2: false,
                         geography_trophy_p2: false, science_trophy_p2: false, sports_trophy_p2: false)
        @game.save!
      else
        @game = Game.find(params[:game_id])
      end
    end
  end


  # Will show game stats for game
  def show
    @game = Game.find(params[:game_id])
  end

  def question_results
    result = params[:result]
    @result = result
    game_id = params[:game_id]
    subject = params[:subject_title]
    @user = User.find(current_user.id)
    @user.total_questions = @user.total_questions + 1
    @user.save!

    if result == 'CORRECT'
      @current_game = Game.find(game_id)
      count = @current_game.turn_count + 1
      answer_count = @current_game.answers_correct + 1
      @current_game.update_attributes(:turn_count => count, :answers_correct => answer_count)
      @current_game.save!

      if subject == "Art"
        @user = User.find(current_user.id)
        correct = @user.correct_questions + 1
        art_correct = @user.art_correct_count + 1
        art_total = @user.art_total_count + 1
        @user.update_attributes!(:correct_questions => correct, :art_correct_count => art_correct, :art_total_count => art_total)
        @user.save!
        @game_id = game_id
        redirect_to '/game/game?game_id=' + game_id
      end
      if subject == "Entertainment"
        @user = User.find(current_user.id)
        correct = @user.correct_questions + 1
        ent_correct = @user.entertainment_correct_count + 1
        ent_total = @user.entertainment_total_count + 1
        @user.update_attributes!(:correct_questions => correct, :entertainment_correct_count => ent_correct, :entertainment_total_count => ent_total)
        @user.save!
        @game_id = game_id
        redirect_to '/game/game?game_id=' + game_id
      end
      if subject == "History"
        @user = User.find(current_user.id)
        correct = @user.correct_questions + 1
        history_correct = @user.history_correct_count + 1
        history_total = @user.history_total_count + 1
        @user.update_attributes!(:correct_questions => correct, :history_correct_count => history_correct, :history_total_count => history_total)
        @user.save!
        @game_id = game_id
        redirect_to '/game/game?game_id=' + game_id
      end
      if subject == "Geography"
        @user = User.find(current_user.id)
        correct = @user.correct_questions + 1
        geography_correct = @user.geography_correct_count + 1
        geography_total = @user.geography_total_count + 1
        @user.update_attributes!(:correct_questions => correct, :geography_correct_count => geography_correct, :geography_total_count => geography_total)
        @user.save!
        @game_id = game_id
        redirect_to '/game/game?game_id=' + game_id
      end
      if subject == "Science"
        @user = User.find(current_user.id)
        correct = @user.correct_questions + 1
        science_correct = @user.science_correct_count + 1
        science_total = @user.science_total_count + 1
        @user.update_attributes!(:correct_questions => correct, :science_correct_count => science_correct, :science_total_count => science_total)
        @user.save!
        @game_id = game_id
        redirect_to '/game/game?game_id=' + game_id
      end
      if subject == "Sports"
        @user = User.find(current_user.id)
        correct = @user.correct_questions + 1
        sports_correct = @user.sports_correct_count + 1
        sports_total = @user.sports_total_count + 1
        @user.update_attributes!(:correct_questions => correct, :sports_correct_count => sports_correct, :sports_total_count => sports_total)
        @user.save!
        @game_id = game_id
        redirect_to '/game/game?game_id=' + game_id
      end
    elsif result == 'INCORRECT'
      @game = Game.find(game_id)
      @game.player1_turn=false
      if subject == "Art"
        @user = User.find(current_user.id)
        art_total = @user.art_total_count + 1
        @user.update_attribute(:art_total_count, art_total)
        @user.save!
        redirect_to '/game/index'
      end
      if subject == "Entertainment"
        @user = User.find(current_user.id)
        art_entertainment = @user.entertainment_total_count + 1
        @user.update_attribute(:entertainment_total_count, art_entertainment)
        @user.save!
        redirect_to '/game/index'
      end
      if subject == "History"
        @user = User.find(current_user.id)
        history_total = @user.history_total_count + 1
        @user.update_attribute(:history_total_count, history_total)
        @user.save!
        redirect_to '/game/index'
      end
      if subject == "Geography"
        @user = User.find(current_user.id)
        geography_total = @user.geography_total_count + 1
        @user.update_attribute(:geography_total_count, geography_total)
        @user.save!
        redirect_to '/game/index'
      end
      if subject == "Science"
        @user = User.find(current_user.id)
        science_total = @user.science_total_count + 1
        @user.update_attribute(:science_total_count, science_total)
        @user.save!
        redirect_to '/game/index'
      end
      if subject == "Sports"
        @user = User.find(current_user.id)
        sports_total = @user.sports_total_count + 1
        @user.update_attribute(:sports_total_count, sports_total)
        @user.save!
        redirect_to '/game/index'
      end
    end
  end

  # pops the modal for the question
  def ask_question
    subject_title = params[:subject_title]
    @game_id = params[:game_id]
    @subject = subject_title
    @question = Question.find_by_subject_title(subject_title)

    respond_to do |format|
      format.html
      format.xml { render :xml => @question }
    end
  end

  # Creates new game
  def new
  end


  # checks params for new game MUST UPDATE!!!
  private
  def game_params
    params.require(:game).permit(player1_id: current_user.id, player2_id: @player2.id)
  end
end


