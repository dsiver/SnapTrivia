require 'test_helper'

class ChallengeTest < ActiveSupport::TestCase
  BILL_ID = 2
  DAVID_ID = 3
  DOUG_ID = 4

  test "template" do
    challenge = Challenge.new(id: 1, game_id: 1, challenger_id: DAVID_ID, opponent_id: DOUG_ID, wager: Subject::ART, prize: Subject::ENTERTAINMENT,
                              winner_id: 0, challenger_correct: 0, opponent_correct: 0)
    challenge.generate_question_ids
    assert_not(nil, challenge)
  end

  ################################ initialization ################################

  test "should_be_true_players_set" do
    challenge = Challenge.new(id: 1, game_id: 1, challenger_id: DAVID_ID, opponent_id: DOUG_ID, wager: Subject::ART, prize: Subject::ENTERTAINMENT,
                              winner_id: 0, challenger_correct: 0, opponent_correct: 0)
    challenge.generate_question_ids
    expression = challenge.challenger_id == DAVID_ID && challenge.opponent_id == DOUG_ID
    assert_equal(true, expression)
  end

  test "should_be_true_challenger_is_david" do
    challenge = Challenge.new(id: 1, game_id: 1, challenger_id: DAVID_ID, opponent_id: DOUG_ID, wager: Subject::ART, prize: Subject::ENTERTAINMENT,
                              winner_id: 0, challenger_correct: 0, opponent_correct: 0)
    challenge.generate_question_ids
    expression = challenge.challenger_id == DAVID_ID
    assert_equal(true, expression)
  end

  test "should_be_false_challenger_is_david" do
    challenge = Challenge.new(id: 1, game_id: 1, challenger_id: DAVID_ID, opponent_id: DOUG_ID, wager: Subject::ART, prize: Subject::ENTERTAINMENT,
                              winner_id: 0, challenger_correct: 0, opponent_correct: 0)
    challenge.generate_question_ids
    expression = challenge.challenger_id == DOUG_ID
    assert_equal(false, expression)
  end

  test "should_be_true_opponent_is_p2" do
    challenge = Challenge.new(id: 1, game_id: 1, challenger_id: DAVID_ID, opponent_id: DOUG_ID, wager: Subject::ART, prize: Subject::ENTERTAINMENT,
                              winner_id: 0, challenger_correct: 0, opponent_correct: 0)
    challenge.generate_question_ids
    assert_equal(DOUG_ID, challenge.opponent_id)
  end

  ################################ challenger_winner? ################################

  test "challenger_winner? should_be_true_c1_v_o0" do
    challenge = Challenge.new(id: 1, game_id: 1, challenger_id: DAVID_ID, opponent_id: DOUG_ID, wager: Subject::ART, prize: Subject::ENTERTAINMENT,
                              winner_id: 0, challenger_correct: 0, opponent_correct: 0)
    challenge.generate_question_ids
    challenge.update_attributes(:challenger_correct => 1)
    assert_equal(true, challenge.challenger_winner?)
  end

  test "challenger_winner? should_be_false_c0_v_o1" do
    challenge = Challenge.new(id: 1, game_id: 1, challenger_id: DAVID_ID, opponent_id: DOUG_ID, wager: Subject::ART, prize: Subject::ENTERTAINMENT,
                              winner_id: 0, challenger_correct: 0, opponent_correct: 0)
    challenge.generate_question_ids
    challenge.update_attributes(:opponent_correct => 1)
    assert_equal(false, challenge.challenger_winner?)
  end

  test "challenger_winner? should_be_false_c1_v_o1" do
    challenge = Challenge.new(id: 1, game_id: 1, challenger_id: DAVID_ID, opponent_id: DOUG_ID, wager: Subject::ART, prize: Subject::ENTERTAINMENT,
                              winner_id: 0, challenger_correct: 0, opponent_correct: 0)
    challenge.generate_question_ids
    challenge.update_attributes(:challenger_correct => 1, :opponent_correct => 1)
    assert_equal(false, challenge.challenger_winner?)
  end

  test "challenger_winner? should_be_true_c6_v_o1" do
    challenge = Challenge.new(id: 1, game_id: 1, challenger_id: DAVID_ID, opponent_id: DOUG_ID, wager: Subject::ART, prize: Subject::ENTERTAINMENT,
                              winner_id: 0, challenger_correct: 0, opponent_correct: 0)
    challenge.generate_question_ids
    challenge.update_attributes(:challenger_correct => 6, :opponent_correct => 1)
    assert_equal(true, challenge.challenger_winner?)
  end

  ################################ opponent_winner? ################################

  test "opponent_winner? should_be_false_c1_v_o0" do
    challenge = Challenge.new(id: 1, game_id: 1, challenger_id: DAVID_ID, opponent_id: DOUG_ID, wager: Subject::ART, prize: Subject::ENTERTAINMENT,
                              winner_id: 0, challenger_correct: 0, opponent_correct: 0)
    challenge.generate_question_ids
    challenge.update_attributes(:challenger_correct => 1)
    assert_equal(false, challenge.opponent_winner?)
  end

  test "opponent_winner? should_be_true_p2_c0_v_o1" do
    challenge = Challenge.new(id: 1, game_id: 1, challenger_id: DAVID_ID, opponent_id: DOUG_ID, wager: Subject::ART, prize: Subject::ENTERTAINMENT,
                              winner_id: 0, challenger_correct: 0, opponent_correct: 0)
    challenge.generate_question_ids
    challenge.update_attributes(:opponent_correct => 1)
    assert_equal(true, challenge.opponent_winner?)
  end

  test "opponent_winner? should_be_false_c1_v_o1" do
    challenge = Challenge.new(id: 1, game_id: 1, challenger_id: DAVID_ID, opponent_id: DOUG_ID, wager: Subject::ART, prize: Subject::ENTERTAINMENT,
                              winner_id: 0, challenger_correct: 0, opponent_correct: 0)
    challenge.generate_question_ids
    challenge.update_attributes(:challenger_correct => 1, :opponent_correct => 1)
    assert_equal(false, challenge.opponent_winner?)
  end

  test "opponent_winner? should_be_false_c0_v_c0" do
    challenge = Challenge.new(id: 1, game_id: 1, challenger_id: DAVID_ID, opponent_id: DOUG_ID, wager: Subject::ART, prize: Subject::ENTERTAINMENT,
                              winner_id: 0, challenger_correct: 0, opponent_correct: 0)
    challenge.generate_question_ids
    assert_equal(false, challenge.opponent_winner?)
  end

  ################################ tie? ################################

  test "tie? should_be_true_c0_v_c0" do
    challenge = Challenge.new(id: 1, game_id: 1, challenger_id: DAVID_ID, opponent_id: DOUG_ID, wager: Subject::ART, prize: Subject::ENTERTAINMENT,
                              winner_id: 0, challenger_correct: 0, opponent_correct: 0)
    challenge.generate_question_ids
    assert_equal(true, challenge.tie?)
  end

  ################################ winner? ################################

  test "winner? should_be_false_c0_v_o0" do
    challenge = Challenge.new(id: 1, game_id: 1, challenger_id: DAVID_ID, opponent_id: DOUG_ID, wager: Subject::ART, prize: Subject::ENTERTAINMENT,
                              winner_id: 0, challenger_correct: 0, opponent_correct: 0)
    challenge.generate_question_ids
    assert_equal(false, challenge.winner?)
  end

  test "winner? should_be_true_c1_v_o0" do
    challenge = Challenge.new(id: 1, game_id: 1, challenger_id: DAVID_ID, opponent_id: DOUG_ID, wager: Subject::ART, prize: Subject::ENTERTAINMENT,
                              winner_id: 0, challenger_correct: 0, opponent_correct: 0)
    challenge.generate_question_ids
    challenge.update_attributes(:challenger_correct => 1)
    assert_equal(true, challenge.winner?)
  end

  test "winner? should_be_true_c1_v_o7" do
    challenge = Challenge.new(id: 1, game_id: 1, challenger_id: DAVID_ID, opponent_id: DOUG_ID, wager: Subject::ART, prize: Subject::ENTERTAINMENT,
                              winner_id: 0, challenger_correct: 0, opponent_correct: 0)
    challenge.generate_question_ids
    challenge.update_attributes(:challenger_correct => 1, :opponent_correct => 7)
    assert_equal(true, challenge.winner?)
  end

  test "winner? should_be_true_c0_v_o1" do
    challenge = Challenge.new(id: 1, game_id: 1, challenger_id: DAVID_ID, opponent_id: DOUG_ID, wager: Subject::ART, prize: Subject::ENTERTAINMENT,
                               winner_id: 0, challenger_correct: 0, opponent_correct: 0)
    challenge.generate_question_ids
    challenge.update_attributes(:challenger_correct => 0, :opponent_correct => 1)
    assert_equal(true, challenge.winner?)
  end

  ################################ set_winner ################################

  test "set_winner should_be_challenger_c1_v_c0" do
    challenge = Challenge.new(id: 1, game_id: 1, challenger_id: DAVID_ID, opponent_id: DOUG_ID, wager: Subject::ART, prize: Subject::ENTERTAINMENT,
                              winner_id: 0, challenger_correct: 0, opponent_correct: 0)
    challenge.generate_question_ids
    challenge.update_attributes(:challenger_correct => 1, :opponent_correct => 0)
    challenge.set_winner
    assert_equal(DAVID_ID, challenge.winner_id)
  end

  ################################ add_correct_answer ################################

  test "add_correct_answer should_be_1_challenger" do
    challenge = Challenge.new(id: 1, game_id: 1, challenger_id: DAVID_ID, opponent_id: DOUG_ID, wager: Subject::ART, prize: Subject::ENTERTAINMENT,
                              winner_id: 0, challenger_correct: 0, opponent_correct: 0)
    challenge.generate_question_ids
    challenge.add_correct_answer(DAVID_ID)
    assert_equal(1, challenge.challenger_correct)
  end

  test "add_correct_answer should_be_1_opponent" do
    challenge = Challenge.new(id: 1, game_id: 1, challenger_id: DAVID_ID, opponent_id: DOUG_ID, wager: Subject::ART, prize: Subject::ENTERTAINMENT,
                              winner_id: 0, challenger_correct: 0, opponent_correct: 0)
    challenge.generate_question_ids
    challenge.add_correct_answer(DOUG_ID)
    assert_equal(1, challenge.opponent_correct)
  end

  ################################ apply_challenge_results ################################


end
