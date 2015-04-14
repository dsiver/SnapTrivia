require 'test_helper'

class QuestionTest < ActiveSupport::TestCase

  test "questions_by_subject should_return_false_no_subjects_but_art" do
    questions = Question.questions_by_subject('Art')
    result = questions.any?{|q| q.subject_title != 'Art'}
    assert_equal(false, result)
  end

  test "questions_by_subject should_return_length_greater_1" do
    questions = Question.questions_by_subject('Art')
    expression = questions.size > 1
    assert_equal(1, questions.size)
  end

  test "questions_by_subject should_return" do
    questions = Question.questions_by_subject('Art')
    expression = questions.size > 1
    assert_equal(1, questions.length)
  end

  test "questions_by_subject should_return_something" do
    questions = Question.questions_by_subject('Art')
    expression = questions.size > 1
    assert_equal(1, questions.count)
  end

end
