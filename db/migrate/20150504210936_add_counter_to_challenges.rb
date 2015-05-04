class AddCounterToChallenges < ActiveRecord::Migration
  def change
    add_column :challenges, :counter, :integer, default: 0
  end
end
