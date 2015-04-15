require 'test_helper'

class ChallengeTest < ActiveSupport::TestCase

  test "template" do
    challenge = Challenge.new
    challenge.save
    assert_not(nil, challenge)
  end

end
