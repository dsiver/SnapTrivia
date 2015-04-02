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
      stats = PlayerStat.where("player_stats.userId" => current_user.id)
      if stats.size < 1
        stats = PlayerStat.new(userId: current_user.id, art_correct_count: 0, art_total_count: 0, entertainment_correct_count: 0, entertainment_total_count: 0,
                               geography_correct_count: 0, geography_total_count: 0, history_correct_count: 0, history_total_count: 0, science_correct_count: 0,
                               science_total_count: 0, sports_correct_count: 0, sports_total_count: 0, score: 0, next_lvl_score: 0, level: 1, total_games: 0, total_wins: 0)
        stats.save!
      end
      stats = PlayerStat.where("player_stats.userId" => player2_id)
      if stats.size < 1
        stats = PlayerStat.new(userId: player2_id, art_correct_count: 0, art_total_count: 0, entertainment_correct_count: 0, entertainment_total_count: 0,
                               geography_correct_count: 0, geography_total_count: 0, history_correct_count: 0, history_total_count: 0, science_correct_count: 0,
                               science_total_count: 0, sports_correct_count: 0, sports_total_count: 0, score: 0, next_lvl_score: 0, level: 1, total_games: 0, total_wins: 0)
        stats.save!
      end
    else
      if @game_id.to_i == 0
        @player2 = User.find(params[:player2_id])

        @game = Game.new(player1_id: current_user.id, player2_id: @player2.id, player1_turn: true, game_over: false,
                         art_trophy_p1: false, entertainment_trophy_p1: false, history_trophy_p1: false,
                         geography_trophy_p1: false, science_trophy_p1: false, sports_trophy_p1: false,
                         art_trophy_p2: false, entertainment_trophy_p2: false, history_trophy_p2: false,
                         geography_trophy_p2: false, science_trophy_p2: false, sports_trophy_p2: false)
        @game.save!
        stats = PlayerStat.where("player_stats.userId" => current_user.id)
        if stats.size < 1
          stats = PlayerStat.new(userId: current_user.id, art_correct_count: 0, art_total_count: 0, entertainment_correct_count: 0, entertainment_total_count: 0,
                                 geography_correct_count: 0, geography_total_count: 0, history_correct_count: 0, history_total_count: 0, science_correct_count: 0,
                                 science_total_count: 0, sports_correct_count: 0, sports_total_count: 0, score: 0, next_lvl_score: 0, level: 1, total_games: 0, total_wins: 0)
          stats.save!
        end
        stats = PlayerStat.where("player_stats.userId" => player2_id)
        if stats.size < 1
          stats = PlayerStat.new(userId: player2_id, art_correct_count: 0, art_total_count: 0, entertainment_correct_count: 0, entertainment_total_count: 0,
                                 geography_correct_count: 0, geography_total_count: 0, history_correct_count: 0, history_total_count: 0, science_correct_count: 0,
                                 science_total_count: 0, sports_correct_count: 0, sports_total_count: 0, score: 0, next_lvl_score: 0, level: 1, total_games: 0, total_wins: 0)
          stats.save!
        end
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
    game_id = params[:game_id]
    subject = params[:subject_title]

    if result
      Game.IncrementAmountCorrect(game_id)
      PlayerStat.IncrementSubjectCorrectCount(current_user.id, subject)
      PlayerStat.IncrementSubjectTotalCount(current_user.id, subject)

      @game_id = game_id
      redirect_to game/game_path
    else

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

  def start_random_game

  end

  # checks params for new game MUST UPDATE!!!
  private
  def game_params
    params.require(:game).permit(player1_id: current_user.id, player2_id: @player2.id)
  end
end


