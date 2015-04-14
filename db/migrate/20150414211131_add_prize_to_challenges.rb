class AddPrizeToChallenges < ActiveRecord::Migration
  def change
    add_column :challenges, :prize, :string
  end
end
