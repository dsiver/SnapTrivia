class AddAnswersCorrectToGames < ActiveRecord::Migration
  def change
    add_column :games, :answers_correct, :integer, default: 0
    add_column :games, :challenge, :string, default: "no"
    add_column :games, :bonus, :string, default: 'false'
  end
end
