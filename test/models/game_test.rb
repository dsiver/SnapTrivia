require 'test_helper'

# noinspection RubyResolve
class GameTest < ActiveSupport::TestCase
  BILL_ID = 2
  DAVID_ID = 3
  DOUG_ID = 4
  
  test "small_template" do
    game = Game.new
    game.player1_id = BILL_ID
    game.player2_id = DOUG_ID
    game.save
    assert_equal(true, true)
  end

  test "full_template" do
    game = Game.new
    game.player1_id = BILL_ID
    game.player2_id = DOUG_ID
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

  ################################ active? ################################

  test "active? should_be_true_new_game" do
    game = Game.new
    game.player1_id = BILL_ID
    game.player2_id = DOUG_ID
    game.save
    assert_equal(true, game.active?)
  end

  test "active? should_be_false_game_over" do
    game = Game.new
    game.player1_id = BILL_ID
    game.player2_id = DOUG_ID
    game.save
    game.game_status = Game::GAME_OVER
    assert_equal(false, game.active?)
  end

  ################################ finished? ################################

  test "finished? should_be_false_new_game" do
    game = Game.new
    game.player1_id = BILL_ID
    game.player2_id = DOUG_ID
    game.save
    assert_equal(false, game.finished?)
  end

  test "finished? should_be_true_game_over" do
    game = Game.new
    game.player1_id = BILL_ID
    game.player2_id = DOUG_ID
    game.save
    game.game_status = Game::GAME_OVER
    assert_equal(true, game.finished?)
  end

  ################################ player1_trophies ################################

  test "player1_trophies should_return_art" do
    game = Game.new
    game.player1_id = BILL_ID
    game.player2_id = DOUG_ID
    game.art_trophy_p1 = true
    game.save
    trophies = [Subject::ART]
    assert_equal(trophies, game.player1_trophies)
  end

  test "player1_trophies should_return_all" do
    game = Game.new
    game.player1_id = BILL_ID
    game.player2_id = DOUG_ID
    game.art_trophy_p1 = true
    game.entertainment_trophy_p1 = true
    game.history_trophy_p1 = true
    game.geography_trophy_p1 = true
    game.science_trophy_p1 = true
    game.sports_trophy_p1 = true
    game.save
    trophies = [Subject::ART, Subject::ENTERTAINMENT, Subject::HISTORY, Subject::GEOGRAPHY, Subject::SCIENCE, Subject::SPORTS]
    assert_equal(trophies, game.player1_trophies)
  end

  ################################ player2_trophies ################################

  test "player2_trophies should_return_art" do
    game = Game.new
    game.player1_id = BILL_ID
    game.player2_id = DOUG_ID
    game.art_trophy_p2 = true
    game.save
    trophies = [Subject::ART]
    assert_equal(trophies, game.player2_trophies)
  end

  test "player2_trophies should_return_all" do
    game = Game.new
    game.player1_id = BILL_ID
    game.player2_id = DOUG_ID
    game.art_trophy_p2 = true
    game.entertainment_trophy_p2 = true
    game.history_trophy_p2 = true
    game.geography_trophy_p2 = true
    game.science_trophy_p2 = true
    game.sports_trophy_p2 = true
    game.save
    trophies = [Subject::ART, Subject::ENTERTAINMENT, Subject::HISTORY, Subject::GEOGRAPHY, Subject::SCIENCE, Subject::SPORTS]
    assert_equal(trophies, game.player2_trophies)
  end

  ################################ get_available_trophies ################################

  test "get_available_trophies should_return_all_but_art_p1" do
    game = Game.new
    game.player1_id = BILL_ID
    game.player2_id = DOUG_ID
    game.art_trophy_p1 = true
    game.save
    trophies = [Subject::ENTERTAINMENT, Subject::HISTORY, Subject::GEOGRAPHY, Subject::SCIENCE, Subject::SPORTS]
    assert_equal(trophies, game.get_available_trophies(game.player1_id))
  end

  test "get_available_trophies should_return_sports_p1" do
    game = Game.new
    game.player1_id = BILL_ID
    game.player2_id = DOUG_ID
    game.art_trophy_p1 = true
    game.entertainment_trophy_p1 = true
    game.history_trophy_p1 = true
    game.geography_trophy_p1 = true
    game.science_trophy_p1 = true
    game.save
    trophies = [Subject::SPORTS]
    assert_equal(trophies, game.get_available_trophies(game.player1_id))
  end

  test "get_available_trophies should_return_empty_p1" do
    game = Game.new
    game.player1_id = BILL_ID
    game.player2_id = DOUG_ID
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
    trophies = []
    assert_equal(trophies, game.get_available_trophies(game.player1_id))
  end

  test "get_available_trophies should_return_all_but_art_p2" do
    game = Game.new
    game.player1_id = BILL_ID
    game.player2_id = DOUG_ID
    game.art_trophy_p2 = true
    game.save
    trophies = [Subject::ENTERTAINMENT, Subject::HISTORY, Subject::GEOGRAPHY, Subject::SCIENCE, Subject::SPORTS]
    assert_equal(trophies, game.get_available_trophies(game.player2_id))
  end

  test "get_available_trophies should_return_sports_p2" do
    game = Game.new
    game.player1_id = BILL_ID
    game.player2_id = DOUG_ID
    game.art_trophy_p2 = true
    game.entertainment_trophy_p2 = true
    game.history_trophy_p2 = true
    game.geography_trophy_p2 = true
    game.science_trophy_p2 = true
    game.save
    trophies = [Subject::SPORTS]
    assert_equal(trophies, game.get_available_trophies(game.player2_id))
  end

  test "get_available_trophies should_return_empty_p2" do
    game = Game.new
    game.player1_id = BILL_ID
    game.player2_id = DOUG_ID
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
    trophies = []
    assert_equal(trophies, game.get_available_trophies(game.player2_id))
  end

  ################################ get_winnable_trophies ################################

  test "get_winnable_trophies should_be_art_p1_challenger" do
    expected_winnable = ["Sports"]
    game = Game.new
    game.player1_id = BILL_ID
    game.player2_id = DOUG_ID
    game.art_trophy_p1 = true
    game.entertainment_trophy_p1 = true
    game.entertainment_trophy_p2 = true
    game.sports_trophy_p2 = true
    game.save
    challenger_id = game.player1_id
    assert_equal(expected_winnable, game.get_winnable_trophies(challenger_id))
  end

  test "get_winnable_trophies should_be_geo_sci_sports_p1_challenger" do
    expected_winnable = %w(Geography Science Sports)
    game = Game.new
    game.player1_id = BILL_ID
    game.player2_id = DOUG_ID
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
    expected_winnable = %w(Science Sports)
    game = Game.new
    game.player1_id = BILL_ID
    game.player2_id = DOUG_ID
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
    expected_winnable = []
    game = Game.new
    game.player1_id = BILL_ID
    game.player2_id = DOUG_ID
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
    assert_equal(expected_winnable, expected_winnable)
  end

  ################################ get_wagerable_trophies ################################


  test "get_wagerable_trophies should_be_art_p1_challenger" do
    expected_wagerable = ["Art"]
    game = Game.new
    game.player1_id = BILL_ID
    game.player2_id = DOUG_ID
    game.art_trophy_p1 = true
    game.entertainment_trophy_p1 = true
    game.entertainment_trophy_p2 = true
    game.sports_trophy_p2 = true
    game.save
    challenger_id = game.player1_id
    assert_equal(expected_wagerable, game.get_wagerable_trophies(challenger_id))
  end

  test "get_wagerable_trophies should_be_art_ent_hist_p1_challenger" do
    expected_wagerable = %w(Art Entertainment History)
    game = Game.new
    game.player1_id = BILL_ID
    game.player2_id = DOUG_ID
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
    expected_wagerable = %w(Art Entertainment)
    game = Game.new
    game.player1_id = BILL_ID
    game.player2_id = DOUG_ID
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

  ################################ end_round ################################

  test "end_round_should_end_p1_turn" do
    game = Game.new
    game.player1_id = BILL_ID
    game.player2_id = DOUG_ID
    game.end_round(game.player1_id)
    assert_equal(false, game.player1_turn?)
  end

  test "end_round_should_end_p2_turn" do
    game = Game.new
    game.player1_id = BILL_ID
    game.player2_id = DOUG_ID
    game.player1_turn = false
    game.end_round(game.player2_id)
    assert_equal(true, game.player1_turn?)
  end

  ################################ end_game ################################

  test "end_game should_set_game_status_to_game_over" do
    game = Game.new
    game.player1_id = BILL_ID
    game.player2_id = DOUG_ID
    game.save
    game.end_game(BILL_ID)
    assert_equal(Game::GAME_OVER, game.game_status)
  end

  test "end_game should_set_winner_id_to_BILL_ID" do
    game = Game.new
    game.player1_id = BILL_ID
    game.player2_id = DOUG_ID
    game.save
    game.end_game(BILL_ID)
    assert_equal(BILL_ID, game.winner_id)
  end

  test "end_game should_set_winner_id_to_DOUG_ID" do
    game = Game.new
    game.player1_id = BILL_ID
    game.player2_id = DOUG_ID
    game.save
    game.end_game(DOUG_ID)
    assert_equal(DOUG_ID, game.winner_id)
  end

  ################################ can_challenge? ################################

  test "can_challenge? should_be_false_no_trophies" do
    game = Game.new
    game.player1_id = BILL_ID
    game.player2_id = DOUG_ID
    game.save
    assert_equal(false, game.can_challenge?)
  end

  test "can_challenge? should_be_false_challenger_p1_has_1_defender_none" do
    game = Game.new
    game.player1_id = BILL_ID
    game.player2_id = DOUG_ID
    game.art_trophy_p1 = true
    game.save
    assert_equal(false, game.can_challenge?)
  end

  test "can_challenge? should_be_false_challenger_p2_has_1_defender_none" do
    game = Game.new
    game.player1_id = BILL_ID
    game.player2_id = DOUG_ID
    game.art_trophy_p2 = true
    game.save
    assert_equal(false, game.can_challenge?)
  end

  test "can_challenge? should_be_false_same trophies" do
    game = Game.new
    game.player1_id = BILL_ID
    game.player2_id = DOUG_ID
    game.art_trophy_p1 = true
    game.art_trophy_p2 = true
    game.save
    assert_equal(false, game.can_challenge?)
  end

  test "can_challenge? should_be_true_different trophies" do
    game = Game.new
    game.player1_id = BILL_ID
    game.player2_id = DOUG_ID
    game.art_trophy_p1 = true
    game.entertainment_trophy_p2 = true
    game.save
    assert_equal(true, game.can_challenge?)
  end

  test "can_challenge? should_be_false_challenger_p1_has_2_defender_has_1_common" do
    game = Game.new
    game.player1_id = BILL_ID
    game.player2_id = DOUG_ID
    game.art_trophy_p1 = true
    game.entertainment_trophy_p1 = true
    game.entertainment_trophy_p2 = true
    game.save
    assert_equal(false, game.can_challenge?)
  end

  test "can_challenge? should_be_false_all trophies_in_common" do
    game = Game.new
    game.player1_id = BILL_ID
    game.player2_id = DOUG_ID
    game.art_trophy_p1 = true
    game.entertainment_trophy_p1 = true
    game.art_trophy_p2 = true
    game.entertainment_trophy_p2 = true
    game.save
    assert_equal(false, game.can_challenge?)
  end

  test "can_challenge? should_be_false_challenger_p1_nothing_to_win" do
    game = Game.new
    game.player1_id = BILL_ID
    game.player2_id = DOUG_ID
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
    game.player1_id = BILL_ID
    game.player2_id = DOUG_ID
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
    game.player1_id = BILL_ID
    game.player2_id = DOUG_ID
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
    game.player1_id = BILL_ID
    game.player2_id = DOUG_ID
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
    game.player1_id = BILL_ID
    game.player2_id = DOUG_ID
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
    game.player1_id = BILL_ID
    game.player2_id = DOUG_ID
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
    game.player1_id = BILL_ID
    game.player2_id = DOUG_ID
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
    game.player1_id = BILL_ID
    game.player2_id = DOUG_ID
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
    game.player1_id = BILL_ID
    game.player2_id = DOUG_ID
    game.art_trophy_p1 = true
    game.entertainment_trophy_p1 = true
    game.art_trophy_p2 = true
    game.sports_trophy_p2 = true
    game.save
    assert_equal(true, game.can_challenge?)
  end

  test "can_challenge? should_be_true_one_left_common_2" do
    game = Game.new
    game.player1_id = BILL_ID
    game.player2_id = DOUG_ID
    game.art_trophy_p1 = true
    game.sports_trophy_p1 = true
    game.art_trophy_p2 = true
    game.entertainment_trophy_p2 = true
    game.save
    assert_equal(true, game.can_challenge?)
  end

  test "can_challenge? should_be_true_one_left_common_3" do
    game = Game.new
    game.player1_id = BILL_ID
    game.player2_id = DOUG_ID
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
    game.player1_id = BILL_ID
    game.player2_id = DOUG_ID
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
    game.player1_id = BILL_ID
    game.player2_id = DOUG_ID
    game.art_trophy_p1 = true
    game.entertainment_trophy_p1 = true
    game.history_trophy_p1 = true
    game.art_trophy_p2 = true
    game.entertainment_trophy_p2 = true
    game.history_trophy_p2 = true
    game.save
    assert_equal(false, game.can_challenge?)
  end

  ################################ player_has_all_trophies? ################################

  test "player_has_all_trophies? should_be_true_p1_all" do
    game = Game.new
    game.player1_id = BILL_ID
    game.player2_id = DOUG_ID
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
    assert_equal(true, game.player_has_all_trophies?(game.player1_id))
  end

  test "player_has_all_trophies? should_be_false_p1_one_shy" do
    game = Game.new
    game.player1_id = BILL_ID
    game.player2_id = DOUG_ID
    game.art_trophy_p1 = true
    game.entertainment_trophy_p1 = true
    game.history_trophy_p1 = true
    game.geography_trophy_p1 = true
    game.science_trophy_p1 = true
    game.art_trophy_p2 = true
    game.entertainment_trophy_p2 = true
    game.history_trophy_p2 = true
    game.save
    assert_equal(false, game.player_has_all_trophies?(game.player1_id))
  end

  test "player_has_all_trophies? should_be_true_p2_all" do
    game = Game.new
    game.player1_id = BILL_ID
    game.player2_id = DOUG_ID
    game.art_trophy_p2 = true
    game.entertainment_trophy_p2 = true
    game.history_trophy_p2 = true
    game.geography_trophy_p2 = true
    game.science_trophy_p2 = true
    game.sports_trophy_p2 = true
    game.save
    assert_equal(true, game.player_has_all_trophies?(game.player2_id))
  end

  ################################ give_trophy ################################

  test "give_trophy answers_correct_reset" do
    game = Game.new
    game.player1_id = BILL_ID
    game.player2_id = DOUG_ID
    game.answers_correct = 3
    game.save
    game.give_trophy(Subject::ART, DAVID_ID)
    game.save
    assert_equal(0, game.answers_correct)
  end

  test "give_trophy should_be_true_p1_art" do
    game = Game.new
    game.player1_id = BILL_ID
    game.player2_id = DOUG_ID
    game.give_trophy(Subject::ART, game.player1_id)
    game.save
    assert_equal(true, game.art_trophy_p1?)
  end

  test "give_trophy should_be_true_p2_art" do
    game = Game.new
    game.player1_id = BILL_ID
    game.player2_id = DOUG_ID
    game.give_trophy(Subject::ART, game.player2_id)
    game.save
    assert_equal(true, game.art_trophy_p2?)
  end

  ################################ take_trophy ################################

  test "take_trophy game_art_trophy_p1?_should_be_false_p1_art" do
    game = Game.new
    game.player1_id = BILL_ID
    game.player2_id = DOUG_ID
    game.art_trophy_p1 = true
    game.save
    game.take_trophy(Subject::ART, game.player1_id)
    game.save
    assert_equal(false, game.art_trophy_p1?)
  end

  test "take_trophy should_be_false_p2_art" do
    game = Game.new
    game.player1_id = BILL_ID
    game.player2_id = DOUG_ID
    game.art_trophy_p2 = true
    game.save
    game.take_trophy(Subject::ART, game.player2_id)
    game.save
    assert_equal(false, game.art_trophy_p2?)
  end

  ################################ normal_round? ################################

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
    game.challenge = Challenge::CHALLENGE_YES
    assert_equal(false, game.normal_round?)
  end

  ################################ bonus? IN NORMAL ROUND ################################

  test "bonus? should_be_false_one_correct" do
    game = Game.new
    game.player1_id = BILL_ID
    game.player2_id = DAVID_ID
    game.save
    1.times {game.apply_to_normal_round(Subject::ART, BILL_ID, Question::CORRECT)}
    assert_equal(false, game.bonus?)
  end

  test "bonus? should_be_false_two_correct" do
    game = Game.new
    game.player1_id = BILL_ID
    game.player2_id = DAVID_ID
    game.save
    2.times {game.apply_to_normal_round(Subject::ART, BILL_ID, Question::CORRECT)}
    assert_equal(false, game.bonus?)
  end

  test "bonus? should_be_true_three_correct" do
    game = Game.new
    game.player1_id = BILL_ID
    game.player2_id = DAVID_ID
    game.save
    3.times {game.apply_to_normal_round(Subject::ART, BILL_ID, Question::CORRECT)}
    assert_equal(true, game.bonus?)
  end

  test "bonus? should_be_false_four_correct" do
    game = Game.new
    game.player1_id = BILL_ID
    game.player2_id = DAVID_ID
    game.save
    4.times {game.apply_to_normal_round(Subject::ART, BILL_ID, Question::CORRECT)}
    assert_equal(false, game.bonus?)
  end

  ################################ apply_to_normal_round ################################

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
    game.bonus = Game::BONUS_TRUE
    game.save
    1.times {game.apply_to_normal_round(Subject::ART, DAVID_ID, Question::CORRECT)}
    assert_equal(0, game.answers_correct)
  end

  test "apply_to_normal_round should_be_true_player_has_trophy_bonus_set_before" do
    game = Game.new
    game.player1_id = BILL_ID
    game.player2_id = DAVID_ID
    game.bonus = Game::BONUS_TRUE
    game.save
    1.times {game.apply_to_normal_round(Subject::ART, BILL_ID, Question::CORRECT)}
    assert_equal(true, game.art_trophy_p1?)
  end

  test "apply_to_normal_round should_be_false_player1_has_trophy_not_p2_bonus_set_before" do
    game = Game.new
    game.player1_id = BILL_ID
    game.player2_id = DAVID_ID
    game.bonus = Game::BONUS_TRUE
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

  ################################ apply_challenge_results ################################
  
  test "apply_challenge_results should_be_true_challenger_wins_has_opponent_trophy" do
    # Challenger is Bill
    # Opponent is Doug
    game = Game.new
    game.player1_id = BILL_ID
    game.player2_id = DOUG_ID
    game.art_trophy_p1 = true
    game.entertainment_trophy_p2 = true
    game.save
    game.apply_challenge_results(Challenge::RESULT_WINNER, BILL_ID, Subject::ART, Subject::ENTERTAINMENT)
    assert_equal(true, game.entertainment_trophy_p1?)
  end

  test "apply_challenge_results should_be_false_challenger_wins_opponent_lost_trophy" do
    # Challenger is Bill
    # Opponent is Doug
    game = Game.new
    game.player1_id = BILL_ID
    game.player2_id = DOUG_ID
    game.art_trophy_p1 = true
    game.entertainment_trophy_p2 = true
    game.save
    game.apply_challenge_results(Challenge::RESULT_WINNER, BILL_ID, Subject::ART, Subject::ENTERTAINMENT)
    assert_equal(false, game.entertainment_trophy_p2?)
  end

  test "apply_challenge_results should_be_true_opponent_wins_has_challenger_trophy" do
    # Challenger is Bill
    # Opponent is Doug
    game = Game.new
    game.player1_id = BILL_ID
    game.player2_id = DOUG_ID
    game.art_trophy_p1 = true
    game.entertainment_trophy_p2 = true
    game.save
    game.apply_challenge_results(Challenge::RESULT_WINNER, DOUG_ID, Subject::ART, Subject::ENTERTAINMENT)
    assert_equal(true, game.art_trophy_p2?)
  end

  test "apply_challenge_results should_be_false_opponent_wins_challenger_lost_trophy" do
    # Challenger is Bill
    # Opponent is Doug
    game = Game.new
    game.player1_id = BILL_ID
    game.player2_id = DOUG_ID
    game.art_trophy_p1 = true
    game.entertainment_trophy_p2 = true
    game.save
    game.apply_challenge_results(Challenge::RESULT_WINNER, DOUG_ID, Subject::ART, Subject::ENTERTAINMENT)
    assert_equal(false, game.art_trophy_p1?)
  end

  test "apply_challenge_results should_be_true_result_tie_challenger_still_has_trophy" do
    # Challenger is Bill
    # Opponent is Doug
    game = Game.new
    game.player1_id = BILL_ID
    game.player2_id = DOUG_ID
    game.art_trophy_p1 = true
    game.entertainment_trophy_p2 = true
    game.save
    game.apply_challenge_results(Challenge::RESULT_TIE, Challenge::DEFAULT_WINNER_ID, Subject::ART, Subject::ENTERTAINMENT)
    assert_equal(true, game.art_trophy_p1?)
  end

  test "apply_challenge_results should_be_true_result_tie_opponent_still_has_trophy" do
    # Challenger is Bill
    # Opponent is Doug
    game = Game.new
    game.player1_id = BILL_ID
    game.player2_id = DOUG_ID
    game.art_trophy_p1 = true
    game.entertainment_trophy_p2 = true
    game.save
    game.apply_challenge_results(Challenge::RESULT_TIE, Challenge::DEFAULT_WINNER_ID, Subject::ART, Subject::ENTERTAINMENT)
    assert_equal(true, game.entertainment_trophy_p2?)
  end

  ################################ set_challenge ################################

  test "set_challenge should_return_true_no_ongoing_challenge" do
    # Challenger is Bill
    # Opponent is Doug
    game = Game.new
    game.player1_id = BILL_ID
    game.player2_id = DOUG_ID
    game.art_trophy_p1 = true
    game.entertainment_trophy_p2 = true
    game.save
    assert_equal(true, game.set_challenge)
  end

  test "set_challenge should_return_false_ongoing_challenge" do
    # Challenger is Bill
    # Opponent is Doug
    game = Game.new
    game.player1_id = BILL_ID
    game.player2_id = DOUG_ID
    game.art_trophy_p1 = true
    game.entertainment_trophy_p2 = true
    game.save
    challenge = Challenge.new(game_id: game.id, challenger_id: BILL_ID, opponent_id: DOUG_ID, wager: Subject::ART, prize: Subject::ENTERTAINMENT,
                              winner_id: 0, challenger_correct: 0, opponent_correct: 0)
    challenge.save
    assert_not_equal(nil, challenge)
    assert_equal(false, game.set_challenge)
  end

  test "set_challenge should_return_false_1_ongoing_challenge_1_finished_challenge" do
    # Challenger is Bill
    # Opponent is Doug
    game = Game.new
    game.player1_id = BILL_ID
    game.player2_id = DOUG_ID
    game.art_trophy_p1 = true
    game.entertainment_trophy_p2 = true
    game.save
    challenges = []
    2.times {
      c = Challenge.new
      challenges << c
    }
    (0..1).each { |i|
      if i == 0
        challenges[i].update_attributes(game_id: game.id, challenger_id: BILL_ID, opponent_id: DOUG_ID, wager: Subject::ART, prize: Subject::ENTERTAINMENT,
                                        winner_id: 0, challenger_correct: 0, opponent_correct: 0)
      else
        challenges[i].update_attributes(game_id: game.id, challenger_id: BILL_ID, opponent_id: DOUG_ID, wager: Subject::ART, prize: Subject::ENTERTAINMENT,
                                        winner_id: BILL_ID, challenger_correct: 0, opponent_correct: 0)
      end
    }
    assert_equal(false, game.set_challenge)
  end

  test "set_challenge should_return_true_no_ongoing_challenge_2_finished_challenges" do
    # Challenger is Bill
    # Opponent is Doug
    game = Game.new
    game.player1_id = BILL_ID
    game.player2_id = DOUG_ID
    game.art_trophy_p1 = true
    game.entertainment_trophy_p2 = true
    game.save
    challenges = []
    2.times {
      c = Challenge.new
      challenges << c
    }
    (0..1).each { |i|
        challenges[i].update_attributes(game_id: game.id, challenger_id: BILL_ID, opponent_id: DOUG_ID, wager: Subject::ART, prize: Subject::ENTERTAINMENT,
                                        winner_id: BILL_ID, challenger_correct: 0, opponent_correct: 0)
    }
    assert_equal(true, game.set_challenge)
  end

  test "set_challenge game_challenge_attribute_should_be_challenge::challenge_yes" do
    # Challenger is Bill
    # Opponent is Doug
    game = Game.new
    game.player1_id = BILL_ID
    game.player2_id = DOUG_ID
    game.art_trophy_p1 = true
    game.entertainment_trophy_p2 = true
    game.save
    game.set_challenge
    assert_equal(Challenge::CHALLENGE_YES, game.challenge)
  end

  test "set_challenge game_challenge_attribute_should_be_challenge::challenge_no_ongoing_challenge" do
    # Challenger is Bill
    # Opponent is Doug
    game = Game.new
    game.player1_id = BILL_ID
    game.player2_id = DOUG_ID
    game.art_trophy_p1 = true
    game.entertainment_trophy_p2 = true
    game.save
    challenge = Challenge.new(game_id: game.id, challenger_id: BILL_ID, opponent_id: DOUG_ID, wager: Subject::ART, prize: Subject::ENTERTAINMENT,
                              winner_id: 0, challenger_correct: 0, opponent_correct: 0)
    challenge.save
    assert_not_equal(nil, challenge)
    game.set_challenge
    assert_equal(Challenge::CHALLENGE_NO, game.challenge)
  end

  ################################ max_turns? ################################

  test "max_turns? should_return_false_new_game" do
    game = Game.new
    game.player1_id = BILL_ID
    game.player2_id = DOUG_ID
    game.save
    assert_not(game.max_turns?)
  end

  test "max_turns? should_return_false_24_turns" do
    game = Game.new
    game.player1_id = BILL_ID
    game.player2_id = DOUG_ID
    game.turn_count = 24
    game.save
    assert_not(game.max_turns?)
  end

  test "max_turns? should_return_true_25_turns" do
    game = Game.new
    game.player1_id = BILL_ID
    game.player2_id = DOUG_ID
    game.turn_count = 25
    game.save
    assert(game.max_turns?)
  end

  ################################ compare_trophy_count ################################

  ######## raises error ########

  test "compare_trophy_count should_raise_error_turn_count_less_than_MAXIMUM_TURNS" do
    game = Game.new
    game.player1_id = BILL_ID
    game.player2_id = DOUG_ID
    game.save
    assert_raises(RuntimeError){game.compare_trophy_count}
  end

  test "compare_trophy_count should_raise_error_turn_count_greater_than_MAXIMUM_TURNS" do
    game = Game.new
    game.player1_id = BILL_ID
    game.player2_id = DOUG_ID
    game.turn_count = 26
    game.save
    assert_raises(RuntimeError){game.compare_trophy_count}
  end

  ######## checking game_status ########

  test "compare_trophy_count game_status_should_be_GAME_OVER_player1_winner" do
    game = Game.new
    game.player1_id = BILL_ID
    game.player2_id = DOUG_ID
    game.art_trophy_p1 = true
    game.turn_count = Game::MAXIMUM_TURNS
    game.save
    game.compare_trophy_count
    assert_equal(Game::GAME_OVER, game.game_status)
  end

  test "compare_trophy_count game_status_should_be_GAME_OVER_player2_winner" do
    game = Game.new
    game.player1_id = BILL_ID
    game.player2_id = DOUG_ID
    game.entertainment_trophy_p2 = true
    game.turn_count = Game::MAXIMUM_TURNS
    game.save
    game.compare_trophy_count
    assert_equal(Game::GAME_OVER, game.game_status)
  end

  test "compare_trophy_count game_status_should_be_ACTIVE_tie" do
    game = Game.new
    game.player1_id = BILL_ID
    game.player2_id = DOUG_ID
    game.art_trophy_p1 = true
    game.entertainment_trophy_p2 = true
    game.turn_count = Game::MAXIMUM_TURNS
    game.save
    game.compare_trophy_count
    assert_equal(Game::ACTIVE, game.game_status)
  end

  ######## checking winner_id ########

  test "compare_trophy_count winner_id_should_be_player1" do
    game = Game.new
    game.player1_id = BILL_ID
    game.player2_id = DOUG_ID
    game.art_trophy_p1 = true
    game.turn_count = Game::MAXIMUM_TURNS
    game.save
    game.compare_trophy_count
    assert_equal(game.player1_id, game.winner_id)
  end

  test "compare_trophy_count winner_id_should_be_player2" do
    game = Game.new
    game.player1_id = BILL_ID
    game.player2_id = DOUG_ID
    game.entertainment_trophy_p2 = true
    game.turn_count = Game::MAXIMUM_TURNS
    game.save
    game.compare_trophy_count
    assert_equal(game.player2_id, game.winner_id)
  end

  test "compare_trophy_count winner_id_should_be_DEFAULT_WINNER_ID_tie" do
    game = Game.new
    game.player1_id = BILL_ID
    game.player2_id = DOUG_ID
    game.art_trophy_p1 = true
    game.entertainment_trophy_p2 = true
    game.turn_count = Game::MAXIMUM_TURNS
    game.save
    game.compare_trophy_count
    assert_equal(Game::DEFAULT_WINNER_ID, game.winner_id)
  end

  ######## checking challenge ########

end
