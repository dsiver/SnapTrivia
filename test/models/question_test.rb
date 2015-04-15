require 'test_helper'

class QuestionTest < ActiveSupport::TestCase

  test "questions_by_subject should_return_false_no_subjects_but_art" do
    questions = Question.questions_by_subject('Art')
    result = questions.any?{|q| q.subject_title != 'Art'}
    assert_equal(false, result)
  end

  test "questions_by_subject should_return_false_no_subjects_but_ent" do
    questions = Question.questions_by_subject('Entertainment')
    result = questions.any?{|q| q.subject_title != 'Entertainment'}
    assert_equal(false, result)
  end

  test "questions_by_subject should_return_length_greater_1" do
    questions = Question.questions_by_subject('Art')
    expression = questions.length > 1
    assert_equal(true, expression)
  end

end
