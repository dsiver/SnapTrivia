class AddWagerAndTrophyToChallenges < ActiveRecord::Migration
  def change
    add_column :challenges, :wager, :string
    add_column :challenges, :trophy, :string
  end
end
