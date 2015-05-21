class Message < ActiveRecord::Base
  SYSTEM_ID = 0
  SYSTEM_NAME = 'System'
  #attr_accessible :subject, :body, :sender_id, :recipient_id, :read

  #validates_presence_of :subject, :body, :recipient_id
  validates :subject, length: { minimum: 3, maximum: 35 }
  validates :body, length: { minimum: 1, maximum: 1000 }

  belongs_to :user

  def self.send_system_message(recipient_id, subject, body, payload)
    recipient = User.find(recipient_id)
    Message.create({ sender_id: SYSTEM_ID, sender_name: SYSTEM_NAME, recipient_id: recipient.id, recipient_name: recipient.name, subject: subject, body: body, payload: payload })
  end
end