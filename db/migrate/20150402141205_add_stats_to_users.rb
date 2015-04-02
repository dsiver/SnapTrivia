class AddStatsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :total_questions, :integer, default: 0
    add_column :users, :correct_questions, :integer, default: 0
    add_column :users, :art_correct_count, :integer, default: 0
    add_column :users, :art_total_count, :integer, default: 0
    add_column :users, :entertainment_correct_count, :integer, default: 0
    add_column :users, :entertainment_total_count, :integer, default: 0
    add_column :users, :geography_correct_count, :integer, default: 0
    add_column :users, :geography_total_count, :integer, default: 0
    add_column :users, :history_correct_count, :integer, default: 0
    add_column :users, :history_total_count, :integer, default: 0
    add_column :users, :science_correct_count, :integer, default: 0
    add_column :users, :science_total_count, :integer, default: 0
    add_column :users, :sports_correct_count, :integer, default: 0
    add_column :users, :sports_total_count, :integer, default: 0
    add_column :users, :score, :integer, default: 0
    add_column :users, :next_lvl_score, :integer, default: 100
    add_column :users, :level, :integer, default: 1
    add_column :users, :total_games, :integer, default: 0
    add_column :users, :total_wins, :integer, default: 0


  end
end
