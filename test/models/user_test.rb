require 'test_helper'

class UserTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  EXTRA_TIME = 'extra_time'
  REMOVE_WRONG_ANSWERS = 'remove_wrong_answers'
  SKIP_QUESTION = 'skip_question'

  test "power_ups should_be_zero_give_extra_time" do
    user = User.find(1)
    assert_equal(0, user.power_ups(EXTRA_TIME))
  end

  test "give_extra_time points_should_be_one" do
    user = User.find(1)
    1.times {user.give_extra_time}
    user.save
    assert_equal(1, user.power_ups(EXTRA_TIME))
  end

  test "use_extra_time should_decrease_by_one" do
    user = User.find(1)
    2.times {user.give_extra_time}
    user.save
    user.use_extra_time
    assert_equal(1, user.power_ups(EXTRA_TIME))
  end

  test "power_ups should_be_zero_remove_wrong_answers" do
    user = User.find(1)
    assert_equal(0, user.power_ups(REMOVE_WRONG_ANSWERS))
  end

  test "give_remove_wrong_answers points_should_be_one" do
    user = User.find(1)
    1.times {user.give_remove_wrong_answers}
    user.save
    assert_equal(1, user.power_ups(REMOVE_WRONG_ANSWERS))
  end

  test "use_remove_wrong_answer should_decrease_by_one" do
    user = User.find(1)
    2.times {user.give_remove_wrong_answers}
    user.save
    user.use_remove_wrong_answer
    assert_equal(1, user.power_ups(REMOVE_WRONG_ANSWERS))
  end

  test "power_ups should_be_zero_skip_question" do
    user = User.find(1)
    assert_equal(0, user.power_ups(SKIP_QUESTION))
  end

  test "give_skip_question points_should_be_one" do
    user = User.find(1)
    1.times {user.give_skip_question}
    user.save
    assert_equal(1, user.power_ups(SKIP_QUESTION))
  end

  test "use_skip_question should_decrease_by_one" do
    user = User.find(1)
    2.times {user.give_skip_question}
    user.save
    user.use_skip_question
    assert_equal(1, user.power_ups(SKIP_QUESTION))
  end
end
