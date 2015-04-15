class Challenge < ActiveRecord::Base

  def generate_question_ids
    self.art_id = Question.random_question_id('Art')
    self.ent_id = Question.random_question_id('Entertainment')
    self.history_id = Question.random_question_id('History')
    self.geo_id = Question.random_question_id('Geography')
    self.science_id = Question.random_question_id('Science')
    self.sports_id = Question.random_question_id('Sports')
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
  end

  def set_winner
    if self.challenger_winner?
      self.winner_id = self.challenger_id
    end
    if self.opponent_winner?
      self.winner_id = self.opponent_id
    end
  end

  def winner?
    if self.tie?
      false
    else
      challenger_winner? || opponent_winner?
    end
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
    a > b || a == 6
  end

  def challenge_game
    @challenge_game = Game.find(self.game_id)
  end

end
