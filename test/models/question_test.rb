require 'test_helper'

class QuestionTest < ActiveSupport::TestCase

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

  test "questions_by_difficulty should_return_low" do
    questions = Question.get_questions_by_difficulty(Question::DIFFICULTY_LOW)
    assert_equal(false, questions.empty?)
    assert_equal(true, questions.any?{|q| q.difficulty == Question::DIFFICULTY_LOW})
    assert_equal(false, questions.any?{|q| q.difficulty == Question::DIFFICULTY_MEDIUM})
    assert_equal(false, questions.any?{|q| q.difficulty == Question::DIFFICULTY_HIGH})
  end

  test "questions_by_difficulty should_return_medium" do
    questions = Question.get_questions_by_difficulty(Question::DIFFICULTY_MEDIUM)
    assert_equal(false, questions.empty?)
    assert_equal(true, questions.any?{|q| q.difficulty == Question::DIFFICULTY_MEDIUM})
    assert_equal(false, questions.any?{|q| q.difficulty == Question::DIFFICULTY_LOW})
    assert_equal(false, questions.any?{|q| q.difficulty == Question::DIFFICULTY_HIGH})
  end

  test "questions_by_difficulty should_return_high" do
    questions = Question.get_questions_by_difficulty(Question::DIFFICULTY_HIGH)
    assert_equal(false, questions.empty?)
    assert_equal(true, questions.any?{|q| q.difficulty == Question::DIFFICULTY_HIGH})
    assert_equal(false, questions.any?{|q| q.difficulty == Question::DIFFICULTY_LOW})
    assert_equal(false, questions.any?{|q| q.difficulty == Question::DIFFICULTY_MEDIUM})
  end

end
