require 'test_helper'

class UserTest < ActiveSupport::TestCase

  def setup
    @user = User.find(4)
  end

  def teardown
    @user = nil
  end

  ################################ playable_users_by_name ################################

  test "playable_users_by_name should not be nil" do
    test_user = User.find(2)
    results = @user.playable_users_by_name(test_user.name)
    assert_not_nil(results)
  end

  ################ give_coins ################

  ######## raises error ########

  test "give_coins raises_error_quantity_is_negative" do
    assert_raises(RuntimeError){@user.give_coins(-1)}
  end

  test "give_coins raises_error_quantity_is_0" do
    assert_raises(RuntimeError){@user.give_coins(0)}
  end

  test "give_coins raises_error_quantity_is_string" do
    assert_raises(RuntimeError){@user.give_coins("")}
  end

  ######## gives specified amount ########

  test "give_coins coins_incremented_by_1" do
    old_coins = @user.coins
    @user.give_coins(1)
    assert_equal(old_coins + 1, @user.coins)
  end

  test "give_coins coins_incremented_by_5" do
    old_coins = @user.coins
    @user.give_coins(5)
    assert_equal(old_coins + 5, @user.coins)
  end

  test "give_coins coins_incremented_by_5_after_5_iterations" do
    old_coins = @user.coins
    5.times{@user.give_coins(1)}
    assert_equal(old_coins + 5, @user.coins)
  end

  ################################ power ups ################################

  ################ extra_time ################

  ######## has_extra_time? ########

  #### tests for false ####

  test "has_extra_time? should be false no coins" do
    assert_not(@user.has_extra_time?)
  end

  test "has_extra_time? should be false one less than cost" do
    @user.coins = User::COST_EXTRA_TIME - 1
    assert_not(@user.has_extra_time?)
  end

  test "has_extra_time? should be false none left after use_extra_time" do
    @user.coins = User::COST_EXTRA_TIME
    @user.use_extra_time
    assert_not(@user.has_extra_time?)
  end

  test "has_extra_time? should be false after use_remove_wrong_answer" do
    @user.coins = User::COST_EXTRA_TIME + User::COST_REM_WRONG_ANS - 1
    @user.use_remove_wrong_answer
    assert_not(@user.has_extra_time?)
  end

  test "has_extra_time? should be false after use_skip_question" do
    @user.coins = User::COST_EXTRA_TIME + User::COST_SKIP_QUESTION - 1
    @user.use_skip_question
    assert_not(@user.has_extra_time?)
  end

  #### tests for true ####

  test "has_extra_time? should be true has enough" do
    @user.coins = User::COST_EXTRA_TIME
    assert(@user.has_extra_time?)
  end

  test "has_extra_time? should be true has one over cost" do
    @user.coins = User::COST_EXTRA_TIME + 1
    assert(@user.has_extra_time?)
  end

  test "has_extra_time? should be true after use_remove_wrong_answers" do
    @user.coins = User::COST_EXTRA_TIME + User::COST_REM_WRONG_ANS
    @user.use_remove_wrong_answer
    assert(@user.has_extra_time?)
  end

  test "has_extra_time? should be true after use_skip_question" do
    @user.coins = User::COST_EXTRA_TIME + User::COST_SKIP_QUESTION
    @user.use_skip_question
    assert(@user.has_extra_time?)
  end

  ######## use_extra_time ########

  test "use_extra_time should return false not enough coins" do
    @user.coins = User::COST_EXTRA_TIME - 1
    assert_not(@user.use_extra_time)
  end

  test "use_extra_time should return true has one over cost" do
    @user.coins = User::COST_EXTRA_TIME + 1
    assert(@user.use_extra_time)
  end

  test "use_extra_time should deduct cost of use_extra_time" do
    old_coins = @user.coins
    @user.coins += User::COST_EXTRA_TIME
    assert_equal(@user.coins, old_coins + User::COST_EXTRA_TIME)
    @user.use_extra_time
    assert_equal(@user.coins, old_coins)
  end

  ################ remove_wrong_answers ################

  ######## has_remove_wrong_answers? ########

  #### tests for false ####

  test "has_remove_wrong_answers? should be false no coins" do
    assert_not(@user.has_remove_wrong_answers?)
  end

  test "has_remove_wrong_answers? should be false not enough coins" do
    @user.coins = User::COST_REM_WRONG_ANS - 1
    assert_not(@user.has_remove_wrong_answers?)
  end

  test "has_remove_wrong_answers? should be false none left after use_remove_wrong_answers" do
    @user.coins = User::COST_REM_WRONG_ANS
    @user.use_remove_wrong_answer
    assert_not(@user.has_remove_wrong_answers?)
  end

  test "has_remove_wrong_answers? should be false after use_extra_time" do
    @user.coins = User::COST_REM_WRONG_ANS + User::COST_EXTRA_TIME - 1
    @user.use_extra_time
    assert_not(@user.has_remove_wrong_answers?)
  end

  test "has_remove_wrong_answers? should be false after use_skip_question" do
    @user.coins = User::COST_REM_WRONG_ANS + User::COST_SKIP_QUESTION - 1
    @user.use_skip_question
    assert_not(@user.has_remove_wrong_answers?)
  end

  #### tests for true ####

  test "has_remove_wrong_answers? should be true has enough" do
    @user.coins = User::COST_REM_WRONG_ANS
    assert(@user.has_remove_wrong_answers?)
  end

  test "has_remove_wrong_answers? should be true has one over cost" do
    @user.coins = User::COST_REM_WRONG_ANS + 1
    assert(@user.has_remove_wrong_answers?)
  end

  test "has_remove_wrong_answers? should be true after use_extra_time" do
    @user.coins = User::COST_REM_WRONG_ANS + User::COST_EXTRA_TIME
    @user.use_extra_time
    assert(@user.has_remove_wrong_answers?)
  end

  test "has_remove_wrong_answers? should be true after use_skip_question" do
    @user.coins = User::COST_REM_WRONG_ANS + User::COST_SKIP_QUESTION
    @user.use_skip_question
    assert(@user.has_remove_wrong_answers?)
  end

=begin
  ######## power_ups ########

  #### extra time ####

  test "power_ups should_be_zero_give_extra_time" do
    assert_equal(0, @user.power_ups(Question::EXTRA_TIME))
  end

  test "power_ups should_be_one_give_extra_time" do
    @user.give_extra_time
    assert_equal(1, @user.power_ups(Question::EXTRA_TIME))
  end

  test "power_ups should_be_zero_after_use_extra_time" do
    @user.give_extra_time
    @user.use_extra_time
    assert_equal(0, @user.power_ups(Question::EXTRA_TIME))
  end

  test "power_ups should_be_one_after_remove_wrong_answers" do
    @user.give_extra_time
    @user.give_remove_wrong_answers
    @user.use_remove_wrong_answer
    assert_equal(1, @user.power_ups(Question::EXTRA_TIME))
  end

  #### remove wrong answers ####

  test "power_ups should_be_zero_remove_wrong_answers" do
    assert_equal(0, @user.power_ups(Question::REMOVE_WRONG_ANSWERS))
  end

  #### skip question ####

  test "power_ups should_be_zero_skip_question" do
    assert_equal(0, @user.power_ups(Question::SKIP_QUESTION))
  end

  ################ extra time power up ################

  ######## has_extra_time ########

  test "has_extra_time? should_be_false" do
    assert_not(@user.has_extra_time?)
  end

  test "has_extra_time? should_be_true" do
    @user.give_extra_time
    assert(@user.has_extra_time?)
  end

  test "has_extra_time? should_still_be_true_after_using_skip_question" do
    @user.give_extra_time
    @user.give_skip_question
    @user.use_skip_question
    assert(@user.has_extra_time?)
  end

  ######## give_extra_time ########

  test "give_extra_time points_should_be_one" do
    1.times {@user.give_extra_time}
    @user.save
    assert_equal(1, @user.power_ups(Question::EXTRA_TIME))
  end

  ######## use_extra_time ########

  test "use_extra_time should_decrease_by_one" do
    2.times {@user.give_extra_time}
    @user.save
    @user.use_extra_time
    assert_equal(1, @user.power_ups(Question::EXTRA_TIME))
  end

  ################ remove wrong answers power up ################

  ######## has_remove_wrong_answers ########

  test "has_remove_wrong_answers? should_be_false" do
    assert_equal(false, @user.has_remove_wrong_answers?)
  end

  test "has_remove_wrong_answers? should_be_true" do
    @user.give_remove_wrong_answers
    assert_equal(true, @user.has_remove_wrong_answers?)
  end

  ######## give_remove_wrong_answers ########

  test "give_remove_wrong_answers points_should_be_one" do
    1.times {@user.give_remove_wrong_answers}
    @user.save
    assert_equal(1, @user.power_ups(Question::REMOVE_WRONG_ANSWERS))
  end

  ######## use_remove_wrong_answer ########

  test "use_remove_wrong_answer should_decrease_by_one" do
    2.times {@user.give_remove_wrong_answers}
    @user.save
    @user.use_remove_wrong_answer
    assert_equal(1, @user.power_ups(Question::REMOVE_WRONG_ANSWERS))
  end

  ################ skip question power up ################

  ######## has_skip_question ########

  test "has_skip_question? should_be_false" do
    assert_equal(false, @user.has_skip_question?)
  end

  test "has_skip_question? should_be_true" do
    @user.give_skip_question
    assert_equal(true, @user.has_skip_question?)
  end

  ######## give_skip_question ########

  test "give_skip_question points_should_be_one" do
    1.times {@user.give_skip_question}
    @user.save
    assert_equal(1, @user.power_ups(Question::SKIP_QUESTION))
  end

  ######## use_skip_question ########

  test "use_skip_question should_decrease_by_one" do
    2.times {@user.give_skip_question}
    @user.save
    @user.use_skip_question
    assert_equal(1, @user.power_ups(Question::SKIP_QUESTION))
  end
=end

  ################################# increment_correct_questions #################################

  test "increment_correct_questions should_be_1_correct_questions" do
    @user.increment_correct_questions
    assert_equal(1, @user.correct_questions)
  end

  ################################# badges #################################

  ######## testing add_badge ########

  test "add_badge should_give_user_beginner" do
    @user.add_badge(Merit::BadgeRules::BEGINNER_ID)
    assert_equal(true, @user.badges.any? { |badge| badge.id == Merit::BadgeRules::BEGINNER_ID })
  end

  test "add_badge should_give_user_intermediate" do
    @user.add_badge(Merit::BadgeRules::INTERMEDIATE_ID)
    assert_equal(true, @user.badges.any? { |badge| badge.id == Merit::BadgeRules::INTERMEDIATE_ID })
  end

  test "add_badge should_give_user_advanced" do
    @user.add_badge(Merit::BadgeRules::ADVANCED_ID)
    assert_equal(true, @user.badges.any? { |badge| badge.id == Merit::BadgeRules::ADVANCED_ID })
  end

  test "add_badge should_give_user_expert" do
    @user.add_badge(Merit::BadgeRules::EXPERT_ID)
    assert_equal(true, @user.badges.any? { |badge| badge.id == Merit::BadgeRules::EXPERT_ID })
  end

  test "add_badge should_give_user_first_win" do
    @user.add_badge(Merit::BadgeRules::FIRST_WIN_ID)
    assert_equal(true, @user.badges.any? { |badge| badge.id == Merit::BadgeRules::FIRST_WIN_ID })
  end

  ######## testing has_badge? ########

  #### true ####

  test "has_badge? should_return_true_has_beginner" do
    @user.add_badge(Merit::BadgeRules::BEGINNER_ID)
    assert_equal(true, @user.has_badge?(Merit::BadgeRules::BEGINNER_ID))
  end

  test "has_badge? should_return_true_has_intermediate" do
    @user.add_badge(Merit::BadgeRules::INTERMEDIATE_ID)
    assert_equal(true, @user.has_badge?(Merit::BadgeRules::INTERMEDIATE_ID))
  end

  test "has_badge? should_return_true_has_advanced" do
    @user.add_badge(Merit::BadgeRules::ADVANCED_ID)
    assert_equal(true, @user.has_badge?(Merit::BadgeRules::ADVANCED_ID))
  end

  test "has_badge? should_return_true_has_expert" do
    @user.add_badge(Merit::BadgeRules::EXPERT_ID)
    assert_equal(true, @user.has_badge?(Merit::BadgeRules::EXPERT_ID))
  end

  #### false ####

  test "has_badge? should_return_false_no_beginner" do
    assert_equal(false, @user.has_badge?(Merit::BadgeRules::BEGINNER_ID))
  end

  test "has_badge? should_return_false_no_intermediate" do
    @user.add_badge(Merit::BadgeRules::BEGINNER_ID)
    assert_equal(false, @user.has_badge?(Merit::BadgeRules::INTERMEDIATE_ID))
  end

  test "has_badge? should_return_false_no_advanced" do
    @user.add_badge(Merit::BadgeRules::BEGINNER_ID)
    @user.add_badge(Merit::BadgeRules::INTERMEDIATE_ID)
    assert_equal(false, @user.has_badge?(Merit::BadgeRules::ADVANCED_ID))
  end

  test "has_badge? should_return_false_no_expert" do
    @user.add_badge(Merit::BadgeRules::BEGINNER_ID)
    @user.add_badge(Merit::BadgeRules::INTERMEDIATE_ID)
    @user.add_badge(Merit::BadgeRules::ADVANCED_ID)
    assert_equal(false, @user.has_badge?(Merit::BadgeRules::EXPERT_ID))
  end

  ######## testing give_badge ########

  test "give_badge should_give_beginner_level_2" do
    @user.update_attributes!(:level => 2)
    @user.give_badge
    assert_equal(true, @user.has_badge?(Merit::BadgeRules::BEGINNER_ID))
  end

  test "give_badge should_give_intermediate_level_11" do
    @user.update_attributes!(:level => 11)
    @user.give_badge
    assert_equal(true, @user.has_badge?(Merit::BadgeRules::INTERMEDIATE_ID))
  end

  test "give_badge should_give_advanced_level_21" do
    @user.update_attributes!(:level => 21)
    @user.give_badge
    assert_equal(true, @user.has_badge?(Merit::BadgeRules::ADVANCED_ID))
  end

  test "give_badge should_give_expert_level_31" do
    @user.update_attributes!(:level => 31)
    @user.give_badge
    assert_equal(true, @user.has_badge?(Merit::BadgeRules::EXPERT_ID))
  end

  ######## testing give_winner_trophy ########

  test "give_winner_trophy should_give_first_win_total_wins_is_1" do
    @user.update_attributes!(:total_wins => 1)
    @user.give_winner_trophy
    assert_equal(true, @user.has_badge?(Merit::BadgeRules::FIRST_WIN_ID))
  end

  ################################# level_up_player #################################

  test "level_up_player should_give_1_coin_from_level_1_to_2" do
    old_coins = @user.coins
    @user.level_up_player
    assert_not_equal(old_coins, @user.coins)
    assert_equal(1, @user.coins)
  end

  test "level_up_player should_give_2_coins_from_level_10_to_11" do
    @user.update_attributes!(:correct_questions => 60, :level => 10)
    @user.level_up_player
    assert_equal(11, @user.level)
    assert_equal(2, @user.coins)
  end

  test "level_up_player should_give_3_coins_from_level_20_to_21" do
    @user.update_attributes!(:correct_questions => 165, :level => 20)
    @user.level_up_player
    assert_equal(21, @user.level)
    assert_equal(3, @user.coins)
  end

  test "level_up_player should_give_5_coins_from_level_30_to_31" do
    @user.update_attributes!(:correct_questions => 320, :level => 30)
    @user.level_up_player
    assert_equal(31, @user.level)
    assert_equal(5, @user.coins)
  end

  ################################# experience_level #################################

  test "experience_level should_be_beginner_user_level_10" do
    assert_equal(User::BEGINNER, @user.experience_level)
  end

  test "experience_level should_be_intermediate_user_level_19" do
    @user.update_attributes!(:level => 19)
    assert_equal(User::INTERMEDIATE, @user.experience_level)
  end

  test "experience_level should_be_intermediate_user_level_20" do
    @user.update_attributes!(:level => 20)
    assert_equal(User::INTERMEDIATE, @user.experience_level)
  end

  test "experience_level should_be_advanced_user_level_29" do
    @user.update_attributes!(:level => 29)
    assert_equal(User::ADVANCED, @user.experience_level)
  end

  test "experience_level should_be_advanced_user_level_30" do
    @user.update_attributes!(:level => 30)
    assert_equal(User::ADVANCED, @user.experience_level)
  end

  test "experience_level should_be_expert_user_level_31" do
    @user.update_attributes!(:level => 31)
    assert_equal(User::EXPERT, @user.experience_level)
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

  ######## testing achievements ########

  #### Badges ####

  test "apply_question_results should_have_beginner_badge_level_2" do
    @user.update_attributes!(:correct_questions => 4)
    @user.apply_question_results(Subject::ART, Question::CORRECT)
    assert_equal(true, @user.has_badge?(Merit::BadgeRules::BEGINNER_ID))
  end

  test "apply_question_results should_have_intermediate_level_11" do
    @user.update_attributes!(:correct_questions => 59, :level => 10)
    @user.apply_question_results(Subject::ART, Question::CORRECT)
    assert_equal(true, @user.has_badge?(Merit::BadgeRules::INTERMEDIATE_ID))
  end

  test "apply_question_results should_have_advanced_level_21" do
    @user.update_attributes!(:correct_questions => 164, :level => 20)
    @user.apply_question_results(Subject::ART, Question::CORRECT)
    assert_equal(true, @user.has_badge?(Merit::BadgeRules::ADVANCED_ID))
  end

  test "apply_question_results should_have_expert_level_31" do
    @user.update_attributes!(:correct_questions => 319, :level => 30)
    @user.apply_question_results(Subject::ART, Question::CORRECT)
    assert_equal(true, @user.has_badge?(Merit::BadgeRules::EXPERT_ID))
  end
end
