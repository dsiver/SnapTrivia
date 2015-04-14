class RemoveWagerTrophyIdFromChallenges < ActiveRecord::Migration
  def change
    remove_column :challenges, :wager_trophy_id, :integer
  end
end
