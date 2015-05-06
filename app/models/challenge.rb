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
  MAX_NUM_QUESTIONS_OPPONENT = 7
  DEFAULT_WINNER_ID = 0

  scope :ongoing, -> {where(winner_id: DEFAULT_WINNER_ID)}

  def init
    #self.id ||= 0
    self.game_id ||= 0
    self.challenger_id ||= 0
    self.opponent_id ||= 0
    self.winner_id ||= 0
    self.challenger_correct ||= 0
    self.opponent_correct ||= 0
    generate_question_ids
    self.save!
  end

  def self.create_challenge(game_id, challenger_id, opponent_id, wager, prize)
    subjects = Subject::subjects
    if game_id <= 0 || !game_id.integer?
      fail 'game_id must be a number greater than zero'
    end
    if challenger_id <= 0 || !challenger_id.integer?
      fail 'challenger_id must be a number greater than zero'
    end
    if opponent_id <= 0 || !opponent_id.integer?
      fail 'opponent_id must be a number greater than zero'
    end
    unless subjects.include?(wager)
      fail 'invalid wager'
    end
    unless subjects.include?(prize)
      fail 'invalid prize'
    end
    @challenge = Challenge.new(game_id: game_id, challenger_id: challenger_id, opponent_id: opponent_id, wager: wager, prize: prize)
    @challenge.generate_question_ids
    @challenge
  end

  def generate_question_ids
    self.art_id = Question.random_question_id(Subject::ART)
    self.ent_id = Question.random_question_id(Subject::ENTERTAINMENT)
    self.history_id = Question.random_question_id(Subject::HISTORY)
    self.geo_id = Question.random_question_id(Subject::GEOGRAPHY)
    self.science_id = Question.random_question_id(Subject::SCIENCE)
    self.sports_id = Question.random_question_id(Subject::SPORTS)
    self.save!
  end

  def get_question_id_by_counter
    return self.art_id if self.counter == 0
    return self.ent_id if self.counter == 1
    return self.geo_id if self.counter == 2
    return self.history_id if self.counter == 3
    return self.science_id if self.counter == 4
    return self.sports_id if self.counter == 5
    if self.counter == 6
      random_question = Question::random_question_random_subject
      random_question.id
    end
  end

  def self.get_ongoing_challenge(game_id, challenger_id, opponent_id)
    @challenge = Challenge.ongoing.where(game_id: game_id, challenger_id: challenger_id, opponent_id: opponent_id).first
  end

  def self.get_ongoing_challenge_by_game(game_id)
    @challenge = Challenge.ongoing.where(game_id: game_id).first
  end

  def self.get_challenges_by_game(game_id)
    @challenges = Challenge.where(game_id: game_id)
  end

  def apply_question_result(user_id, result, bonus_flag, question_number)
    if user_id == self.challenger_id
      if question_number > MAX_NUM_QUESTIONS_CHALLENGER
        fail 'challenger cannot answer > 6 questions'
      end
      if bonus_flag == Game::BONUS_TRUE
        fail 'challenger cannot play bonus round'
      end
    end
    if user_id == self.opponent_id
      if bonus_flag == Game::BONUS_FALSE
        if question_number > MAX_NUM_QUESTIONS_NO_BONUS || self.opponent_correct == MAX_NUM_QUESTIONS_NO_BONUS
          fail 'opponent cannot answer > 6 questions during normal round'
        end
      end
      if bonus_flag == Game::BONUS_TRUE
        if question_number != MAX_NUM_QUESTIONS_OPPONENT
          fail 'question_number must be equal to 7 during bonus'
        end
      end
    end
    if question_number == self.counter + 1
      self.counter += 1
    else
      raise 'invalid question number'
    end
    if result == Question::CORRECT
      self.add_correct_answer(user_id)
      if bonus_flag == Game::BONUS_TRUE # checks for a flag raised by a tie
        if user_id == self.opponent_id
          self.winner_id = user_id # opponent wins if gets bonus correct
          self.save!
          return RESULT_WINNER
        end
      end
    end
    if result == Question::INCORRECT
      if user_id == self.opponent_id && bonus_flag == Game::BONUS_TRUE # checks for a flag raised by a tie
        self.winner_id = self.challenger_id # challenger wins if opponent answers incorrectly
        self.save!
        return RESULT_WINNER
      end
    end
    if user_id == self.challenger_id && question_number == MAX_NUM_QUESTIONS_CHALLENGER
      self.save!
      return RESULT_OPPONENT_TURN
    end
    if user_id == self.opponent_id
      if bonus_flag == Game::BONUS_FALSE && question_number == MAX_NUM_QUESTIONS_NO_BONUS
        if self.tie?
          return RESULT_TIE
        elsif self.winner?
          self.set_winner
          return RESULT_WINNER
        end
      end
    end
  end

  def get_total_correct(user_id)
    if user_id == self.challenger_id
      self.challenger_correct
    else
      self.opponent_correct
    end
  end

  def add_correct_answer(user_id)
    if user_id == self.challenger_id
      self.challenger_correct += 1
    end
    if user_id == self.opponent_id
      self.opponent_correct += 1
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
    check_score(self.challenger_correct, self.opponent_correct)
  end

  def opponent_winner?
    check_score(self.opponent_correct, self.challenger_correct)
  end

  def tie?
    self.challenger_correct == self.opponent_correct
  end

  private

  def check_score(a, b)
    a > b
  end

  def max_correct?
    self.challenger_correct == MAX_NUM_QUESTIONS_NO_BONUS || self.opponent_correct == MAX_NUM_QUESTIONS_NO_BONUS + 1
  end
end
