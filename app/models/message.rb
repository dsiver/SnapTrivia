class Message < ActiveRecord::Base
  SYSTEM_ID = 0
  SYSTEM_NAME = 'System'
  READ = 1
  UNREAD = 0

  #validates_presence_of :subject, :body, :recipient_id
  validates :subject, length: { minimum: 3, maximum: 35 }
  validates :body, length: { minimum: 1, maximum: 1000 }

  belongs_to :user

  #################################
  ########  CLASS METHODS  ########
  #################################

  def self.recipient_list(user_id)
    User.where.not(id: user_id)
  end

  def self.send_system_message(recipient_id, subject, body, payload)
    @recipient = User.find(recipient_id)
    @message = Message.create({ sender_id: SYSTEM_ID, sender_name: SYSTEM_NAME, recipient_id: @recipient.id, recipient_name: @recipient.name, subject: subject, body: body, payload: payload })
    @message.save!
  end

  def self.send_message(sender_id, recipient_id, subject, body)
    @sender = User.find(sender_id)
    @recipient = User.find(recipient_id)
    @message = Message.create({ sender_id: @sender.id, sender_name: @sender.name, recipient_id: @recipient.id, recipient_name: @recipient.name, subject: subject, body: body })
    @message.save!
  end

  def self.sent_messages_by_user_id(user_id)
    Message.where(sender_id: user_id)
  end

  def self.received_messages_by_user_id(user_id)
    Message.where(recipient_id: user_id)
  end

  def self.user_messages(user_id)
    sent_messages_by_user_id(user_id) + received_messages_by_user_id(user_id)
  end

  def self.unread_messages_by_user_id(user_id)
    received_messages_by_user_id(user_id).select {|message| message.recipient_read == UNREAD}
  end

  def self.read_messages_by_user_id(user_id)
    received_messages_by_user_id(user_id).select {|message| message.recipient_read == READ}
  end

  ###############################
  ######  INSTANCE METHODS  #####
  ###############################

  def mark_as_read(user_id)
    self.update_attributes!(sender_read: READ) if user_id == self.sender_id
    self.update_attributes!(recipient_read: READ) if user_id == self.recipient_id
    self.save!
  end

  def read_by_sender?
    self.sender_read == READ
  end

  def read_by_recipient?
    self.recipient_read == READ
  end

  ############################################################
  #####################     PRIVATE     ######################
  ############################################################

  private

end