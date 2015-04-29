class Challenge < ActiveRecord::Base
  belongs_to :game
  CHALLENGE_YES = 'yes'
  CHALLENGE_NO = 'no'
  RESULT_TIE = 'tie'
  RESULT_WINNER = 'winner'
  MAX_NUM_QUESTIONS = 6
  TIE_ID_FLAG = 0

  def create_challenge(challenger_id, wager, prize)
    @game_challenge = Challenge.new
    @game_challenge.set_game_attributes(self.id, challenger_id, wager, prize)
    @game_challenge.generate_question_ids
    @game_challenge.save!
    @game_challenge
  end

  def generate_question_ids
    self.art_id = Question.random_question_id('Art')
    self.ent_id = Question.random_question_id('Entertainment')
    self.history_id = Question.random_question_id('History')
    self.geo_id = Question.random_question_id('Geography')
    self.science_id = Question.random_question_id('Science')
    self.sports_id = Question.random_question_id('Sports')
    self.save!
  end

  # TODO Rework this without using game attributes. 29 errors in test bc commented out.
=begin
  def set_game_attributes(game_id, challenger_id, wager, prize)
    self.game_id = game_id
    if challenger_id == self.challenge_game.player1_id
      self.challenger_id = self.challenge_game.player1_id
      self.opponent_id = self.challenge_game.player2_id
    else
      self.challenger_id = self.challenge_game.player2_id
      self.opponent_id = self.challenge_game.player1_id
    end
    self.wager = wager
    self.prize = prize
    self.save!
  end
=end

  def apply_to_challenge_round(user_id, result, challenge_id)
    challenge = Challenge.find(challenge_id)
    case result
      when Question::CORRECT
        challenge.add_correct_answer(user_id)
        if user_id == challenge.opponent_id
          # differentiate between normal round and bonus round. maybe use additional param
        end
        if user_id == challenge.challenger_id && challenge.max_correct?
          # change round to opponent here
        end
      when Question::INCORRECT
        # if challenger, change round to opponent here
      else
        # type code here
    end
  end

  def add_correct_answer(user_id)
    self.challenger_correct += 1 if user_id == self.challenger_id
    self.opponent_correct += 1 if user_id == self.opponent_id
    self.save!
  end

  def set_winner
    if self.challenger_winner?
      self.winner_id = self.challenger_id
    end
    if self.opponent_winner?
      self.winner_id = self.opponent_id
    end
    self.save!
  end

  def winner?
    #if self.tie?
    #  false
    #else
      challenger_winner? || opponent_winner?
    #end
  end

  def challenger_winner?
    self.check_score(self.challenger_correct, self.opponent_correct)
  end

  def opponent_winner?
    self.check_score(self.opponent_correct, self.challenger_correct)
  end

  def tie?
    self.challenger_correct == self.opponent_correct
  end

  def check_score(a, b)
    a > b #|| a == 6
  end

  def max_correct?
    self.challenger_correct == MAX_NUM_QUESTIONS || self.opponent_correct == MAX_NUM_QUESTIONS
  end

end
