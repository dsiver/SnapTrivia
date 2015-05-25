class AddRecipientReadSenderReadToMessages < ActiveRecord::Migration
  def change
    add_column :messages, :recipient_read, :integer, default: 0
    add_column :messages, :sender_read, :integer, default: 0
  end
end
