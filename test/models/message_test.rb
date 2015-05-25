require 'test_helper'

class MessageTest < ActiveSupport::TestCase
  USER1_TO_USER2_SENT_COUNT = 5
  USER1_TOTAL_SENT_COUNT = USER1_TO_USER2_SENT_COUNT

  USER2_TO_USER1_SENT_COUNT = 7
  USER2_TOTAL_SENT_COUNT = USER2_TO_USER1_SENT_COUNT

  USER1_TOTAL_RECEIVED_COUNT = USER2_TO_USER1_SENT_COUNT
  USER2_TOTAL_RECEIVED_COUNT = USER1_TO_USER2_SENT_COUNT

  TOTAL_MESSAGES_COUNT = USER1_TOTAL_SENT_COUNT + USER2_TOTAL_SENT_COUNT

  def setup
    @user1 = User.find(3)
    @user2 = User.find(2)
    1.upto(USER1_TO_USER2_SENT_COUNT) do
      Message.send_message(@user1.id, @user2.id, "subject_1_to_2", "body_1_to_2") end
    1.upto(USER2_TO_USER1_SENT_COUNT) do
      Message.send_message(@user2.id, @user1.id, "subject_2_to_1", "body_2_to_1") end
    @messages = Message.all
  end

  def teardown
    @user1 = nil
    @user2 = nil
    @messages = nil
  end

  ############################  testing setup  ############################

  test "messages_should_not_be_nil" do
    assert_not_nil(@messages)
  end

  test "messages_should_equal_TOTAL_MESSAGES_COUNT" do
    assert_equal(TOTAL_MESSAGES_COUNT, @messages.count)
  end

  ############################  testing sent_messages_by_user_id  ############################

  ########  user1's messages  ########

  test "sent_messages_by_user_id user1_sent_count_should_be_USER1_TOTAL_SENT_COUNT" do
    assert_equal(USER1_TOTAL_SENT_COUNT, Message.sent_messages_by_user_id(@user1.id).count)
  end

  test "sent_messages_by_user_id should_be_false_sender_id_not_user2_in_user1_sent_messages" do
    user1_sent_messages = Message.sent_messages_by_user_id(@user1.id)
    expression = user1_sent_messages.any?{|message| message.sender_id == @user2.id}
    assert_not(expression)
  end

  ########  user2's messages  ########

  test "sent_messages_by_user_id user2_sent_count_should_be_USER2_TOTAL_SENT_COUNT" do
    assert_equal(USER2_TOTAL_SENT_COUNT, Message.sent_messages_by_user_id(@user2.id).count)
  end

  test "sent_messages_by_user_id should_be_false_sender_id_not_user1_in_user2_sent_messages" do
    user2_sent_messages = Message.sent_messages_by_user_id(@user2.id)
    expression = user2_sent_messages.any?{|message| message.sender_id == @user1.id}
    assert_not(expression)
  end

  ############################  testing received_messages_by_user_id  ############################

  ########  user1's messages  ########

  test "received_messages_by_user_id user1_received_count_should_be_USER1_TOTAL_RECEIVED_COUNT" do
    assert_equal(USER1_TOTAL_RECEIVED_COUNT, Message.received_messages_by_user_id(@user1.id).count)
  end

  test "received_messages_by_user_id should_be_false_recipient_id_not_user2_in_user1_received_messages" do
    user1_received_messages = Message.received_messages_by_user_id(@user1.id)
    expression = user1_received_messages.any?{|message| message.recipient_id == @user2.id}
    assert_not(expression)
  end

  ########  user2's messages  ########

  test "received_messages_by_user_id user1_received_count_should_be_USER2_TOTAL_RECEIVED_COUNT" do
    assert_equal(USER2_TOTAL_RECEIVED_COUNT, Message.received_messages_by_user_id(@user2.id).count)
  end

  test "received_messages_by_user_id should_be_false_recipient_id_not_user1_in_user2_received_messages" do
    user2_received_messages = Message.received_messages_by_user_id(@user2.id)
    expression = user2_received_messages.any?{|message| message.recipient_id == @user1.id}
    assert_not(expression)
  end

  ############################  testing unread_messages_by_user_id  ############################

  ########  user1's messages  ########

  test "unread_messages_by_user_id user1_unread_should_not_be_nil" do
    assert_not_nil(Message.unread_messages_by_user_id(@user1.id))
  end

  test "unread_messages_by_user_id user1_unread_count_should_be_USER1_TOTAL_RECEIVED_COUNT_none_read" do
    assert_equal(USER1_TOTAL_RECEIVED_COUNT, Message.unread_messages_by_user_id(@user1.id).count)
  end

  test "unread_messages_by_user_id user1_unread_count_should_be_USER1_TOTAL_RECEIVED_COUNT-1_one_read" do
    Message.unread_messages_by_user_id(@user1.id).first.mark_as_read(@user1.id)
    assert_equal(USER1_TOTAL_RECEIVED_COUNT - 1, Message.unread_messages_by_user_id(@user1.id).count)
  end

  ########  user2's messages  ########

  test "unread_messages_by_user_id user2_unread_should_not_be_nil" do
    assert_not_nil(Message.unread_messages_by_user_id(@user2.id))
  end

  test "unread_messages_by_user_id user2_unread_count_should_be_USER2_TOTAL_RECEIVED_COUNT_none_read" do
    assert_equal(USER2_TOTAL_RECEIVED_COUNT, Message.unread_messages_by_user_id(@user2.id).count)
  end

  test "unread_messages_by_user_id user2_unread_count_should_be_USER2_TOTAL_RECEIVED_COUNT-1_one_read" do
    Message.unread_messages_by_user_id(@user2.id).first.mark_as_read(@user2.id)
    assert_equal(USER2_TOTAL_RECEIVED_COUNT - 1, Message.unread_messages_by_user_id(@user2.id).count)
  end

  ############################  testing read_messages_by_user_id  ############################

  ########  user1's messages  ########

  test "read_messages_by_user_id user1_read_should_not_be_nil" do
    assert_not_nil(Message.read_messages_by_user_id(@user1.id))
  end

  test "read_messages_by_user_id user1_read_count_should_be_0_none_read" do
    assert_equal(0, Message.read_messages_by_user_id(@user1.id).count)
  end

  test "read_messages_by_user_id user1_read_count_should_be_1_one_read" do
    Message.unread_messages_by_user_id(@user1.id).first.mark_as_read(@user1.id)
    assert_equal(1, Message.read_messages_by_user_id(@user1.id).count)
  end

  ########  user2's messages  ########

  test "read_messages_by_user_id user2_read_should_not_be_nil" do
    assert_not_nil(Message.read_messages_by_user_id(@user2.id))
  end

  test "read_messages_by_user_id user2_read_count_should_be_0_none_read" do
    Message.unread_messages_by_user_id(@user2.id).first.mark_as_read(@user2.id)
  end

  test "read_messages_by_user_id user2_read_count_should_be_1_one_read" do
    Message.unread_messages_by_user_id(@user2.id).first.mark_as_read(@user2.id)
    assert_equal(1, Message.read_messages_by_user_id(@user2.id).count)
  end

  ############################  testing mark_as_read  ############################

  test "mark_as_read should_change_status_to_read" do
    message = Message.unread_messages_by_user_id(@user1.id).first
    message.mark_as_read(@user1.id)
    assert_equal(Message::READ, message.recipient_read)
  end

  ############################  testing read_by_recipient?  ############################

  test "read_by_recipient? should_be_true_recipient_read_message" do
    message = Message.unread_messages_by_user_id(@user1.id).first
    message.mark_as_read(@user1.id)
    assert(message.read_by_recipient?)
  end

end
