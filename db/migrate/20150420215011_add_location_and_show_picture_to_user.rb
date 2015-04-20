class AddLocationAndShowPictureToUser < ActiveRecord::Migration
  def change
    add_column :users, :location, :string
    add_column :users, :show_picture, :boolean, :default => true
  end
end
