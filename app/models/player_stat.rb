class PlayerStat < ActiveRecord::Base

  def self.IncrementSubjectCorrectCount(user_id, subject)
    player_stats = PlayerStat.where("player_stats.userId" => user_id)

    if subject == "Art"
      player_stats.art_correct_count = player_stats.art_correct_count + 1
      player_stats.save!
    end
    if subject == "Entertainment"
      player_stats.entertainment_correct_count = player_stats.entertainment_correct_count + 1
      player_stats.save!
    end
    if subject == "History"
      player_stats.history_correct_count = player_stats.history_correct_count + 1
      player_stats.save!
    end
    if subject == "Geography"
      player_stats.geography_correct_count = player_stats.geography_correct_count + 1
      player_stats.save!
    end
    if subject == "Science"
      player_stats.science_correct_count = player_stats.science_correct_count + 1
      player_stats.save!
    end
    if subject == "Sports"
      player_stats.sports_correct_count = player_stats.sports_correct_count + 1
      player_stats.save!
    end
  end

  def self.IncrementSubjectTotalCount(user_id, subject)
    player_stats = PlayerStat.where("player_stats.userId" => user_id)
    if subject == "Art"
      player_stats.art_total_count = player_stats.art_total_count + 1
      player_stats.save!
    end
    if subject == "Entertainment"
      player_stats.entertainment_total_count = player_stats.entertainment_total_count + 1
      player_stats.save!
    end
    if subject == "History"
      player_stats.history_total_count = player_stats.history_total_count + 1
      player_stats.save!
    end
    if subject == "Geography"
      player_stats.geography_total_count = player_stats.geography_total_count + 1
      player_stats.save!
    end
    if subject == "Science"
      player_stats.science_total_count = player_stats.science_total_count + 1
      player_stats.save!
    end
    if subject == "Sports"
      player_stats.sports_total_count = player_stats.sports_total_count + 1
      player_stats.save!
    end
  end

end
