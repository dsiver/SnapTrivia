require 'test_helper'

class GameTest < ActiveSupport::TestCase
  BILL_ID = 2
  DAVID_ID = 3
  FALSE = "false"
  TRUE = "true"
  test "small_template" do
    game = Game.new
    game.player1_id = 3
    game.player2_id = 4
    game.save
    assert_equal(true, true)
  end

  test "full_template" do
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

  test "get_winnable_trophies should_be_geo_sci_sports_p1_challenger" do
    expected_winnable = ["Geography", "Science", "Sports"]
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
    challenger_id = game.player1_id
    assert_equal(expected_winnable, game.get_winnable_trophies(challenger_id))
  end

  test "get_winnable_trophies should_be_sci_sports_p1_challenger" do
    expected_winnable = ["Science", "Sports"]
    game = Game.new
    game.player1_id = 3
    game.player2_id = 4
    game.art_trophy_p1 = true
    game.entertainment_trophy_p1 = true
    game.history_trophy_p1 = true
    game.geography_trophy_p1 = true
    game.history_trophy_p2 = true
    game.geography_trophy_p2 = true
    game.science_trophy_p2 = true
    game.sports_trophy_p2 = true
    game.save
    challenger_id = game.player1_id
    assert_equal(expected_winnable, game.get_winnable_trophies(challenger_id))
  end

  # Template for winnable/wagerable_trophies
  test "get_wable_trophies should_be__p_challenger" do
    expected_wable = []
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
    assert_equal(expected_wable, expected_wable)
  end

  test "get_wagerable_trophies should_be_art_p1_challenger" do
    expected_wagerable = ["Art"]
    game = Game.new
    game.player1_id = 3
    game.player2_id = 4
    game.art_trophy_p1 = true
    game.entertainment_trophy_p1 = true
    game.entertainment_trophy_p2 = true
    game.sports_trophy_p2 = true
    game.save
    challenger_id = game.player1_id
    assert_equal(expected_wagerable, game.get_wagerable_trophies(challenger_id))
  end

  test "get_wagerable_trophies should_be_art_ent_hist_p1_challenger" do
    expected_wagerable = ["Art", "Entertainment", "History"]
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
    challenger_id = game.player1_id
    assert_equal(expected_wagerable, game.get_wagerable_trophies(challenger_id))
  end

  test "get_wagerable_trophies should_be_art_ent_p1_challenger" do
    expected_wagerable = ["Art", "Entertainment"]
    game = Game.new
    game.player1_id = 3
    game.player2_id = 4
    game.art_trophy_p1 = true
    game.entertainment_trophy_p1 = true
    game.history_trophy_p1 = true
    game.geography_trophy_p1 = true
    game.history_trophy_p2 = true
    game.geography_trophy_p2 = true
    game.science_trophy_p2 = true
    game.sports_trophy_p2 = true
    game.save
    challenger_id = game.player1_id
    assert_equal(expected_wagerable, game.get_wagerable_trophies(challenger_id))
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

  test "end_round_should_end_p1_turn" do
    game = Game.new
    game.player1_id = 3
    game.player2_id = 4
    game.end_round(game.player1_id)
    assert_equal(false, game.player1_turn?)
  end

  test "end_round_should_end_p2_turn" do
    game = Game.new
    game.player1_id = 3
    game.player2_id = 4
    game.player1_turn = false
    game.end_round(game.player2_id)
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

  test "reset_answers_should_work" do
    game = Game.new
    game.player1_id = 3
    game.player2_id = 4
    game.answers_correct = 3
    game.save
    game.give_trophy('Art', 3)
    game.save
    assert_equal(0, game.answers_correct)
  end

  test "give_trophy should_be_true_p1_art" do
    game = Game.new
    game.player1_id = 3
    game.player2_id = 4
    game.give_trophy('Art', game.player1_id)
    game.save
    assert_equal(true, game.art_trophy_p1?)
  end

  test "give_trophy should_be_true_p2_art" do
    game = Game.new
    game.player1_id = 3
    game.player2_id = 4
    game.give_trophy('Art', game.player2_id)
    game.save
    assert_equal(true, game.art_trophy_p2?)
  end

  test "give_trophy game_art_trophy_p1?_should_be_false_p1_art" do
    game = Game.new
    game.player1_id = 3
    game.player2_id = 4
    game.art_trophy_p1 = true
    game.save
    game.take_trophy('Art', game.player1_id)
    game.save
    assert_equal(false, game.art_trophy_p1?)
  end

  test "give_trophy should_be_false_p2_art" do
    game = Game.new
    game.player1_id = 3
    game.player2_id = 4
    game.art_trophy_p2 = true
    game.save
    game.take_trophy('Art', game.player2_id)
    game.save
    assert_equal(false, game.art_trophy_p2?)
  end

  test "create_challenge should_be_false_challenge.nil?" do
    game = Game.new
    game.id = 1
    game.player1_id = 3
    game.player2_id = 4
    game.art_trophy_p1 = true
    game.entertainment_trophy_p2 = true
    game.save
    game_challenge = game.create_challenge(game.player1_id, 'Art', 'Entertainment')
    assert_equal(false, game_challenge.nil?)
  end

  test "create_challenge should_be_false_p1_challenger_opponent_lost_ent" do
    game = Game.new
    game.id = 1
    game.player1_id = 3
    game.player2_id = 4
    game.art_trophy_p1 = true
    game.entertainment_trophy_p2 = true
    game.save
    game_challenge = game.create_challenge(game.player1_id, 'Art', 'Entertainment')
    game_challenge.update_attributes(challenger_correct: 6, opponent_correct: 1)
    game_challenge.set_winner
    game_challenge.save
    game.apply_challenge_results
    game.save
    assert_equal(false, game.entertainment_trophy_p2?)
  end

  test "create_challenge should_be_true_p1_challenger_gained_ent" do
    game = Game.new
    game.id = 1
    game.player1_id = 3
    game.player2_id = 4
    game.art_trophy_p1 = true
    game.entertainment_trophy_p2 = true
    game.save
    game_challenge = game.create_challenge(game.player1_id, 'Art', 'Entertainment')
    game_challenge.update_attributes(challenger_correct: 6, opponent_correct: 1)
    game_challenge.set_winner
    game_challenge.save
    game.apply_challenge_results
    game.save
    assert_equal(true, game.entertainment_trophy_p1?)
  end

  test "create_challenge should_be_true_challenger_winner" do
    game = Game.new
    game.id = 1
    game.player1_id = 3
    game.player2_id = 4
    game.art_trophy_p1 = true
    game.entertainment_trophy_p2 = true
    game.save
    game_challenge = game.create_challenge(game.player1_id, 'Art', 'Entertainment')
    game_challenge.update_attributes(challenger_correct: 2, opponent_correct: 1)
    game_challenge.set_winner
    game_challenge.save
    result = game.apply_challenge_results
    game.save
    assert_equal(true, result)
  end

  test "create_challenge should_be_true_opponent_winner" do
    game = Game.new
    game.id = 1
    game.player1_id = 3
    game.player2_id = 4
    game.art_trophy_p1 = true
    game.entertainment_trophy_p2 = true
    game.save
    game_challenge = game.create_challenge(game.player1_id, 'Art', 'Entertainment')
    game_challenge.update_attributes(challenger_correct: 0, opponent_correct: 1)
    game_challenge.set_winner
    game_challenge.save
    result = game.apply_challenge_results
    game.save
    assert_equal(true, result)
  end

  ################ TESTING normal_round? ################

  test "normal_round? should_be_true_no_challenge" do
    game = Game.new
    game.player1_id = BILL_ID
    game.player2_id = DAVID_ID
    3.times {game.apply_to_normal_round(Subject::ART, DAVID_ID, Question::CORRECT)}
    assert_equal(true, game.normal_round?)
  end

  test "normal_round? should_be_false_yes_challenge" do
    game = Game.new
    game.player1_id = BILL_ID
    game.player2_id = DAVID_ID
    3.times {game.apply_to_normal_round(Subject::ART, DAVID_ID, Question::CORRECT)}
    game.challenge = Challenge::YES
    assert_equal(false, game.normal_round?)
  end

  ################ TESTING bonus? IN NORMAL ROUND ################

  test "bonus? should_be_false_four_correct" do
    game = Game.new
    game.player1_id = BILL_ID
    game.player2_id = DAVID_ID
    game.save
    4.times {game.apply_to_normal_round(Subject::ART, BILL_ID, Question::CORRECT)}
    assert_equal(false, game.bonus?)
  end

  ################ TESTING apply_to_normal_round ################

  test "apply_to_normal_round answers_correct_should_be_1" do
    game = Game.new
    game.player1_id = BILL_ID
    game.player2_id = DAVID_ID
    game.save
    game.apply_to_normal_round(Subject::ART, BILL_ID, Question::CORRECT)
    assert_equal(1, game.answers_correct)
  end

  test "apply_to_normal_round answers_correct_should_be_2" do
    game = Game.new
    game.player1_id = BILL_ID
    game.player2_id = DAVID_ID
    game.save
    2.times {game.apply_to_normal_round(Subject::ART, BILL_ID, Question::CORRECT)}
    assert_equal(2, game.answers_correct)
  end

  test "apply_to_normal_round answers_correct_should_be_3" do
    game = Game.new
    game.player1_id = BILL_ID
    game.player2_id = DAVID_ID
    game.save
    3.times {game.apply_to_normal_round(Subject::ART, BILL_ID, Question::CORRECT)}
    assert_equal(3, game.answers_correct)
  end

  test "apply_to_normal_round should_be_false_no_bonus_one_correct" do
    game = Game.new
    game.player1_id = BILL_ID
    game.player2_id = DAVID_ID
    game.save
    game.apply_to_normal_round(Subject::ART, BILL_ID, Question::CORRECT)
    assert_equal(false, game.bonus?)
  end

  test "apply_to_normal_round should_be_false_no_bonus_two_correct" do
    game = Game.new
    game.player1_id = BILL_ID
    game.player2_id = DAVID_ID
    game.save
    2.times {game.apply_to_normal_round(Subject::ART, BILL_ID, Question::CORRECT)}
    assert_equal(false, game.bonus?)
  end

  test "apply_to_normal_round should_be_false_bonus_four_correct" do
    game = Game.new
    game.player1_id = BILL_ID
    game.player2_id = DAVID_ID
    game.answers_correct = 3
    game.save
    game.apply_to_normal_round(Subject::ART, BILL_ID, Question::CORRECT)
    assert_equal(false, game.bonus?)
  end

  test "apply_to_normal_round should_be_false_round_end_player2_turn" do
    game = Game.new
    game.player1_id = BILL_ID
    game.player2_id = DAVID_ID
    game.answers_correct = 1
    game.save
    game.apply_to_normal_round(Subject::ART, BILL_ID, Question::INCORRECT)
    game.save
    assert_equal(false, game.players_turn?(BILL_ID))
  end

  test "apply_to_normal_round should_be_true_round_end_player2_turn" do
    game = Game.new
    game.player1_id = BILL_ID
    game.player2_id = DAVID_ID
    game.answers_correct = 1
    game.save
    game.apply_to_normal_round(Subject::ART, BILL_ID, Question::INCORRECT)
    game.save
    assert_equal(true, game.players_turn?(DAVID_ID))
  end

  test "apply_to_normal_round should_be_true_art_trophy_p1?" do
    game = Game.new
    game.player1_id = BILL_ID
    game.player2_id = DAVID_ID
    4.times {game.apply_to_normal_round(Subject::ART, BILL_ID, Question::CORRECT)}
    assert_equal(true, game.art_trophy_p1?)
  end

  test "apply_to_normal_round should_be_true_art_trophy_p2?" do
    game = Game.new
    game.player1_id = BILL_ID
    game.player2_id = DAVID_ID
    4.times {game.apply_to_normal_round(Subject::ART, DAVID_ID, Question::CORRECT)}
    assert_equal(true, game.art_trophy_p2?)
  end

  test "apply_to_normal_round should_be_true_answers_correct_is_zero_bonus_set_before" do
    game = Game.new
    game.player1_id = BILL_ID
    game.player2_id = DAVID_ID
    game.bonus = Game::TRUE
    game.save
    1.times {game.apply_to_normal_round(Subject::ART, DAVID_ID, Question::CORRECT)}
    assert_equal(0, game.answers_correct)
  end

  test "apply_to_normal_round should_be_true_player_has_trophy_bonus_set_before" do
    game = Game.new
    game.player1_id = BILL_ID
    game.player2_id = DAVID_ID
    game.bonus = Game::TRUE
    game.save
    1.times {game.apply_to_normal_round(Subject::ART, BILL_ID, Question::CORRECT)}
    assert_equal(true, game.art_trophy_p1?)
  end

  test "apply_to_normal_round should_be_false_player1_has_trophy_not_p2_bonus_set_before" do
    game = Game.new
    game.player1_id = BILL_ID
    game.player2_id = DAVID_ID
    game.bonus = Game::TRUE
    game.save
    1.times {game.apply_to_normal_round(Subject::ART, BILL_ID, Question::CORRECT)}
    assert_equal(false, game.art_trophy_p2?)
  end

  test "apply_to_normal_round should_be_true_player1_winner" do
    game = Game.new
    game.player1_id = BILL_ID
    game.player2_id = DAVID_ID
    game.entertainment_trophy_p1 = true
    game.history_trophy_p1 = true
    game.geography_trophy_p1 = true
    game.science_trophy_p1 = true
    game.sports_trophy_p1 = true
    game.save
    4.times {game.apply_to_normal_round(Subject::ART, BILL_ID, Question::CORRECT)}
    assert_equal(true, game.game_over?)
  end

  ################ TESTING apply_to_challenge_round ################
end
