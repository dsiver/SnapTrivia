class AddEasyRatingsMediumRatingsHardRatingsToQuestions < ActiveRecord::Migration
  def change
    add_column :questions, :easy_ratings, :integer, default: 0
    add_column :questions, :medium_ratings, :integer, default: 0
    add_column :questions, :hard_ratings, :integer, default: 0
  end
end
