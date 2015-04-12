class CreateChallenges < ActiveRecord::Migration
  def change
    create_table :challenges do |t|
      t.integer :game_id
      t.integer :challenger_id
      t.integer :opponent_id
      t.integer :wager_trophy_id
      t.integer :prize_trophy_id
      t.integer :winner_id
      t.integer :challenger_correct
      t.integer :opponent_correct
      t.integer :art_id
      t.integer :ent_id
      t.integer :history_id
      t.integer :geo_id
      t.integer :science_id
      t.integer :sports_id

      t.timestamps null: false
    end
  end
end
