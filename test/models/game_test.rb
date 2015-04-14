require 'test_helper'

class GameTest < ActiveSupport::TestCase

  test "template" do
    game = Game.new
    game.player1_id = 3
    game.player2_id = 4
    game.art_trophy_p1 = true
    game.entertainment_trophy_p1 = true
    game.history_trophy_p1 = true
    game.geography_trophy_p1 = true
    game.science_trophy_p1 = true
    game.sports_trophy_p1 = true
    game.art_trophy_p2 = true
    game.entertainment_trophy_p2 = true
    game.history_trophy_p2 = true
    game.geography_trophy_p2 = true
    game.science_trophy_p2 = true
    game.sports_trophy_p2 = true
    game.save
    assert_equal(true, true)
  end

  # Template for winnable_trophies
  # Method for assert_equal param 2
  # game.get_winnable_trophies(challenger_id)
  test "get_winnable_trophies should_be__p_challenger" do
    expected_winnable = []
    game = Game.new
    game.player1_id = 3
    game.player2_id = 4
    game.art_trophy_p1 = true
    game.entertainment_trophy_p1 = true
    game.history_trophy_p1 = true
    game.geography_trophy_p1 = true
    game.science_trophy_p1 = true
    game.sports_trophy_p1 = true
    game.art_trophy_p2 = true
    game.entertainment_trophy_p2 = true
    game.history_trophy_p2 = true
    game.geography_trophy_p2 = true
    game.science_trophy_p2 = true
    game.sports_trophy_p2 = true
    game.save
    challenger_id = game.player1_id
    assert_equal(expected_winnable, game.get_winnable_trophies(challenger_id))
  end

  # Method for assert_equal param 2
  # game.get_winnable_trophies(challenger_id)
  test "get_winnable_trophies should_be_art_p1_challenger" do
    expected_winnable = ["Sports"]
    game = Game.new
    game.player1_id = 3
    game.player2_id = 4
    game.art_trophy_p1 = true
    game.entertainment_trophy_p1 = true
    game.entertainment_trophy_p2 = true
    game.sports_trophy_p2 = true
    game.save
    challenger_id = game.player1_id
    assert_equal(expected_winnable, game.get_winnable_trophies(challenger_id))
  end

  test "end_game should_be_false_not_over" do
    game = Game.new
    game.player1_id = 3
    game.player2_id = 4
    game.save
    assert_equal(true, game.game_status == "active")
  end

  test "end_game should_be_true_over" do
    game = Game.new
    game.player1_id = 3
    game.player2_id = 4
    game.game_status = 'game_over'
    game.save
    assert_equal(true, game.game_status != "active")
  end

  test "give_trophy should_have_art" do
    game = Game.new
    game.player1_id = 3
    game.player2_id = 4
    game.art_trophy_p1 = true
    game.save
    assert_equal(true, game.art_trophy_p1?)
  end

  test "give_trophy should_have_ent" do
    game = Game.new
    game.player1_id = 3
    game.player2_id = 4
    game.entertainment_trophy_p1 = true
    game.save
    assert_equal(true, game.entertainment_trophy_p1)
  end

  test "give_trophy should_have_hist" do
    game = Game.new
    game.player1_id = 3
    game.player2_id = 4
    game.history_trophy_p1 = true
    game.save
    assert_equal(true, game.history_trophy_p1)
  end

  test "give_trophy should_have_geo" do
    game = Game.new
    game.player1_id = 3
    game.player2_id = 4
    game.geography_trophy_p1 = true
    game.save
    assert_equal(true, game.geography_trophy_p1)
  end

  test "give_trophy should_have_sci" do
    game = Game.new
    game.player1_id = 3
    game.player2_id = 4
    game.science_trophy_p1 = true
    game.save
    assert_equal(true, game.science_trophy_p1)
  end

  test "give_trophy should_have_spo" do
    game = Game.new
    game.player1_id = 3
    game.player2_id = 4
    game.sports_trophy_p1 = true
    game.save
    assert_equal(true, game.sports_trophy_p1)
  end

  test "give_trophy_p2 should_have_hist" do
    game = Game.new
    game.player1_id = 3
    game.player2_id = 4
    game.history_trophy_p2 = true
    game.save
    assert_equal(true, game.history_trophy_p2)
  end

  test "reset_answers_should_be_zero" do
    game = Game.new
    game.player1_id = 3
    game.player2_id = 4
    game.answers_correct = 1
    game.reset_answers
    game.save
    assert_equal(0, game.answers_correct)
  end

  test "end_round_should_end_p1_turn" do
    game = Game.new
    game.player1_id = 3
    game.player2_id = 4
    game.end_round(game.player1_id, 1)
    assert_equal(false, game.player1_turn?)
  end

  test "end_round_should_end_p2_turn" do
    game = Game.new
    game.player1_id = 3
    game.player2_id = 4
    game.player1_turn = false
    game.end_round(game.player2_id, 1)
    assert_equal(true, game.player1_turn?)
  end

  test "can_challenge? should_be_false_no_trophies" do
    game = Game.new
    game.player1_id = 3
    game.player2_id = 4
    game.save
    assert_equal(false, game.can_challenge?)
  end

  test "can_challenge? should_be_false_challenger_p1_has_1_defender_none" do
    game = Game.new
    game.player1_id = 3
    game.player2_id = 4
    game.art_trophy_p1 = true
    game.save
    assert_equal(false, game.can_challenge?)
  end

  test "can_challenge? should_be_false_challenger_p2_has_1_defender_none" do
    game = Game.new
    game.player1_id = 3
    game.player2_id = 4
    game.art_trophy_p2 = true
    game.save
    assert_equal(false, game.can_challenge?)
  end

  test "can_challenge? should_be_false_same trophies" do
    game = Game.new
    game.player1_id = 3
    game.player2_id = 4
    game.art_trophy_p1 = true
    game.art_trophy_p2 = true
    game.save
    assert_equal(false, game.can_challenge?)
  end

  test "can_challenge? should_be_true_different trophies" do
    game = Game.new
    game.player1_id = 3
    game.player2_id = 4
    game.art_trophy_p1 = true
    game.entertainment_trophy_p2 = true
    game.save
    assert_equal(true, game.can_challenge?)
  end

  test "can_challenge? should_be_false_challenger_p1_has_2_defender_has_1_common" do
    game = Game.new
    game.player1_id = 3
    game.player2_id = 4
    game.art_trophy_p1 = true
    game.entertainment_trophy_p1 = true
    game.entertainment_trophy_p2 = true
    game.save
    assert_equal(false, game.can_challenge?)
  end

  test "can_challenge? should_be_false_all trophies_in_common" do
    game = Game.new
    game.player1_id = 3
    game.player2_id = 4
    game.art_trophy_p1 = true
    game.entertainment_trophy_p1 = true
    game.art_trophy_p2 = true
    game.entertainment_trophy_p2 = true
    game.save
    assert_equal(false, game.can_challenge?)
  end

  test "can_challenge? should_be_false_challenger_p1_nothing_to_win" do
    game = Game.new
    game.player1_id = 3
    game.player2_id = 4
    game.art_trophy_p1 = true
    game.entertainment_trophy_p1 = true
    game.history_trophy_p1 = true
    game.art_trophy_p2 = true
    game.entertainment_trophy_p2 = true
    game.save
    assert_equal(false, game.can_challenge?)
  end

  test "can_challenge? should_be_false_challenger_p2_nothing_to_win" do
    game = Game.new
    game.player1_id = 3
    game.player2_id = 4
    game.art_trophy_p1 = true
    game.entertainment_trophy_p1 = true
    game.art_trophy_p2 = true
    game.entertainment_trophy_p2 = true
    game.history_trophy_p2 = true
    game.save
    assert_equal(false, game.can_challenge?)
  end

  test "can_challenge? should_be_false_challenger_p1_nothing_to_win_geo" do
    game = Game.new
    game.player1_id = 3
    game.player2_id = 4
    game.art_trophy_p1 = true
    game.entertainment_trophy_p1 = true
    game.history_trophy_p1 = true
    game.geography_trophy_p1 = true
    game.art_trophy_p2 = true
    game.entertainment_trophy_p2 = true
    game.history_trophy_p2 = true
    game.save
    assert_equal(false, game.can_challenge?)
  end

  test "can_challenge? should_be_false_challenger_p2_nothing_to_win_geo" do
    game = Game.new
    game.player1_id = 3
    game.player2_id = 4
    game.art_trophy_p1 = true
    game.entertainment_trophy_p1 = true
    game.history_trophy_p1 = true
    game.art_trophy_p2 = true
    game.entertainment_trophy_p2 = true
    game.history_trophy_p2 = true
    game.geography_trophy_p2 = true
    game.save
    assert_equal(false, game.can_challenge?)
  end

  test "can_challenge? should_be_false_challenger_p1_nothing_to_win_sci" do
    game = Game.new
    game.player1_id = 3
    game.player2_id = 4
    game.art_trophy_p1 = true
    game.entertainment_trophy_p1 = true
    game.history_trophy_p1 = true
    game.geography_trophy_p1 = true
    game.science_trophy_p1 = true
    game.art_trophy_p2 = true
    game.entertainment_trophy_p2 = true
    game.history_trophy_p2 = true
    game.geography_trophy_p2 = true
    game.save
    assert_equal(false, game.can_challenge?)
  end

  test "can_challenge? should_be_false_challenger_p2_nothing_to_win_sci" do
    game = Game.new
    game.player1_id = 3
    game.player2_id = 4
    game.art_trophy_p1 = true
    game.entertainment_trophy_p1 = true
    game.history_trophy_p1 = true
    game.geography_trophy_p1 = true
    game.art_trophy_p2 = true
    game.entertainment_trophy_p2 = true
    game.history_trophy_p2 = true
    game.geography_trophy_p2 = true
    game.science_trophy_p2 = true
    game.save
    assert_equal(false, game.can_challenge?)
  end

  test "can_challenge? should_be_false_challenger_p2_only_has_1_no_wager" do
    game = Game.new
    game.player1_id = 3
    game.player2_id = 4
    game.art_trophy_p1 = true
    game.entertainment_trophy_p1 = true
    game.history_trophy_p1 = true
    game.geography_trophy_p1 = true
    game.science_trophy_p1 = true
    game.art_trophy_p2 = true
    game.save
    assert_equal(false, game.can_challenge?)
  end

  test "can_challenge? should_be_false_challenger_p1_only_has_1_no_wager" do
    game = Game.new
    game.player1_id = 3
    game.player2_id = 4
    game.art_trophy_p1 = true
    game.art_trophy_p2 = true
    game.entertainment_trophy_p2 = true
    game.history_trophy_p2 = true
    game.geography_trophy_p2 = true
    game.science_trophy_p2 = true
    game.save
    assert_equal(false, game.can_challenge?)
  end

  test "can_challenge? should_be_true_one_left_common_1" do
    game = Game.new
    game.player1_id = 3
    game.player2_id = 4
    game.art_trophy_p1 = true
    game.entertainment_trophy_p1 = true
    game.art_trophy_p2 = true
    game.sports_trophy_p2 = true
    game.save
    assert_equal(true, game.can_challenge?)
  end

  test "can_challenge? should_be_true_one_left_common_2" do
    game = Game.new
    game.player1_id = 3
    game.player2_id = 4
    game.art_trophy_p1 = true
    game.sports_trophy_p1 = true
    game.art_trophy_p2 = true
    game.entertainment_trophy_p2 = true
    game.save
    assert_equal(true, game.can_challenge?)
  end

  test "can_challenge? should_be_true_one_left_common_3" do
    game = Game.new
    game.player1_id = 3
    game.player2_id = 4
    game.art_trophy_p1 = true
    game.entertainment_trophy_p1 = true
    game.sports_trophy_p1 = true
    game.art_trophy_p2 = true
    game.entertainment_trophy_p2 = true
    game.science_trophy_p2 = true
    game.save
    assert_equal(true, game.can_challenge?)
  end

  test "can_challenge? should_be_true_none_common" do
    game = Game.new
    game.player1_id = 3
    game.player2_id = 4
    game.art_trophy_p1 = true
    game.entertainment_trophy_p1 = true
    game.history_trophy_p1 = true
    game.geography_trophy_p2 = true
    game.science_trophy_p2 = true
    game.sports_trophy_p2 = true
    game.save
    assert_equal(true, game.can_challenge?)
  end

  test "can_challenge? should_be_false_all_same" do
    game = Game.new
    game.player1_id = 3
    game.player2_id = 4
    game.art_trophy_p1 = true
    game.entertainment_trophy_p1 = true
    game.history_trophy_p1 = true
    game.art_trophy_p2 = true
    game.entertainment_trophy_p2 = true
    game.history_trophy_p2 = true
    game.save
    assert_equal(false, game.can_challenge?)
  end

  test "player_wins? should_be_true_p1_all" do
    game = Game.new
    game.player1_id = 3
    game.player2_id = 4
    game.art_trophy_p1 = true
    game.entertainment_trophy_p1 = true
    game.history_trophy_p1 = true
    game.geography_trophy_p1 = true
    game.science_trophy_p1 = true
    game.sports_trophy_p1 = true
    game.art_trophy_p2 = true
    game.entertainment_trophy_p2 = true
    game.history_trophy_p2 = true
    game.save
    assert_equal(true, game.player_wins?(game.player1_id))
  end

  test "player_wins? should_be_false_p1_one_shy" do
    game = Game.new
    game.player1_id = 3
    game.player2_id = 4
    game.art_trophy_p1 = true
    game.entertainment_trophy_p1 = true
    game.history_trophy_p1 = true
    game.geography_trophy_p1 = true
    game.science_trophy_p1 = true
    game.art_trophy_p2 = true
    game.entertainment_trophy_p2 = true
    game.history_trophy_p2 = true
    game.save
    assert_equal(false, game.player_wins?(game.player1_id))
  end

  test "player_wins? should_be_true_p2_all" do
    game = Game.new
    game.player1_id = 3
    game.player2_id = 4
    game.art_trophy_p2 = true
    game.entertainment_trophy_p2 = true
    game.history_trophy_p2 = true
    game.geography_trophy_p2 = true
    game.science_trophy_p2 = true
    game.sports_trophy_p2 = true
    game.save
    assert_equal(true, game.player_wins?(game.player2_id))
  end

end
