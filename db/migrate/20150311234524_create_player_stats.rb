class CreatePlayerStats < ActiveRecord::Migration
  def change
    create_table :player_stats do |t|
      t.integer :userId, :integer, default: 0
      t.integer :art_correct_count, :integer, default: 0
      t.integer :art_total_count, :integer, default: 0
      t.integer :entertainment_correct_count, :integer, default: 0
      t.integer :entertainment_total_count, :integer, default: 0
      t.integer :geography_correct_count, :integer, default: 0
      t.integer :geography_total_count, :integer, default: 0
      t.integer :history_correct_count, :integer, default: 0
      t.integer :history_total_count, :integer, default: 0
      t.integer :science_correct_count, :integer, default: 0
      t.integer :science_total_count, :integer, default: 0
      t.integer :sports_correct_count, :integer, default: 0
      t.integer :sports_total_count, :integer, default: 0

      t.timestamp null: false
    end
  end
end
