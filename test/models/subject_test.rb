require 'test_helper'

class SubjectTest < ActiveSupport::TestCase

  def setup
    @subjects = [Subject::ART, Subject::ENTERTAINMENT, Subject::GEOGRAPHY, Subject::HISTORY, Subject::SCIENCE, Subject::SPORTS]
  end

  def teardown
    @subjects = nil
  end

  test "Subject::subjects should_not_return_nil_array" do
    subjects = Subject::subjects
    assert_not_equal(nil, subjects)
  end

  test "Subject::subjects should_return_matching_array" do
    assert_equal(Subject::subjects, @subjects)
  end

  test "Subject::subjects should_not_return_array_with_subjects_out_of_order" do
    @subjects.shuffle!
    assert_not_equal(Subject::subjects, subjects)
  end
end
