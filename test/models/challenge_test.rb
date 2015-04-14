require 'test_helper'

class ChallengeTest < ActiveSupport::TestCase

  test "template" do
    challenge = Challenge.new
    challenge.save
    assert_not(nil, challenge)
  end

  test "set_game_attributes art_id_should_be_1" do
    challenge = Challenge.new
    challenge.generate_question_ids
    challenge.save
    assert_equal(1, challenge.art_id)
  end

end
