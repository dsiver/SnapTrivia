class GameController < ApplicationController
  include GameHelper

  def index
  end

  # accepts game_id if 0 random user if 0 new game if game_id != 0  new game
  def game
    game_id = params[:game_id].to_i

    if game_id != 0
      @game = Game.find(game_id)
      @player2_trophies = get_player2_trophies(@game)
      @player1_trophies = get_player1_trophies(@game)
    elsif game_id.to_i == 0
      @player2 = User.find(params[:player2_id])
      @game = Game.new(player1_id: current_user.id, player2_id: @player2.id, player1_turn: true, game_status: 'active',
                       art_trophy_p1: false, entertainment_trophy_p1: false, history_trophy_p1: false,
                       geography_trophy_p1: false, science_trophy_p1: false, sports_trophy_p1: false,
                       art_trophy_p2: false, entertainment_trophy_p2: false, history_trophy_p2: false,
                       geography_trophy_p2: false, science_trophy_p2: false, sports_trophy_p2: false)
      @player2_trophies = get_player2_trophies(@game)
      @player1_trophies = get_player1_trophies(@game)
      @game.save!
    end
  end


  # Will show game stats for game
  def show
    @game = Game.find(params[:game_id])
  end

  # accepts result, game_id, and subject_title increments current_game.turn_count current_game.answers_correct user.subject_total user_correct_questions
  def question_results
    result = params[:result]
    @result = result
    game_id = params[:game_id]
    subject = params[:subject_title]
    @user = User.find(current_user.id)
    @user.total_questions = @user.total_questions + 1
    @user.save!
    @current_game = Game.find(game_id)
    count = @current_game.turn_count + 1

    #answer_count = @current_game.answers_correct

    @user = User.find(current_user.id)

    if result == 'CORRECT'
      @current_game.answers_correct += 1
      @current_game.save!
      #@current_game.update_attributes(:turn_count => count, :answers_correct => answer_count)

      # TODO REMOVE DIAGNOSTIC
      # give_trophy(@current_game, subject, @user)

      @current_game.update_attributes(:turn_count => count)
      @current_game.save!

      if subject == "Art"
        correct = @user.correct_questions + 1
        art_correct = @user.art_correct_count + 1
        art_total = @user.art_total_count + 1
        @user.update_attributes!(:correct_questions => correct, :art_correct_count => art_correct, :art_total_count => art_total)
        #@game_id = game_id
      end
      if subject == "Entertainment"
        correct = @user.correct_questions + 1
        ent_correct = @user.entertainment_correct_count + 1
        ent_total = @user.entertainment_total_count + 1
        @user.update_attributes!(:correct_questions => correct, :entertainment_correct_count => ent_correct, :entertainment_total_count => ent_total)
        #@game_id = game_id
      end
      if subject == "History"
        correct = @user.correct_questions + 1
        history_correct = @user.history_correct_count + 1
        history_total = @user.history_total_count + 1
        @user.update_attributes!(:correct_questions => correct, :history_correct_count => history_correct, :history_total_count => history_total)
        #@game_id = game_id
      end
      if subject == "Geography"
        correct = @user.correct_questions + 1
        geography_correct = @user.geography_correct_count + 1
        geography_total = @user.geography_total_count + 1
        @user.update_attributes!(:correct_questions => correct, :geography_correct_count => geography_correct, :geography_total_count => geography_total)
        #@game_id = game_id
      end
      if subject == "Science"
        correct = @user.correct_questions + 1
        science_correct = @user.science_correct_count + 1
        science_total = @user.science_total_count + 1
        @user.update_attributes!(:correct_questions => correct, :science_correct_count => science_correct, :science_total_count => science_total)
        #@game_id = game_id
      end
      if subject == "Sports"
        correct = @user.correct_questions + 1
        sports_correct = @user.sports_correct_count + 1
        sports_total = @user.sports_total_count + 1
        @user.update_attributes!(:correct_questions => correct, :sports_correct_count => sports_correct, :sports_total_count => sports_total)
        #@game_id = game_id
      end
      #sleep(2)
      @user.save!
      @game_id = game_id

      # TODO detect if coming from spinner landing on bonus
      # TODO detect if coming from challenge

      # Checks for 4th correct answer and awards trophy
      if @current_game.answers_correct == 4
        give_trophy(@current_game, subject, @user)
      end

      # TODO remove this diagnostic
      #give_all_trophies(@current_game, @user)

      if player_wins?(@current_game, @user.id)
        end_game(@current_game)
        back_to_index and return
      end

      back_to_game(game_id)

    elsif result == 'INCORRECT'
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
      end_round(@current_game, @user)
      redirect_to '/game/index'
    end
  end

  # pops the modal for the question
  def ask_question
    subject_title = params[:subject_title]
    @game_id = params[:game_id]
    @subject = subject_title
    @questions = Question.where("questions.subject_title" => subject_title)
    @question = @questions.shuffle.sample

    respond_to do |format|
      format.html
      format.xml { render :xml => @question }
    end
  end

  # Creates new game
  def new
  end

  def get_player1_trophies(game)
    #@player1_trophies = Game.select(:art_trophy_p1, :entertainment_trophy_p1, :history_trophy_p1, :geography_trophy_p1, :science_trophy_p1, :sports_trophy_p1).to_a
    #@player1_trophies = @player1_trophies.keep_if{|value| value == true}
    player1_trophies = Array.new
    player1_trophies << "Art" if game.art_trophy_p1?
    player1_trophies << "Entertainment" if game.entertainment_trophy_p1?
    player1_trophies << "History" if game.history_trophy_p1?
    player1_trophies << "Geography" if game.geography_trophy_p1?
    player1_trophies << "Science" if game.science_trophy_p1?
    player1_trophies << "Sports" if game.sports_trophy_p1?
    return player1_trophies
  end

  def get_player2_trophies(game)
    #@player2_trophies = Game.select(:art_trophy_p2, :entertainment_trophy_p2, :history_trophy_p2, :geography_trophy_p2, :science_trophy_p2, :sports_trophy_p2).to_a
    #@player2_trophies = @player2_trophies.keep_if{|value| value == true}
    player2_trophies = Array.new
    player2_trophies << "Art" if game.art_trophy_p2?
    player2_trophies << "Entertainment" if game.entertainment_trophy_p2?
    player2_trophies << "History" if game.history_trophy_p2?
    player2_trophies << "Geography" if game.geography_trophy_p2?
    player2_trophies << "Science" if game.science_trophy_p2?
    player2_trophies << "Sports" if game.sports_trophy_p2?
    return player2_trophies
  end

  def get_wagerable_trophies(game, player_id)
  end

  def get_winnable_trophies(game, player_id)
  end

  # Checks to see if the current player can start a challenge
  # Looks at current player and opponents trophies to see if
  # challenge can start
  def can_challenge?(game, challenger_id)
    if both_have_only_one_trophy?
      if same_trophies?
        return false
      end
    else
      return true
    end
  end
  
  def play_challenge(wager, prize)
  end

  # checks params for new game MUST UPDATE!!!
  private

  def both_have_only_one_trophy?
    return @player1_trophies.count == 1 && @player2_trophies.count == 1
  end

  def same_trophies?
  end

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
  end

  def play_bonus(game, subject, user)
  end

  def give_trophy(game, subject, user)
    case subject
      when "Art"
        game.update_attributes(:art_trophy_p1 => true) if user.id == game.player1_id
        game.update_attributes(:art_trophy_p2 => true) if user.id == game.player2_id
      when "Entertainment"
        game.update_attributes(:entertainment_trophy_p1 => true) if user.id == game.player1_id
        game.update_attributes(:entertainment_trophy_p2 => true) if user.id == game.player2_id
      when "History"
        game.update_attributes(:history_trophy_p1 => true) if user.id == game.player1_id
        game.update_attributes(:history_trophy_p2 => true) if user.id == game.player2_id
      when "Geography"
        game.update_attributes(:geography_trophy_p1 => true) if user.id == game.player1_id
        game.update_attributes(:geography_trophy_p2 => true) if user.id == game.player2_id
      when "Science"
        game.update_attributes(:science_trophy_p1 => true) if user.id == game.player1_id
        game.update_attributes(:science_trophy_p2 => true) if user.id == game.player2_id
      when "Sports"
        game.update_attributes(:sports_trophy_p1 => true) if user.id == game.player1_id
        game.update_attributes(:sports_trophy_p2 => true) if user.id == game.player2_id
    end
    game.save!
    user.save!
    reset_answers(game)
  end

  def reset_answers(game)
    game.update_attributes(:answers_correct => 0)
    game.save!
  end

  def end_round(game, user)
    game.update_attributes(:player1_turn => false, :answers_correct => 0) if user.id == game.player1_id
    game.update_attributes(:player1_turn => true, :answers_correct => 0) if user.id == game.player2_id
    game.save!
    user.save!
  end

  def end_game(game)
    game.update_attributes(:game_status => 'game_over')
    game.save!
  end

  # Checks to see if player has all trophies
  def player_wins?(game, player_id)
    case player_id
      when game.player1_id
        return game.art_trophy_p1 && game.entertainment_trophy_p1 && game.history_trophy_p1 && game.geography_trophy_p1 && game.science_trophy_p1 && game.sports_trophy_p1
      when game.player2_id
        return game.art_trophy_p2 && game.entertainment_trophy_p2 && game.history_trophy_p2 && game.geography_trophy_p2 && game.science_trophy_p2 && game.sports_trophy_p2
    end
  end

  # TODO remove est method to award all trophies to player
  def give_all_trophies(game, user)
    game.update_attributes(:art_trophy_p1 => true, :entertainment_trophy_p1 => true, :history_trophy_p1 => true, :geography_trophy_p1 => true, :science_trophy_p1 => true, :sports_trophy_p1 => true)
    game.save!
  end

=begin
  def get_player_badges(player)
    player.badges.select do |badge|
      badge.custom_fields[:type] == "game_round"
    end
  end

  def give_player_bonus(subject, user)
    # Badge ID's
    art = 2, entertainment = 3, history = 4, geography = 5, science = 6, sports = 7

    case subject
      when "Art"
        user.add_badge(art) unless user.badges.any? { |badge| badge.id == art }
      when "Entertainment"
        user.add_badge(entertainment) unless user.badges.any? { |badge| badge.id == entertainment }
      when "History"
        user.add_badge(history) unless user.badges.any? { |badge| badge.id == history }
      when "Geography"
        user.add_badge(geography) unless user.badges.any? { |badge| badge.id == geography }
      when "Science"
        user.add_badge(science) unless user.badges.any? { |badge| badge.id == science }
      when "Sports"
        user.add_badge(sports) unless user.badges.any? { |badge| badge.id == sports }
    end
  end

  def remove_player_bonuses(user)
    # Badge ID's
    art = 2, entertainment = 3, history = 4, geography = 5, science = 6, sports = 7
    user.rm_badge(art) if user.badges.any? { |badge| badge.id == art }
    user.rm_badge(entertainment) if user.badges.any? { |badge| badge.id == entertainment }
    user.rm_badge(history) if user.badges.any? { |badge| badge.id == history }
    user.rm_badge(geography) if user.badges.any? { |badge| badge.id == geography }
    user.rm_badge(science) if user.badges.any? { |badge| badge.id == science }
    user.rm_badge(sports) if user.badges.any? { |badge| badge.id == sports }
  end
=end
end


