require 'test_helper'

class UserTest < ActiveSupport::TestCase

  def setup
    @user = User.find(1)
  end

  def teardown
    @user = nil
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

  test "increment_correct_questions should_be_1_correct_questions" do
    @user.save!
    @user.increment_correct_questions
    assert_equal(1, @user.correct_questions)
  end

  ################################# apply_question_results #################################

  ######## testing total questions ########

  test "apply_question_results should_increment_total_questions_by_one" do
    old_total = @user.total_questions
    assert_equal(0, old_total)
    @user.apply_question_results(Subject::ART, Question::INCORRECT)
    assert_not_equal(old_total, @user.total_questions)
    assert_equal(old_total + 1, @user.total_questions)
  end

  ######## testing total_correct ########

  test "apply_question_results should_increment_total_correct_questions_by_one" do
    old_correct = @user.correct_questions
    assert_equal(0, old_correct)
    @user.apply_question_results(Subject::ART, Question::CORRECT)
    assert_not_equal(old_correct, @user.correct_questions)
    assert_equal(old_correct + 1, @user.correct_questions)
  end

  ######## testing art_correct ########

  test "apply_question_results should_increment_art_correct_by_one" do
    old_correct = @user.art_correct_count
    assert_equal(0, old_correct)
    @user.apply_question_results(Subject::ART, Question::CORRECT)
    assert_not_equal(old_correct, @user.art_correct_count)
    assert_equal(old_correct + 1, @user.art_correct_count)
  end

  ######## testing level ########

  #### 1..10 ####

  ## level 1 ##

  test "apply_question_results level_should_be_same_total_correct_is_1" do
    assert_equal(1, @user.level)
    result = @user.apply_question_results(Subject::ART, Question::CORRECT)
    assert_equal(1, @user.level)
    assert_equal(User::SAME_LEVEL, result)
  end

  test "apply_question_results level_should_be_1_total_correct_is_4" do
    @user.update_attributes!(:correct_questions => 13)
    result = @user.apply_question_results(Subject::ART, Question::CORRECT)
    assert_equal(1, @user.level)
    assert_equal(User::SAME_LEVEL, result)
  end

  ## level 2 ##

  test "apply_question_results level_should_be_2_total_correct_is_5" do
    @user.update_attributes!(:correct_questions => 4)
    result = @user.apply_question_results(Subject::ART, Question::CORRECT)
    assert_equal(2, @user.level)
    assert_equal(User::NEW_LEVEL, result)
  end

  test "apply_question_results level_should_be_2_total_correct_is_6" do
    @user.update_attributes!(:correct_questions => 5, :level => 2)
    result = @user.apply_question_results(Subject::ART, Question::CORRECT)
    assert_equal(2, @user.level)
    assert_equal(User::SAME_LEVEL, result)
  end

  test "apply_question_results level_should_be_2_total_correct_is_9" do
    @user.update_attributes!(:correct_questions => 8, :level => 2)
    result = @user.apply_question_results(Subject::ART, Question::CORRECT)
    assert_equal(2, @user.level)
    assert_equal(User::SAME_LEVEL, result)
  end

  ## level 3 ##

  test "apply_question_results level_should_be_3_total_correct_is_10" do
    @user.update_attributes!(:correct_questions => 9, :level => 2)
    result = @user.apply_question_results(Subject::ART, Question::CORRECT)
    assert_equal(3, @user.level)
    assert_equal(User::NEW_LEVEL, result)
  end

  test "apply_question_results level_should_be_3_total_correct_is_11" do
    @user.update_attributes!(:correct_questions => 10, :level => 3)
    result = @user.apply_question_results(Subject::ART, Question::CORRECT)
    assert_equal(3, @user.level)
    assert_equal(User::SAME_LEVEL, result)
  end

  test "apply_question_results level_should_be_3_total_correct_is_14" do
    @user.update_attributes!(:correct_questions => 13, :level => 3)
    result = @user.apply_question_results(Subject::ART, Question::CORRECT)
    assert_equal(3, @user.level)
    assert_equal(User::SAME_LEVEL, result)
  end

  ## level 4 ##

  test "apply_question_results level_should_be_4_total_correct_is_15" do
    @user.update_attributes!(:correct_questions => 14, :level => 3)
    result = @user.apply_question_results(Subject::ART, Question::CORRECT)
    assert_equal(4, @user.level)
    assert_equal(User::NEW_LEVEL, result)
  end

  test "apply_question_results level_should_be_4_total_correct_is_19" do
    @user.update_attributes!(:correct_questions => 18, :level => 4)
    result = @user.apply_question_results(Subject::ART, Question::CORRECT)
    assert_equal(4, @user.level)
    assert_equal(User::SAME_LEVEL, result)
  end

  ## level 5 ##

  test "apply_question_results level_should_be_5_total_correct_is_20" do
    @user.update_attributes!(:correct_questions => 19, :level => 4)
    result = @user.apply_question_results(Subject::ART, Question::CORRECT)
    assert_equal(5, @user.level)
    assert_equal(User::NEW_LEVEL, result)
  end

  ## level 10 ##

  test "apply_question_results level_should_be_10_total_correct_is_45" do
    @user.update_attributes!(:correct_questions => 44, :level => 9)
    result = @user.apply_question_results(Subject::ART, Question::CORRECT)
    assert_equal(10, @user.level)
    assert_equal(User::NEW_LEVEL, result)
  end

  test "apply_question_results level_should_still_be_10_total_correct_is_50" do
    @user.update_attributes!(:correct_questions => 49, :level => 10)
    result = @user.apply_question_results(Subject::ART, Question::CORRECT)
    assert_equal(10, @user.level)
    assert_equal(User::SAME_LEVEL, result)
  end

  ## level 11 ##
  test "apply_question_results level_should_be_11_total_correct_is_60" do
    @user.update_attributes!(:correct_questions => 59, :level => 10)
    result = @user.apply_question_results(Subject::ART, Question::CORRECT)
    assert_equal(11, @user.level)
    assert_equal(User::NEW_LEVEL, result)
  end

  ## Level 12 ##
  test "apply_question_results level_should_be_12_total_correct_is_70" do
    @user.update_attributes!(:correct_questions => 69, :level => 11)
    result = @user.apply_question_results(Subject::ART, Question::CORRECT)
    assert_equal(12, @user.level)
    assert_equal(User::NEW_LEVEL, result)
  end

  ## Level 13 ##
  test "apply_question_results level_should_be_13_total_correct_is_80" do
    @user.update_attributes!(:correct_questions => 79, :level => 12)
    result = @user.apply_question_results(Subject::ART, Question::CORRECT)
    assert_equal(13, @user.level)
    assert_equal(User::NEW_LEVEL, result)
  end

  ## Level 14 ##
  test "apply_question_results level_should_be_14_total_correct_is_90" do
    @user.update_attributes!(:correct_questions => 89, :level => 13)
    result = @user.apply_question_results(Subject::ART, Question::CORRECT)
    assert_equal(14, @user.level)
    assert_equal(User::NEW_LEVEL, result)
  end

  ## Level 20 ##
  test "apply_question_results level_should_be_20_total_correct_is_150" do
    @user.update_attributes!(:correct_questions => 149, :level => 19)
    result = @user.apply_question_results(Subject::ART, Question::CORRECT)
    assert_equal(20, @user.level)
    assert_equal(User::NEW_LEVEL, result)
  end

  test "apply_question_results level_should_still_be_20_total_correct_is_155" do
    @user.update_attributes!(:correct_questions => 154, :level => 20)
    result = @user.apply_question_results(Subject::ART, Question::CORRECT)
    assert_equal(20, @user.level)
    assert_equal(User::SAME_LEVEL, result)
  end

  test "apply_question_results level_should_still_be_20_total_correct_is_160" do
    @user.update_attributes!(:correct_questions => 159, :level => 20)
    result = @user.apply_question_results(Subject::ART, Question::CORRECT)
    assert_equal(20, @user.level)
    assert_equal(User::SAME_LEVEL, result)
  end

  ## Level 21 ##
  test "apply_question_results level_should_be_21_total_correct_is_165" do
    @user.update_attributes!(:correct_questions => 164, :level => 20)
    result = @user.apply_question_results(Subject::ART, Question::CORRECT)
    assert_equal(21, @user.level)
    assert_equal(User::NEW_LEVEL, result)
  end

  ## Level 30 ##
  test "apply_question_results level_should_be_30_total_correct_is_300" do
    @user.update_attributes!(:correct_questions => 299, :level => 29)
    result = @user.apply_question_results(Subject::ART, Question::CORRECT)
    assert_equal(30, @user.level)
    assert_equal(User::NEW_LEVEL, result)
  end

  test "apply_question_results level_should_still_be_30_total_correct_is_315" do
    @user.update_attributes!(:correct_questions => 314, :level => 30)
    result = @user.apply_question_results(Subject::ART, Question::CORRECT)
    assert_equal(30, @user.level)
    assert_equal(User::SAME_LEVEL, result)
  end

  ## Level 31 ##
  test "apply_question_results level_should_be_31_total_correct_is_320" do
    @user.update_attributes!(:correct_questions => 319, :level => 30)
    result = @user.apply_question_results(Subject::ART, Question::CORRECT)
    assert_equal(31, @user.level)
    assert_equal(User::NEW_LEVEL, result)
  end

  ## Level 32 ##
  test "apply_question_results level_should_be_32_total_correct_is_340" do
    @user.update_attributes!(:correct_questions => 339, :level => 31)
    result = @user.apply_question_results(Subject::ART, Question::CORRECT)
    assert_equal(32, @user.level)
    assert_equal(User::NEW_LEVEL, result)
  end
end
