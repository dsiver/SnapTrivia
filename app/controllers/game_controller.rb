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
                       geography_trophy_p2: false, science_trophy_p2: false, sports_trophy_p2: false);
      @game.save
    else
    if @game_id.to_i == 0
    @player2 = User.find( params[:player2_id] )

    @game = Game.new(player1_id: current_user.id, player2_id: @player2.id, player1_turn: true, game_over: false,
                     art_trophy_p1: false, entertainment_trophy_p1: false, history_trophy_p1: false,
                     geography_trophy_p1: false, science_trophy_p1: false, sports_trophy_p1: false,
                     art_trophy_p2: false, entertainment_trophy_p2: false, history_trophy_p2: false,
                     geography_trophy_p2: false, science_trophy_p2: false, sports_trophy_p2: false);
    @game.save
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

  def start_random_game

  end

  # checks params for new game MUST UPDATE!!!
  private
  def game_params
     params.require(:game).permit(player1_id: current_user.id, player2_id: @player2.id)
  end
end


