require 'test_helper'

class ReviewerTest < ActiveSupport::TestCase

  test "notify_reviewers should not be nil" do
    Reviewer.notify_reviewers("subject", "body", "payload")
    messages = Message.all
    #pp messages
    assert_not_nil(messages)
  end

  test "notify_reviewers messages created should equal number reviewers" do
    Reviewer.notify_reviewers("subject", "body", "payload")
    messages = Message.all
    #pp messages
    assert_equal(messages.count, Reviewer.reviewers.count)
  end

  test "notify_reviewers messages should all have sender_id SYSTEM_ID" do
    Reviewer.notify_reviewers("subject", "body", "payload")
    messages = Message.all
    messages.each { |m|
      assert_equal(Message::SYSTEM_ID, m.sender_id)
    }
  end

  test "notify_reviewers messages should all have sender_name SYSTEM_NAME" do
    Reviewer.notify_reviewers("subject", "body", "payload")
    messages = Message.all
    messages.each { |m|
      assert_equal(Message::SYSTEM_NAME, m.sender_name)
    }
  end

  test "notify_reviewers messages should all have same subject" do
    Reviewer.notify_reviewers("subject", "body", "payload")
    messages = Message.all
    messages.each { |m|
      assert_equal("subject", m.subject)
    }
  end

  test "notify_reviewers messages should all have same body" do
    Reviewer.notify_reviewers("subject", "body", "payload")
    messages = Message.all
    messages.each { |m|
      assert_equal("body", m.body)
    }
  end

  test "notify_reviewers messages should all have same payload" do
    Reviewer.notify_reviewers("subject", "body", "payload")
    messages = Message.all
    messages.each { |m|
      assert_equal("payload", m.payload)
    }
  end

end
