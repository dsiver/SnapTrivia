class Challenge < ActiveRecord::Base

  after_initialize :defaults

  def defaults
    self.game_id ||= 0
    self.challenger_id ||= 0
    self.opponent_id ||= 0
    self.wager_trophy_id ||= 0
    self.prize_trophy_id ||= 0
    self.winner_id ||= 0
    self.challenger_correct ||= 0
    self.opponent_correct ||= 0
  end

  def generate_question_ids
    self.art_id = get_id('Art')
    self.ent_id = get_id('Entertainment')
    self.history_id = get_id('History')
    self.geo_id = get_id('Geography')
    self.science_id = get_id('Science')
    self.sports_id = get_id('Sports')
  end

  private
  
  def get_id(subject)
    all_questions_matching = Question.find_by subject_title: subject
    random_id = get_random_number(all_questions_matching.count)
    question = get_random_question(all_questions_matching, random_id)
    question.id
  end

  def get_random_number(number)
    rand(number).count
  end

  def get_random_question(collection, random_id)
    question = collection.first(:conditions => [ 'id >= ?', random_id])
    question.id
  end

end
