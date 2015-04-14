require 'test_helper'

class QuestionTest < ActiveSupport::TestCase
  test "questions_by_subject should_return_true_all_art" do
    questions = Question.questions_by_subject('Art')
    result = !questions.any?{|q| q.subject_title != 'Art'}
    assert_equal(true, result)
  end
end
