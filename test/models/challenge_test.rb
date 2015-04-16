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
    challenge.set_game_attributes(game.id, 3, 'Art', 'Entertainment')
    challenge.generate_question_ids
    challenge.save
    assert_not(nil, challenge)
  end

  test "create_challenge_with_params" do
    game = Game.new(id: 1, player1_id: 3, player2_id: 4, player1_turn: true, game_status: 'active',
                    art_trophy_p1: false, entertainment_trophy_p1: false, history_trophy_p1: false,
                    geography_trophy_p1: false, science_trophy_p1: false, sports_trophy_p1: false,
                    art_trophy_p2: false, entertainment_trophy_p2: false, history_trophy_p2: false,
                    geography_trophy_p2: false, science_trophy_p2: false, sports_trophy_p2: false)
    game.save
    challenge = Challenge.new(id: 1, game_id: 1, challenger_id: 3, opponent_id: 4, wager: 'Art', prize: 'Entertainment',
    winner_id: 0, challenger_correct: 0, opponent_correct: 0)
    challenge.generate_question_ids
    challenge.save
    assert_not(nil, challenge)
  end

  test "should_be_true_players_set" do
    game = Game.new(id: 1, player1_id: 3, player2_id: 4, player1_turn: true, game_status: 'active',
                    art_trophy_p1: false, entertainment_trophy_p1: false, history_trophy_p1: false,
                    geography_trophy_p1: false, science_trophy_p1: false, sports_trophy_p1: false,
                    art_trophy_p2: false, entertainment_trophy_p2: false, history_trophy_p2: false,
                    geography_trophy_p2: false, science_trophy_p2: false, sports_trophy_p2: false)
    game.save
    challenger = game.player1_id
    challenge = Challenge.new(challenger_correct: 0, opponent_correct: 0)
    challenge.set_game_attributes(game.id, challenger, 'Art', 'Entertainment')
    challenge.generate_question_ids
    challenge.save
    expression = challenge.challenger_id == 3 && challenge.opponent_id == 4
    assert_equal(true, expression)
  end

  test "should_be_true_challenger_answers_correct_incremented" do
    game = Game.new(id: 1, player1_id: 3, player2_id: 4, player1_turn: true, game_status: 'active',
                    art_trophy_p1: false, entertainment_trophy_p1: false, history_trophy_p1: false,
                    geography_trophy_p1: false, science_trophy_p1: false, sports_trophy_p1: false,
                    art_trophy_p2: false, entertainment_trophy_p2: false, history_trophy_p2: false,
                    geography_trophy_p2: false, science_trophy_p2: false, sports_trophy_p2: false)
    game.save
    challenger = game.player1_id
    challenge = Challenge.new(challenger_correct: 0, opponent_correct: 0)
    challenge.set_game_attributes(game.id, challenger, 'Art', 'Entertainment')
    challenge.generate_question_ids
    challenge.add_correct_answer(challenger)
    challenge.save
    assert_equal(true, challenge.challenger_correct == 1)
  end

  test "should_be_true_opponent_answers_correct_incremented" do
    game = Game.new(id: 1, player1_id: 3, player2_id: 4, player1_turn: true, game_status: 'active',
                    art_trophy_p1: false, entertainment_trophy_p1: false, history_trophy_p1: false,
                    geography_trophy_p1: false, science_trophy_p1: false, sports_trophy_p1: false,
                    art_trophy_p2: false, entertainment_trophy_p2: false, history_trophy_p2: false,
                    geography_trophy_p2: false, science_trophy_p2: false, sports_trophy_p2: false)
    game.save
    challenger = game.player1_id
    opponent = game.player2_id
    challenge = Challenge.new(challenger_correct: 0, opponent_correct: 0)
    challenge.set_game_attributes(game.id, challenger, 'Art', 'Entertainment')
    challenge.generate_question_ids
    challenge.add_correct_answer(opponent)
    challenge.save
    assert_equal(true, challenge.opponent_correct == 1)
  end

  test "set_game_attributes should_be_true_challenger_is_p1" do
    game = Game.new(id: 1, player1_id: 3, player2_id: 4, player1_turn: true, game_status: 'active',
                    art_trophy_p1: false, entertainment_trophy_p1: false, history_trophy_p1: false,
                    geography_trophy_p1: false, science_trophy_p1: false, sports_trophy_p1: false,
                    art_trophy_p2: false, entertainment_trophy_p2: false, history_trophy_p2: false,
                    geography_trophy_p2: false, science_trophy_p2: false, sports_trophy_p2: false)
    game.save
    challenger = game.player1_id
    challenge = Challenge.new(challenger_correct: 0, opponent_correct: 0)
    challenge.set_game_attributes(game.id, challenger, 'Art', 'Entertainment')
    challenge.generate_question_ids
    challenge.save
    expression = challenge.challenger_id == game.player1_id
    assert_equal(true, expression)
  end

  test "set_game_attributes should_be_false_challenger_is_not_p1" do
    game = Game.new(id: 1, player1_id: 3, player2_id: 4, player1_turn: true, game_status: 'active',
                    art_trophy_p1: false, entertainment_trophy_p1: false, history_trophy_p1: false,
                    geography_trophy_p1: false, science_trophy_p1: false, sports_trophy_p1: false,
                    art_trophy_p2: false, entertainment_trophy_p2: false, history_trophy_p2: false,
                    geography_trophy_p2: false, science_trophy_p2: false, sports_trophy_p2: false)
    game.save
    challenger = game.player2_id
    challenge = Challenge.new(challenger_correct: 0, opponent_correct: 0)
    challenge.set_game_attributes(game.id, challenger, 'Art', 'Entertainment')
    challenge.generate_question_ids
    challenge.save
    expression = challenge.challenger_id == game.player1_id
    assert_equal(false, expression)
  end

  test "set_game_attributes should_be_true_challenger_is_p2" do
    game = Game.new(id: 1, player1_id: 3, player2_id: 4, player1_turn: true, game_status: 'active',
                    art_trophy_p1: false, entertainment_trophy_p1: false, history_trophy_p1: false,
                    geography_trophy_p1: false, science_trophy_p1: false, sports_trophy_p1: false,
                    art_trophy_p2: false, entertainment_trophy_p2: false, history_trophy_p2: false,
                    geography_trophy_p2: false, science_trophy_p2: false, sports_trophy_p2: false)
    game.save
    challenger = game.player2_id
    challenge = Challenge.new(challenger_correct: 0, opponent_correct: 0)
    challenge.set_game_attributes(game.id, challenger, 'Art', 'Entertainment')
    challenge.generate_question_ids
    challenge.save
    expression = challenge.challenger_id == game.player2_id
    assert_equal(true, expression)
  end

  test "set_game_attributes should_be_false_challenger_is_not_p2" do
    game = Game.new(id: 1, player1_id: 3, player2_id: 4, player1_turn: true, game_status: 'active',
                    art_trophy_p1: false, entertainment_trophy_p1: false, history_trophy_p1: false,
                    geography_trophy_p1: false, science_trophy_p1: false, sports_trophy_p1: false,
                    art_trophy_p2: false, entertainment_trophy_p2: false, history_trophy_p2: false,
                    geography_trophy_p2: false, science_trophy_p2: false, sports_trophy_p2: false)
    game.save
    challenger = game.player1_id
    challenge = Challenge.new(challenger_correct: 0, opponent_correct: 0)
    challenge.set_game_attributes(game.id, challenger, 'Art', 'Entertainment')
    challenge.generate_question_ids
    challenge.save
    expression = challenge.challenger_id == game.player2_id
    assert_equal(false, expression)
  end

  test "set_game_attributes should_be_true_opponent_is_p2" do
    game = Game.new(id: 1, player1_id: 3, player2_id: 4, player1_turn: true, game_status: 'active',
                    art_trophy_p1: false, entertainment_trophy_p1: false, history_trophy_p1: false,
                    geography_trophy_p1: false, science_trophy_p1: false, sports_trophy_p1: false,
                    art_trophy_p2: false, entertainment_trophy_p2: false, history_trophy_p2: false,
                    geography_trophy_p2: false, science_trophy_p2: false, sports_trophy_p2: false)
    game.save
    challenger = game.player1_id
    challenge = Challenge.new(challenger_correct: 0, opponent_correct: 0)
    challenge.set_game_attributes(game.id, challenger, 'Art', 'Entertainment')
    challenge.generate_question_ids
    challenge.save
    assert_equal(game.player2_id, challenge.opponent_id)
  end

  test "set_game_attributes opponent_id_should_be_game_player2_id" do
    game = Game.new(id: 1, player1_id: 3, player2_id: 4, player1_turn: true, game_status: 'active',
                    art_trophy_p1: false, entertainment_trophy_p1: false, history_trophy_p1: false,
                    geography_trophy_p1: false, science_trophy_p1: false, sports_trophy_p1: false,
                    art_trophy_p2: false, entertainment_trophy_p2: false, history_trophy_p2: false,
                    geography_trophy_p2: false, science_trophy_p2: false, sports_trophy_p2: false)
    game.save
    challenger = game.player1_id
    challenge = Challenge.new(challenger_correct: 0, opponent_correct: 0)
    challenge.set_game_attributes(game.id, challenger, 'Art', 'Entertainment')
    challenge.generate_question_ids
    challenge.save
    assert_equal(challenge.opponent_id, game.player2_id)
  end

  test "set_game_attributes opponent_id_should_be_game_player1_id" do
    game = Game.new(id: 1, player1_id: 3, player2_id: 4, player1_turn: true, game_status: 'active',
                    art_trophy_p1: false, entertainment_trophy_p1: false, history_trophy_p1: false,
                    geography_trophy_p1: false, science_trophy_p1: false, sports_trophy_p1: false,
                    art_trophy_p2: false, entertainment_trophy_p2: false, history_trophy_p2: false,
                    geography_trophy_p2: false, science_trophy_p2: false, sports_trophy_p2: false)
    game.save
    challenger = game.player2_id
    challenge = Challenge.new(challenger_correct: 0, opponent_correct: 0)
    challenge.set_game_attributes(game.id, challenger, 'Art', 'Entertainment')
    challenge.generate_question_ids
    challenge.save
    assert_equal(challenge.opponent_id, game.player1_id)
  end

  test "set_game_attributes game_id_should_be_1" do
    game = Game.new(id: 1, player1_id: 3, player2_id: 4, player1_turn: true, game_status: 'active',
                    art_trophy_p1: false, entertainment_trophy_p1: false, history_trophy_p1: false,
                    geography_trophy_p1: false, science_trophy_p1: false, sports_trophy_p1: false,
                    art_trophy_p2: false, entertainment_trophy_p2: false, history_trophy_p2: false,
                    geography_trophy_p2: false, science_trophy_p2: false, sports_trophy_p2: false)
    game.save
    challenger = game.player2_id
    challenge = Challenge.new(challenger_correct: 0, opponent_correct: 0)
    challenge.set_game_attributes(game.id, challenger, 'Art', 'Entertainment')
    challenge.generate_question_ids
    challenge.save
    assert_equal(challenge.game_id, game.id)
  end

  test "set_game_attributes game_id_should_be_2" do
    game = Game.new(id: 2, player1_id: 3, player2_id: 4, player1_turn: true, game_status: 'active',
                    art_trophy_p1: false, entertainment_trophy_p1: false, history_trophy_p1: false,
                    geography_trophy_p1: false, science_trophy_p1: false, sports_trophy_p1: false,
                    art_trophy_p2: false, entertainment_trophy_p2: false, history_trophy_p2: false,
                    geography_trophy_p2: false, science_trophy_p2: false, sports_trophy_p2: false)
    game.save
    challenger = game.player2_id
    challenge = Challenge.new(challenger_correct: 0, opponent_correct: 0)
    challenge.set_game_attributes(game.id, challenger, 'Art', 'Entertainment')
    challenge.generate_question_ids
    challenge.save
    assert_equal(challenge.game_id, game.id)
  end

  test "challenger_winner? should_be_true_p1_c1_v_o0" do
    game = Game.new(id: 1, player1_id: 3, player2_id: 4, player1_turn: true, game_status: 'active',
                    art_trophy_p1: false, entertainment_trophy_p1: false, history_trophy_p1: false,
                    geography_trophy_p1: false, science_trophy_p1: false, sports_trophy_p1: false,
                    art_trophy_p2: false, entertainment_trophy_p2: false, history_trophy_p2: false,
                    geography_trophy_p2: false, science_trophy_p2: false, sports_trophy_p2: false)
    game.save
    challenger = game.player1_id
    challenge = Challenge.new(challenger_correct: 1, opponent_correct: 0)
    challenge.set_game_attributes(game.id, challenger, 'Art', 'Entertainment')
    challenge.generate_question_ids
    challenge.save
    assert_equal(true, challenge.challenger_winner?)
  end

  test "challenger_winner? should_be_false_p1_c0_v_o1" do
    game = Game.new(id: 1, player1_id: 3, player2_id: 4, player1_turn: true, game_status: 'active',
                    art_trophy_p1: false, entertainment_trophy_p1: false, history_trophy_p1: false,
                    geography_trophy_p1: false, science_trophy_p1: false, sports_trophy_p1: false,
                    art_trophy_p2: false, entertainment_trophy_p2: false, history_trophy_p2: false,
                    geography_trophy_p2: false, science_trophy_p2: false, sports_trophy_p2: false)
    game.save
    challenger = game.player1_id
    challenge = Challenge.new(challenger_correct: 0, opponent_correct: 1)
    challenge.set_game_attributes(game.id, challenger, 'Art', 'Entertainment')
    challenge.generate_question_ids
    challenge.save
    assert_equal(false, challenge.challenger_winner?)
  end

  test "challenger_winner? should_be_false_p1_c1_v_o1" do
    game = Game.new(id: 1, player1_id: 3, player2_id: 4, player1_turn: true, game_status: 'active',
                    art_trophy_p1: false, entertainment_trophy_p1: false, history_trophy_p1: false,
                    geography_trophy_p1: false, science_trophy_p1: false, sports_trophy_p1: false,
                    art_trophy_p2: false, entertainment_trophy_p2: false, history_trophy_p2: false,
                    geography_trophy_p2: false, science_trophy_p2: false, sports_trophy_p2: false)
    game.save
    challenger = game.player1_id
    challenge = Challenge.new(challenger_correct: 1, opponent_correct: 1)
    challenge.set_game_attributes(game.id, challenger, 'Art', 'Entertainment')
    challenge.generate_question_ids
    challenge.save
    assert_equal(false, challenge.challenger_winner?)
  end

  test "challenger_winner? should_be_true_p1_c6_v_o1" do
    game = Game.new(id: 1, player1_id: 3, player2_id: 4, player1_turn: true, game_status: 'active',
                    art_trophy_p1: false, entertainment_trophy_p1: false, history_trophy_p1: false,
                    geography_trophy_p1: false, science_trophy_p1: false, sports_trophy_p1: false,
                    art_trophy_p2: false, entertainment_trophy_p2: false, history_trophy_p2: false,
                    geography_trophy_p2: false, science_trophy_p2: false, sports_trophy_p2: false)
    game.save
    challenger = game.player1_id
    challenge = Challenge.new(challenger_correct: 6, opponent_correct: 1)
    challenge.set_game_attributes(game.id, challenger, 'Art', 'Entertainment')
    challenge.generate_question_ids
    challenge.save
    assert_equal(true, challenge.challenger_winner?)
  end

  test "opponent_winner? should_be_false_p1_c1_v_o0" do
    game = Game.new(id: 1, player1_id: 3, player2_id: 4, player1_turn: true, game_status: 'active',
                    art_trophy_p1: false, entertainment_trophy_p1: false, history_trophy_p1: false,
                    geography_trophy_p1: false, science_trophy_p1: false, sports_trophy_p1: false,
                    art_trophy_p2: false, entertainment_trophy_p2: false, history_trophy_p2: false,
                    geography_trophy_p2: false, science_trophy_p2: false, sports_trophy_p2: false)
    game.save
    challenger = game.player1_id
    challenge = Challenge.new(challenger_correct: 1, opponent_correct: 0)
    challenge.set_game_attributes(game.id, challenger, 'Art', 'Entertainment')
    challenge.generate_question_ids
    challenge.save
    assert_equal(false, challenge.opponent_winner?)
  end

  test "opponent_winner? should_be_true_p2_c0_v_o1" do
    game = Game.new(id: 1, player1_id: 3, player2_id: 4, player1_turn: true, game_status: 'active',
                    art_trophy_p1: false, entertainment_trophy_p1: false, history_trophy_p1: false,
                    geography_trophy_p1: false, science_trophy_p1: false, sports_trophy_p1: false,
                    art_trophy_p2: false, entertainment_trophy_p2: false, history_trophy_p2: false,
                    geography_trophy_p2: false, science_trophy_p2: false, sports_trophy_p2: false)
    game.save
    challenger = game.player2_id
    challenge = Challenge.new(challenger_correct: 0, opponent_correct: 1)
    challenge.set_game_attributes(game.id, challenger, 'Art', 'Entertainment')
    challenge.generate_question_ids
    challenge.save
    assert_equal(true, challenge.opponent_winner?)
  end

  test "opponent_winner? should_be_false_p2_c1_v_o1" do
    game = Game.new(id: 1, player1_id: 3, player2_id: 4, player1_turn: true, game_status: 'active',
                    art_trophy_p1: false, entertainment_trophy_p1: false, history_trophy_p1: false,
                    geography_trophy_p1: false, science_trophy_p1: false, sports_trophy_p1: false,
                    art_trophy_p2: false, entertainment_trophy_p2: false, history_trophy_p2: false,
                    geography_trophy_p2: false, science_trophy_p2: false, sports_trophy_p2: false)
    game.save
    challenger = game.player2_id
    challenge = Challenge.new(challenger_correct: 1, opponent_correct: 1)
    challenge.set_game_attributes(game.id, challenger, 'Art', 'Entertainment')
    challenge.generate_question_ids
    challenge.save
    assert_equal(false, challenge.opponent_winner?)
  end

  test "opponent_winner? should_be_false_p2_c0_v_c0" do
    game = Game.new(id: 1, player1_id: 3, player2_id: 4, player1_turn: true, game_status: 'active',
                    art_trophy_p1: false, entertainment_trophy_p1: false, history_trophy_p1: false,
                    geography_trophy_p1: false, science_trophy_p1: false, sports_trophy_p1: false,
                    art_trophy_p2: false, entertainment_trophy_p2: false, history_trophy_p2: false,
                    geography_trophy_p2: false, science_trophy_p2: false, sports_trophy_p2: false)
    game.save
    challenger = game.player2_id
    challenge = Challenge.new(challenger_correct: 0, opponent_correct: 0)
    challenge.set_game_attributes(game.id, challenger, 'Art', 'Entertainment')
    challenge.generate_question_ids
    challenge.save
    assert_equal(false, challenge.opponent_winner?)
  end

  test "tie? should_be_true_c0_v_c0" do
    game = Game.new(id: 1, player1_id: 3, player2_id: 4, player1_turn: true, game_status: 'active',
                    art_trophy_p1: false, entertainment_trophy_p1: false, history_trophy_p1: false,
                    geography_trophy_p1: false, science_trophy_p1: false, sports_trophy_p1: false,
                    art_trophy_p2: false, entertainment_trophy_p2: false, history_trophy_p2: false,
                    geography_trophy_p2: false, science_trophy_p2: false, sports_trophy_p2: false)
    game.save
    challenger = game.player1_id
    challenge = Challenge.new(challenger_correct: 0, opponent_correct: 0)
    challenge.set_game_attributes(game.id, challenger, 'Art', 'Entertainment')
    challenge.generate_question_ids
    challenge.save
    assert_equal(true, challenge.tie?)
  end

  test "winner? should_be_false_c0_v_o0" do
    game = Game.new(id: 1, player1_id: 3, player2_id: 4, player1_turn: true, game_status: 'active',
                    art_trophy_p1: false, entertainment_trophy_p1: false, history_trophy_p1: false,
                    geography_trophy_p1: false, science_trophy_p1: false, sports_trophy_p1: false,
                    art_trophy_p2: false, entertainment_trophy_p2: false, history_trophy_p2: false,
                    geography_trophy_p2: false, science_trophy_p2: false, sports_trophy_p2: false)
    game.save
    challenger = game.player1_id
    challenge = Challenge.new(challenger_correct: 0, opponent_correct: 0)
    challenge.set_game_attributes(game.id, challenger, 'Art', 'Entertainment')
    challenge.generate_question_ids
    challenge.save
    assert_equal(false, challenge.winner?)
  end

  test "winner? should_be_true_c1_v_o0" do
    game = Game.new(id: 1, player1_id: 3, player2_id: 4, player1_turn: true, game_status: 'active',
                    art_trophy_p1: false, entertainment_trophy_p1: false, history_trophy_p1: false,
                    geography_trophy_p1: false, science_trophy_p1: false, sports_trophy_p1: false,
                    art_trophy_p2: false, entertainment_trophy_p2: false, history_trophy_p2: false,
                    geography_trophy_p2: false, science_trophy_p2: false, sports_trophy_p2: false)
    game.save
    challenger = game.player1_id
    challenge = Challenge.new(challenger_correct: 1, opponent_correct: 0)
    challenge.set_game_attributes(game.id, challenger, 'Art', 'Entertainment')
    challenge.generate_question_ids
    challenge.save
    assert_equal(true, challenge.winner?)
  end

  test "winner? should_be_true_c1_v_o7" do
    game = Game.new(id: 1, player1_id: 3, player2_id: 4, player1_turn: true, game_status: 'active',
                    art_trophy_p1: false, entertainment_trophy_p1: false, history_trophy_p1: false,
                    geography_trophy_p1: false, science_trophy_p1: false, sports_trophy_p1: false,
                    art_trophy_p2: false, entertainment_trophy_p2: false, history_trophy_p2: false,
                    geography_trophy_p2: false, science_trophy_p2: false, sports_trophy_p2: false)
    game.save
    challenger = game.player1_id
    challenge = Challenge.new(challenger_correct: 1, opponent_correct: 7)
    challenge.set_game_attributes(game.id, challenger, 'Art', 'Entertainment')
    challenge.generate_question_ids
    challenge.save
    assert_equal(true, challenge.winner?)
  end

  test "winner? should_be_true_c0_v_o1" do
    game = Game.new(id: 1, player1_id: 3, player2_id: 4, player1_turn: true, game_status: 'active',
                    art_trophy_p1: false, entertainment_trophy_p1: false, history_trophy_p1: false,
                    geography_trophy_p1: false, science_trophy_p1: false, sports_trophy_p1: false,
                    art_trophy_p2: false, entertainment_trophy_p2: false, history_trophy_p2: false,
                    geography_trophy_p2: false, science_trophy_p2: false, sports_trophy_p2: false)
    game.save
    challenger = game.player2_id
    challenge = Challenge.new(challenger_correct: 0, opponent_correct: 1)
    challenge.set_game_attributes(game.id, challenger, 'Art', 'Entertainment')
    challenge.generate_question_ids
    challenge.save
    assert_equal(true, challenge.winner?)
  end

  test "get_winner_id? should_be_p1_c1_v_c0" do
    game = Game.new(id: 1, player1_id: 3, player2_id: 4, player1_turn: true, game_status: 'active',
                    art_trophy_p1: true, entertainment_trophy_p1: false, history_trophy_p1: false,
                    geography_trophy_p1: false, science_trophy_p1: false, sports_trophy_p1: false,
                    art_trophy_p2: false, entertainment_trophy_p2: true, history_trophy_p2: false,
                    geography_trophy_p2: false, science_trophy_p2: false, sports_trophy_p2: false)
    game.save
    challenger = game.player1_id
    challenge = Challenge.new(challenger_correct: 1, opponent_correct: 0)
    challenge.set_game_attributes(game.id, challenger, 'Art', 'Entertainment')
    challenge.generate_question_ids
    challenge.set_winner
    assert_equal(challenger, challenge.winner_id)
  end

  test "get_winner_id? should_be_p2_c1_v_o0" do
    game = Game.new(id: 1, player1_id: 3, player2_id: 4, player1_turn: true, game_status: 'active',
                    art_trophy_p1: true, entertainment_trophy_p1: false, history_trophy_p1: false,
                    geography_trophy_p1: false, science_trophy_p1: false, sports_trophy_p1: false,
                    art_trophy_p2: false, entertainment_trophy_p2: true, history_trophy_p2: false,
                    geography_trophy_p2: false, science_trophy_p2: false, sports_trophy_p2: false)
    game.save
    challenger = game.player2_id
    challenge = Challenge.new(challenger_correct: 1, opponent_correct: 0)
    challenge.set_game_attributes(game.id, challenger, 'Art', 'Entertainment')
    challenge.generate_question_ids
    challenge.set_winner
    assert_equal(challenger, challenge.winner_id)
  end

  test "get_winner_id? should_be_p1_c6_v_o1" do
    game = Game.new(id: 1, player1_id: 3, player2_id: 4, player1_turn: true, game_status: 'active',
                    art_trophy_p1: true, entertainment_trophy_p1: false, history_trophy_p1: false,
                    geography_trophy_p1: false, science_trophy_p1: false, sports_trophy_p1: false,
                    art_trophy_p2: false, entertainment_trophy_p2: true, history_trophy_p2: false,
                    geography_trophy_p2: false, science_trophy_p2: false, sports_trophy_p2: false)
    game.save
    challenger = game.player1_id
    challenge = Challenge.new(challenger_correct: 6, opponent_correct: 1)
    challenge.set_game_attributes(game.id, challenger, 'Art', 'Entertainment')
    challenge.generate_question_ids
    challenge.set_winner
    assert_equal(challenger, challenge.winner_id)
  end

end
