class CreateRatings < ActiveRecord::Migration
  def change
    create_table :ratings do |t|
      t.string :rating_level
      t.integer :rating_value, default: 1

      t.timestamps null: false
    end
  end
end
