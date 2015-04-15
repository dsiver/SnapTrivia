class Challenge < ActiveRecord::Base

  after_initialize :defaults

  def defaults
    self.game_id ||= 0
    self.challenger_id ||= 0
    self.opponent_id ||= 0
    self.wager ||= ""
    self.prize ||= ""
    self.winner_id ||= 0
    self.challenger_correct ||= 0
    self.opponent_correct ||= 0
  end

  def generate_question_ids
    self.art_id = Question.question_by_subject('Art').id
    self.ent_id = Question.question_by_subject('Entertainment').id
    self.history_id = Question.question_by_subject('History').id
    self.geo_id = Question.question_by_subject('Geography').id
    self.science_id = Question.question_by_subject('Science').id
    self.sports_id = Question.question_by_subject('Sports').id
  end

  def set_game_attributes(game_id, challenger_id, wager, prize)
    game = Game.find(game_id)
    self.game_id = game.id
    case challenger_id
      when game.player1_id
        self.challenger_id = game.player1_id
        self.opponent_id = game.player2_id
      when game.player2_id
        self.challenger_id = game.player2_id
        self.opponent_id = game.player1_id
    end
    self.wager = wager
    self.prize = prize
  end

end
