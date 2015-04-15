require 'test_helper'

class ChallengeTest < ActiveSupport::TestCase


  test "template" do
    game = Game.new(id: 1, player1_id: 3, player2_id: 4, player1_turn: true, game_status: 'active',
                    art_trophy_p1: false, entertainment_trophy_p1: false, history_trophy_p1: false,
                    geography_trophy_p1: false, science_trophy_p1: false, sports_trophy_p1: false,
                    art_trophy_p2: false, entertainment_trophy_p2: false, history_trophy_p2: false,
                    geography_trophy_p2: false, science_trophy_p2: false, sports_trophy_p2: false)
    game.save
    challenge = Challenge.new
    challenge.set_game_attributes(1, 3, 'Art', 'Entertainment')
    challenge.generate_question_ids
    challenge.save
    assert_not(nil, challenge)
  end

end
