class CreateQuestionRatings < ActiveRecord::Migration
  def change
    create_table :question_ratings do |t|
      t.integer :question_id, null: false
      t.integer :rating, default: 0
      t.text :comment

      t.timestamps null: false
    end
  end
end
