class AddFieldsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :sash_id, :integer
  end
end
