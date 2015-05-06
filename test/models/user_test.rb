require 'test_helper'

class UserTest < ActiveSupport::TestCase

  def setup
    @user = User.find(1)
  end

  test "power_ups should_be_zero_give_extra_time" do
    assert_equal(0, @user.power_ups(Question::EXTRA_TIME))
  end

  test "give_extra_time points_should_be_one" do
    1.times {@user.give_extra_time}
    @user.save
    assert_equal(1, @user.power_ups(Question::EXTRA_TIME))
  end

  test "use_extra_time should_decrease_by_one" do
    2.times {@user.give_extra_time}
    @user.save
    @user.use_extra_time
    assert_equal(1, @user.power_ups(Question::EXTRA_TIME))
  end

  test "power_ups should_be_zero_remove_wrong_answers" do
    assert_equal(0, @user.power_ups(Question::REMOVE_WRONG_ANSWERS))
  end

  test "give_remove_wrong_answers points_should_be_one" do
    1.times {@user.give_remove_wrong_answers}
    @user.save
    assert_equal(1, @user.power_ups(Question::REMOVE_WRONG_ANSWERS))
  end

  test "use_remove_wrong_answer should_decrease_by_one" do
    2.times {@user.give_remove_wrong_answers}
    @user.save
    @user.use_remove_wrong_answer
    assert_equal(1, @user.power_ups(Question::REMOVE_WRONG_ANSWERS))
  end

  test "power_ups should_be_zero_skip_question" do
    assert_equal(0, @user.power_ups(Question::SKIP_QUESTION))
  end

  test "give_skip_question points_should_be_one" do
    1.times {@user.give_skip_question}
    @user.save
    assert_equal(1, @user.power_ups(Question::SKIP_QUESTION))
  end

  test "use_skip_question should_decrease_by_one" do
    2.times {@user.give_skip_question}
    @user.save
    @user.use_skip_question
    assert_equal(1, @user.power_ups(Question::SKIP_QUESTION))
  end

  test "add_point_correct_questions should_be_1_correct_questions" do
    @user.save!
    @user.add_point_correct_questions
    assert_equal(1, @user.correct_questions)
  end
end
