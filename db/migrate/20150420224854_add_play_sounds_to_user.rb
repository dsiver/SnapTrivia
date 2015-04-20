class AddPlaySoundsToUser < ActiveRecord::Migration
  def change
    add_column :users, :play_sounds, :boolean, :default => true
  end
end
