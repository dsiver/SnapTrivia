class AddCounterToChallenges < ActiveRecord::Migration
  def change
    add_column :challenges, :counter, :integer, default: 1
  end
end
