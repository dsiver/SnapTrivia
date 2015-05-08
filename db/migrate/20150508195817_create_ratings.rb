class CreateRatings < ActiveRecord::Migration
  def change
    create_table :ratings do |t|
      t.integer :easy, default: 1
      t.integer :medium, default: 2
      t.integer :hard, default: 3

      t.timestamps null: false
    end
  end
end
