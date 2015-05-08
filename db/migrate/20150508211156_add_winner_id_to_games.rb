class AddWinnerIdToGames < ActiveRecord::Migration
  def change
    add_column :games, :winner_id, :integer, default: 0
  end
end
