class AddUserRefToQuestions < ActiveRecord::Migration
  def change
    add_reference :questions, :user, index: true
    add_column :questions, :ratings_count, :integer
    add_column :questions, :ratings_total_value, :integer
  end
end
