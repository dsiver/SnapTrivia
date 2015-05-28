class GameStat < ActiveRecord::Base
JANUARY = '01'
FEBRUARY = '02'
MARCH = '03'
APRIL = '04'
MAY = '05'
JUNE = '06'
JULY = '07'
AUGUST = '08'
SEPTEMBER = '09'
OCTOBER = '10'
NOVEMBER = '11'
DECEMBER = '12'

  belongs_to :game

  #################################
  ########  CLASS METHODS  ########
  #################################

  def self.overall_average_by_subject(subject)
    case subject
      when Subject::ART
        percentage(GameStat.sum(:art_correct), GameStat.sum(:art_total))
      when Subject::ENTERTAINMENT
        percentage(GameStat.sum(:ent_correct), GameStat.sum(:ent_total))
      when Subject::GEOGRAPHY
        percentage(GameStat.sum(:geo_correct), GameStat.sum(:geo_total))
      when Subject::HISTORY
        percentage(GameStat.sum(:hist_correct), GameStat.sum(:hist_total))
      when Subject::SCIENCE
        percentage(GameStat.sum(:sci_correct), GameStat.sum(:sci_total))
      when Subject::SPORTS
        percentage(GameStat.sum(:sports_correct), GameStat.sum(:sports_total))
      else
        0
    end
  end

  def self.current_year_stats_by_month(month)
    year = Time.new.year
  end

  ###############################
  ######  INSTANCE METHODS  #####
  ###############################

  def apply_question_result(subject, result)
    case subject
      when Subject::ART
        correct = self.art_correct
        correct += 1 if result == Question::CORRECT
        total = self.art_total + 1
        self.update_attributes!(art_correct: correct, art_total: total)
      when Subject::ENTERTAINMENT
        correct = self.ent_correct
        correct += 1 if result == Question::CORRECT
        total = self.ent_total + 1
        self.update_attributes!(ent_correct: correct, ent_total: total)
      when Subject::GEOGRAPHY
        correct = self.geo_correct
        correct += 1 if result == Question::CORRECT
        total = self.geo_total + 1
        self.update_attributes!(geo_correct: correct, geo_total: total)
      when Subject::HISTORY
        correct = self.hist_correct
        correct += 1 if result == Question::CORRECT
        total = self.hist_total + 1
        self.update_attributes!(hist_correct: correct, hist_total: total)
      when Subject::SCIENCE
        correct = self.sci_correct
        correct += 1 if result == Question::CORRECT
        total = self.sci_total + 1
        self.update_attributes!(sci_correct: correct, sci_total: total)
      when Subject::SPORTS
        correct = self.sports_correct
        correct += 1 if result == Question::CORRECT
        total = self.sports_total + 1
        self.update_attributes!(sports_correct: correct, sports_total: total)
      else
        false
    end
    self.save!
  end

  def calculate_percentage(subject)
    case subject
      when Subject::ART
        percentage(self.art_correct, self.art_total)
      when Subject::ENTERTAINMENT
        percentage(self.ent_correct, self.ent_total)
      when Subject::GEOGRAPHY
        percentage(self.geo_correct, self.geo_total)
      when Subject::HISTORY
        percentage(self.hist_correct, self.hist_total)
      when Subject::SCIENCE
        percentage(self.sci_correct, self.sci_total)
      when Subject::SPORTS
        percentage(self.sports_correct, self.sports_total)
      else
        0
    end
  end

  def self.percentage(numerator, denominator)
    if denominator == 0
      return 0
    else
      fraction = Rational(numerator, denominator)
      Rational(fraction.to_f * 100).round
    end
  end

end
