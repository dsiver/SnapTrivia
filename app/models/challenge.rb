class Challenge < ActiveRecord::Base
  belongs_to :game
  after_initialize :init
  CHALLENGE_YES = 'yes'
  CHALLENGE_NO = 'no'
  RESULT_OPPONENT_TURN = 'opponent_turn'
  RESULT_TIE = 'tie'
  RESULT_WINNER = 'winner'
  MAX_NUM_QUESTIONS_NO_BONUS = 6
  MAX_NUM_QUESTIONS_CHALLENGER = MAX_NUM_QUESTIONS_NO_BONUS
  MAX_NUM_QUESTIONS_OPPONENT = MAX_NUM_QUESTIONS_NO_BONUS + 1
  TIE_ID_FLAG = 0

  def init
    self.id ||= 0
    self.game_id ||= 0
    self.challenger_id ||= 0
    self.opponent_id ||= 0
    self.winner_id ||= 0
    self.challenger_correct ||= 0
    self.opponent_correct ||= 0
    generate_question_ids
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

  def apply_question_result(user_id, result, bonus_flag)
    case result
      when Question::CORRECT
        if bonus_flag == Game::BONUS_TRUE # checks for a flag raised by a tie
          self.add_correct_answer(self.opponent_id, bonus_flag)
          if user_id == self.opponent_id
            self.winner_id = user_id # opponent wins if gets bonus correct
            self.save!
            return RESULT_WINNER
          end
        else
          self.add_correct_answer(user_id, bonus_flag)
          if user_id == self.challenger_id && self.challenger_correct == MAX_NUM_QUESTIONS_CHALLENGER
            self.save!
            return RESULT_OPPONENT_TURN
          end
          if user_id == self.opponent_id && self.opponent_correct == MAX_NUM_QUESTIONS_NO_BONUS
              return RESULT_TIE if self.tie?
          end
        end
      when Question::INCORRECT
        if bonus_flag == Game::BONUS_TRUE # checks for a flag raised by a tie
          if user_id == self.opponent_id
            self.winner_id = self.challenger_id # challenger wins if opponent answers incorrectly
            self.save!
            return RESULT_WINNER
          end
        else
          if user_id == self.challenger_id
            self.save!
            return RESULT_OPPONENT_TURN
          end
          if user_id == self.opponent_id && self.opponent_correct < MAX_NUM_QUESTIONS_NO_BONUS
            if self.tie?
              self.save!
              return RESULT_TIE
            else
              self.set_winner
              return RESULT_WINNER
            end
          end
        end
      else
        # type code here
    end
  end

  def add_correct_answer(user_id, bonus_flag)
    if user_id == self.challenger_id
      if bonus_flag == Game::BONUS_FALSE && self.challenger_correct == MAX_NUM_QUESTIONS_CHALLENGER
        fail 'Challenger cannot answer > 6 questions'
      elsif bonus_flag == Game::BONUS_TRUE
        fail 'Challenger cannot play bonus round'
      else
        self.challenger_correct += 1
      end
    end
    if user_id == self.opponent_id
      if bonus_flag == Game::BONUS_FALSE && self.opponent_correct == MAX_NUM_QUESTIONS_NO_BONUS
        fail 'Opponent cannot answer > 6 questions during normal round'
      elsif bonus_flag == Game::BONUS_TRUE && self.opponent_correct == MAX_NUM_QUESTIONS_OPPONENT
        fail 'Opponent cannot answer > 7 questions during bonus round'
      else
        self.opponent_correct += 1
      end
    end
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
    challenger_winner? || opponent_winner?
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
    a > b
  end

  def max_correct?
    self.challenger_correct == MAX_NUM_QUESTIONS_NO_BONUS || self.opponent_correct == MAX_NUM_QUESTIONS_NO_BONUS + 1
  end
end
