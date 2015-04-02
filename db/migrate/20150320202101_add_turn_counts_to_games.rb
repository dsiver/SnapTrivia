class AddTurnCountsToGames < ActiveRecord::Migration
  def change
    add_column :games, :turn_count, :integer, default: 0
  end
end
