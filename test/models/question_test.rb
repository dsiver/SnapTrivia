require 'test_helper'

class QuestionTest < ActiveSupport::TestCase

  ################################# questions_by_subject #################################

  test "questions_by_subject should_return_false_no_subjects_but_art" do
    questions = Question.questions_by_subject(Subject::ART)
    result = questions.any?{|q| q.subject_title != Subject::ART}
    assert_equal(false, result)
  end

  test "questions_by_subject should_return_false_no_subjects_but_ent" do
    questions = Question.questions_by_subject(Subject::ENTERTAINMENT)
    result = questions.any?{|q| q.subject_title != Subject::ENTERTAINMENT}
    assert_equal(false, result)
  end

  test "questions_by_subject should_return_length_greater_1" do
    questions = Question.questions_by_subject(Subject::ART)
    expression = questions.length > 1
    assert_equal(true, expression)
  end

  ################################# questions_by_difficulty #################################

  test "questions_by_difficulty should_return_low" do
    questions = Question.questions_by_difficulty(Question::DIFFICULTY_LOW, Subject::ART, 3)
    assert_not_empty(questions)
    assert_equal(3, questions.count)
    assert_equal(true, questions.any?{|q| q.difficulty == Question::DIFFICULTY_LOW})
    assert_equal(false, questions.any?{|q| q.difficulty == Question::DIFFICULTY_MEDIUM})
    assert_equal(false, questions.any?{|q| q.difficulty == Question::DIFFICULTY_HIGH})
  end

  test "questions_by_difficulty should_return_medium" do
    questions = Question.questions_by_difficulty(Question::DIFFICULTY_MEDIUM, Subject::ART, 3)
    assert_not_empty(questions)
    assert_equal(3, questions.count)
    assert_equal(true, questions.any?{|q| q.difficulty == Question::DIFFICULTY_MEDIUM})
    assert_equal(false, questions.any?{|q| q.difficulty == Question::DIFFICULTY_LOW})
    assert_equal(false, questions.any?{|q| q.difficulty == Question::DIFFICULTY_HIGH})
  end

  test "questions_by_difficulty should_return_high" do
    questions = Question.questions_by_difficulty(Question::DIFFICULTY_HIGH, Subject::ART, 3)
    assert_not_empty(questions)
    assert_equal(3, questions.count)
    assert_equal(true, questions.any?{|q| q.difficulty == Question::DIFFICULTY_HIGH})
    assert_equal(false, questions.any?{|q| q.difficulty == Question::DIFFICULTY_LOW})
    assert_equal(false, questions.any?{|q| q.difficulty == Question::DIFFICULTY_MEDIUM})
  end

  ################################# questions_by_user_experience #################################

  #### For Beginner Experience Level ####

  test "questions_by_user_experience beginner_should_return_4_questions" do
    questions = Question.questions_by_user_experience(User::BEGINNER, Subject::ART)
    #questions.each do |question| puts "\n\n #{question.inspect}\n #{question.class}" end
    assert_equal(4, questions.count)
  end

  test "questions_by_user_experience beginner_should_get_questions_out_of_order" do
    questions = Question.questions_by_user_experience(User::BEGINNER, Subject::ART)
    questions_in_order = Question.questions_by_difficulty(Question::DIFFICULTY_LOW, Subject::ART, 3)
    questions_in_order += Question.questions_by_difficulty(Question::DIFFICULTY_MEDIUM, Subject::ART, 1)
    assert_not_equal(questions, questions_in_order)
  end

  test "questions_by_user_experience beginner_should_return_3_low_difficulty_questions" do
    questions = Question.questions_by_user_experience(User::BEGINNER, Subject::ART)
    low_diff = questions.select { |question| question.difficulty == Question::DIFFICULTY_LOW }
    assert_equal(3, low_diff.count)
  end

  test "questions_by_user_experience beginner_should_return_1_med_difficulty_question" do
    questions = Question.questions_by_user_experience(User::BEGINNER, Subject::ART)
    med_diff = questions.select { |question| question.difficulty == Question::DIFFICULTY_MEDIUM }
    assert_equal(1, med_diff.count)
  end

  #### For Intermediate Experience Level ####

  test "questions_by_user_experience intermediate_should_return_4_questions" do
    questions = Question.questions_by_user_experience(User::INTERMEDIATE, Subject::ART)
    assert_equal(4, questions.count)
  end

  test "questions_by_user_experience intermediate_should_return_3_med_difficulty_questions" do
    questions = Question.questions_by_user_experience(User::INTERMEDIATE, Subject::ART)
    med_diff = questions.select { |question| question.difficulty == Question::DIFFICULTY_MEDIUM }
    assert_equal(3, med_diff.count)
  end

  test "questions_by_user_experience intermediate_should_return_1_low_difficulty_question" do
    questions = Question.questions_by_user_experience(User::INTERMEDIATE, Subject::ART)
    low_diff = questions.select { |question| question.difficulty == Question::DIFFICULTY_LOW }
    assert_equal(1, low_diff.count)
  end

  #### For Advanced Experience Level ####

  test "questions_by_user_experience advanced_should_return_4_questions" do
    questions = Question.questions_by_user_experience(User::ADVANCED, Subject::ART)
    assert_equal(4, questions.count)
  end

  test "questions_by_user_experience advanced_should_return_3_med_difficulty_questions" do
    questions = Question.questions_by_user_experience(User::ADVANCED, Subject::ART)
    med_diff = questions.select { |question| question.difficulty == Question::DIFFICULTY_MEDIUM }
    assert_equal(3, med_diff.count)
  end

  test "questions_by_user_experience advanced_should_return_1_high_difficulty_question" do
    questions = Question.questions_by_user_experience(User::ADVANCED, Subject::ART)
    high_diff = questions.select { |question| question.difficulty == Question::DIFFICULTY_HIGH }
    assert_equal(1, high_diff.count)
  end

  #### For Expert Experience Level ####

  test "questions_by_user_experience expert_should_return_4_questions" do
    questions = Question.questions_by_user_experience(User::EXPERT, Subject::ART)
    assert_equal(4, questions.count)
  end

  test "questions_by_user_experience expert_should_return_3_high_difficulty_questions" do
    questions = Question.questions_by_user_experience(User::EXPERT, Subject::ART)
    high_diff = questions.select { |question| question.difficulty == Question::DIFFICULTY_HIGH }
    assert_equal(3, high_diff.count)
  end

  test "questions_by_user_experience expert_should_return_1_med_difficulty_question" do
    questions = Question.questions_by_user_experience(User::EXPERT, Subject::ART)
    med_diff = questions.select { |question| question.difficulty == Question::DIFFICULTY_MEDIUM }
    assert_equal(1, med_diff.count)
  end
end
