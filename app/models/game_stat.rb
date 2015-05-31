class GameStat < ActiveRecord::Base
JANUARY = 1
FEBRUARY = 2
MARCH = 3
APRIL = 4
MAY = 5
JUNE = 6
JULY = 7
AUGUST = 8
SEPTEMBER = 9
OCTOBER = 10
NOVEMBER = 11
DECEMBER = 12
MONTHS = [JANUARY, FEBRUARY, MARCH, APRIL, MAY, JUNE, JULY, AUGUST, SEPTEMBER, OCTOBER, NOVEMBER, DECEMBER]

  belongs_to :game, inverse_of: :game_stat

  def self.months_hash
    Hash[Date::MONTHNAMES.compact.zip(GameStat::MONTHS)]
  end

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

  def self.percentage_by_month_by_subject(month, subject)
    result = self.stats_for_month(month)
    self.calculate_percentage(result, subject)
  end

  def self.weekly_stats_by_month(month)
    year = Time.new.year
    start_date = Date.new(year, month).beginning_of_month
    end_date = start_date.next_month
    no_stats = "There are no records for this week."
    weekly_stats = []
    (0..3).each {|i|
      if i < 3
        stats = GameStat.where(:created_at => (start_date + i.week)..(start_date + (i+1).week)).order(created_at: :asc)
        weekly_stats.push((start_date + i.week).to_s + " - " + (start_date + (i+1).week).to_s)
        if stats.any?
           weekly_stats += format_stats(stats)
        else
          weekly_stats.push(no_stats)
        end
      else
        stats = GameStat.where(:created_at => (start_date + i.week)..(end_date - 1.day)).order(created_at: :asc)
        weekly_stats.push((start_date + i.week).to_s + " - " + (end_date - 1.day).to_s)
        if stats.any?
          weekly_stats += format_stats(stats)
        else
          weekly_stats.push(no_stats)
        end
      end
    }
    weekly_stats
  end

  def self.format_stats(stats)
    formatted = []
    Subject.subjects.each do |subject|
      formatted.push(subject + ": (Correct: " + self.get_correct(stats, subject).to_s + " Total: " +
                         self.get_total(stats, subject).to_s +
                         " Percentage: " + self.calculate_percentage(stats, subject).to_s + "%)")
    end
    formatted
  end

  def self.stats_for_month(month)
    if MONTHS.include?(month)
      year = Time.new.year
      start_date = Date.new(year, month).beginning_of_month
      end_date = start_date.next_month.beginning_of_month
      GameStat.where(:created_at => start_date..end_date).order(created_at: :asc)
    end
  end

  def self.get_correct(relation, subject)
    return relation.pluck(:art_correct).sum if subject == Subject::ART
    return relation.pluck(:ent_correct).sum if subject == Subject::ENTERTAINMENT
    return relation.pluck(:geo_correct).sum if subject == Subject::GEOGRAPHY
    return relation.pluck(:hist_correct).sum if subject == Subject::HISTORY
    return relation.pluck(:sci_correct).sum if subject == Subject::SCIENCE
    return relation.pluck(:sports_correct).sum if subject == Subject::SPORTS
  end

  def self.get_total(relation, subject)
    return relation.pluck(:art_total).sum if subject == Subject::ART
    return relation.pluck(:ent_total).sum if subject == Subject::ENTERTAINMENT
    return relation.pluck(:geo_total).sum if subject == Subject::GEOGRAPHY
    return relation.pluck(:hist_total).sum if subject == Subject::HISTORY
    return relation.pluck(:sci_total).sum if subject == Subject::SCIENCE
    return relation.pluck(:sports_total).sum if subject == Subject::SPORTS
  end

  def self.calculate_percentage(relation, subject)
    return percentage(relation.pluck(:art_correct).sum, relation.pluck(:art_total).sum) if subject == Subject::ART
    return percentage(relation.pluck(:ent_correct).sum, relation.pluck(:ent_total).sum) if subject == Subject::ENTERTAINMENT
    return percentage(relation.pluck(:geo_correct).sum, relation.pluck(:geo_total).sum) if subject == Subject::GEOGRAPHY
    return percentage(relation.pluck(:hist_correct).sum, relation.pluck(:hist_total).sum) if subject == Subject::HISTORY
    return percentage(relation.pluck(:sci_correct).sum, relation.pluck(:sci_total).sum) if subject == Subject::SCIENCE
    return percentage(relation.pluck(:sports_correct).sum, relation.pluck(:sports_total).sum) if subject == Subject::SPORTS
  end

  def self.percentage(numerator, denominator)
    if denominator == 0 || numerator == 0
      return 0
    else
      fraction = Rational(numerator, denominator)
      Rational(fraction.to_f * 100).round
    end
  end

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

  def percentage(numerator, denominator)
    GameStat.percentage(numerator, denominator)
  end

end
