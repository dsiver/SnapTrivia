class Challenge < ActiveRecord::Base
  #belongs_to :game
  YES = 'yes'
  NO = 'no'
  MAX_NUM_QUESTIONS = 6
  def generate_question_ids
    self.art_id = Question.random_question_id('Art')
    self.ent_id = Question.random_question_id('Entertainment')
    self.history_id = Question.random_question_id('History')
    self.geo_id = Question.random_question_id('Geography')
    self.science_id = Question.random_question_id('Science')
    self.sports_id = Question.random_question_id('Sports')
    self.save!
  end

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

  def challenge_game
    @challenge_game = Game.find(self.game_id)
  end

end
