class RemoveRatingsCountRatingsTotalValueFromQuestions < ActiveRecord::Migration
  def change
    remove_column :questions, :ratings_count, :integer
    remove_column :questions, :ratings_total_value, :integer
  end
end
