class AddCoinsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :coins, :integer, :default => 20
  end
end
