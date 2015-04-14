class RemovePrizeTrophyIdFromChallenges < ActiveRecord::Migration
  def change
    remove_column :challenges, :prize_trophy_id, :integer
  end
end
