class RemoveTrophyColumnFromChallenges < ActiveRecord::Migration
  def change
    remove_column :challenges, :trophy, :string
  end
end
