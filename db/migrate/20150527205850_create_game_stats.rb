class CreateGameStats < ActiveRecord::Migration
  def change
    create_table :game_stats do |t|
      t.belongs_to :game, index: true
      t.integer :art_total, default: 0
      t.integer :art_correct, default: 0
      t.integer :ent_total, default: 0
      t.integer :ent_correct, default: 0
      t.integer :geo_total, default: 0
      t.integer :geo_correct, default: 0
      t.integer :hist_total, default: 0
      t.integer :hist_correct, default: 0
      t.integer :sci_total, default: 0
      t.integer :sci_correct, default: 0
      t.integer :sports_total, default: 0
      t.integer :sports_correct, default: 0

      t.timestamps null: false
    end
  end
end
