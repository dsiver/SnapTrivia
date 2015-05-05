require 'test_helper'

class ChallengeTest < ActiveSupport::TestCase

  CHALLENGER_ID = 100
  OPPONENT_ID = 200

  test "template" do
    challenge = Challenge.new(id: 1, game_id: 1, challenger_id: CHALLENGER_ID, opponent_id: OPPONENT_ID, wager: Subject::ART, prize: Subject::ENTERTAINMENT,
                              winner_id: 0, challenger_correct: 0, opponent_correct: 0)
    challenge.generate_question_ids
    assert_not(nil, challenge)
  end

  test "empty" do
    challenge = Challenge.new
    assert_equal(true, true)
  end

  test "empty expression_should_be_false_question_ids_not_nil" do
    challenge = Challenge.new
    expression = challenge.art_id.nil? || challenge.ent_id.nil? || challenge.history_id.nil? || challenge.geo_id.nil? || challenge.science_id.nil? || challenge.sports_id.nil?
    assert_not(false, expression)
  end

  ################################################### Class Methods ###################################################

  ################################ get_ongoing_challenge ################################

  test "get_ongoing_challenge" do
    challenge = Challenge.new(game_id: 1, challenger_id: CHALLENGER_ID, opponent_id: OPPONENT_ID, wager: Subject::ART, prize: Subject::ENTERTAINMENT,
                              winner_id: 0, challenger_correct: 0, opponent_correct: 0)
    assert_equal(true, true)
  end

  test "get_ongoing_challenge should_return_one_ongoing_challenge" do
    challenge = Challenge.new(game_id: 1, challenger_id: CHALLENGER_ID, opponent_id: OPPONENT_ID, wager: Subject::ART, prize: Subject::ENTERTAINMENT,
                              winner_id: 0, challenger_correct: 0, opponent_correct: 0)
    assert_equal(challenge, Challenge.get_ongoing_challenge(1, CHALLENGER_ID, OPPONENT_ID))
  end

  test "get_ongoing_challenge should_return_correct_challenge_two_challenges_different_game_ids" do
    challenges = []
    2.times {
      c = Challenge.new
      challenges << c
    }
    (0..challenges.count-1).each { |i|
      challenges[i].update_attributes(game_id: i+1, challenger_id: CHALLENGER_ID, opponent_id: OPPONENT_ID, wager: Subject::ART, prize: Subject::ENTERTAINMENT,
                                      winner_id: 0, challenger_correct: 0, opponent_correct: 0)
    }
    challenges.shuffle
    game_id = challenges.first.game_id
    assert_equal(challenges.first, Challenge.get_ongoing_challenge(game_id, CHALLENGER_ID, OPPONENT_ID))
  end

  test "get_ongoing_challenge should_return_correct_challenge_5_challenges_different_game_ids" do
    challenges = []
    5.times {
      c = Challenge.new
      challenges << c
    }
    (0..challenges.count-1).each { |i|
      challenges[i].update_attributes(game_id: i+1, challenger_id: CHALLENGER_ID, opponent_id: OPPONENT_ID, wager: Subject::ART, prize: Subject::ENTERTAINMENT,
                                      winner_id: 0, challenger_correct: 0, opponent_correct: 0)
    }
    challenges.shuffle
    game_id = challenges.first.game_id
    assert_equal(challenges.first, Challenge.get_ongoing_challenge(game_id, CHALLENGER_ID, OPPONENT_ID))
  end

  test "get_ongoing_challenge should_return_correct_challenge_when_a_game_has_one_finished_challenge" do
    challenges = []
    5.times {
      c = Challenge.new
      challenges << c
    }
    (0..1).each { |i|
      if i == 0
        challenges[i].update_attributes(game_id: 1, challenger_id: CHALLENGER_ID, opponent_id: OPPONENT_ID, wager: Subject::ART, prize: Subject::ENTERTAINMENT,
                                        winner_id: 0, challenger_correct: 0, opponent_correct: 0)
      else
        challenges[i].update_attributes(game_id: 1, challenger_id: CHALLENGER_ID, opponent_id: OPPONENT_ID, wager: Subject::ART, prize: Subject::ENTERTAINMENT,
                                        winner_id: CHALLENGER_ID, challenger_correct: 0, opponent_correct: 0)
      end
    }
    (2..challenges.count-1).each { |i|
      challenges[i].update_attributes(game_id: i+1, challenger_id: CHALLENGER_ID, opponent_id: OPPONENT_ID, wager: Subject::ART, prize: Subject::ENTERTAINMENT,
                                      winner_id: 0, challenger_correct: 0, opponent_correct: 0)
    }
    challenges.shuffle
    game_id = challenges.first.game_id
    assert_equal(challenges.first, Challenge.get_ongoing_challenge(game_id, CHALLENGER_ID, OPPONENT_ID))
  end

  test "get_ongoing_challenge should_return_correct_challenge_when_a_game_has_multiple_finished_challenges" do
    challenges = []
    8.times {
      c = Challenge.new
      challenges << c
    }
    (0..4).each { |i|
      if i == 0
        challenges[i].update_attributes(game_id: 1, challenger_id: CHALLENGER_ID, opponent_id: OPPONENT_ID, wager: Subject::ART, prize: Subject::ENTERTAINMENT,
                                        winner_id: 0, challenger_correct: 0, opponent_correct: 0)
      else
        challenges[i].update_attributes(game_id: 1, challenger_id: CHALLENGER_ID, opponent_id: OPPONENT_ID, wager: Subject::ART, prize: Subject::ENTERTAINMENT,
                                        winner_id: CHALLENGER_ID, challenger_correct: 0, opponent_correct: 0)
      end
    }
    (5..challenges.count-1).each { |i|
      challenges[i].update_attributes(game_id: i+1, challenger_id: CHALLENGER_ID, opponent_id: OPPONENT_ID, wager: Subject::ART, prize: Subject::ENTERTAINMENT,
                                      winner_id: 0, challenger_correct: 0, opponent_correct: 0)
    }
    challenges.shuffle
    game_id = challenges.first.game_id
    assert_equal(challenges.first, Challenge.get_ongoing_challenge(game_id, CHALLENGER_ID, OPPONENT_ID))
  end

  test "get_ongoing_challenge test" do
    count = 25
    stop = 10
    restart = 11
    challenges = []
    count.times {
      c = Challenge.new
      challenges << c
    }
    assert_equal(count, challenges.count)
    assert_not_equal(true, challenges.any? { |c| c.nil?})
    (0..stop).each { |i|
      if i == 0
        challenges[i].update_attributes(game_id: 1, challenger_id: CHALLENGER_ID, opponent_id: OPPONENT_ID, wager: Subject::ART, prize: Subject::ENTERTAINMENT,
                                        winner_id: 0, challenger_correct: 0, opponent_correct: 0)
      else
        challenges[i].update_attributes(game_id: 1, challenger_id: CHALLENGER_ID, opponent_id: OPPONENT_ID, wager: Subject::ART, prize: Subject::ENTERTAINMENT,
                                        winner_id: CHALLENGER_ID, challenger_correct: 0, opponent_correct: 0)
      end
    }
    (restart..challenges.count-1).each { |i|
      challenges[i].update_attributes(game_id: i+1, challenger_id: CHALLENGER_ID, opponent_id: OPPONENT_ID, wager: Subject::ART, prize: Subject::ENTERTAINMENT,
                                      winner_id: 0, challenger_correct: 0, opponent_correct: 0)
    }
    challenges.shuffle
    game_id = challenges.first.game_id
    assert_equal(challenges.first, Challenge.get_ongoing_challenge(game_id, CHALLENGER_ID, OPPONENT_ID))
    assert_equal(false, challenges.all? {|c|c.game_id == 1})
    assert_equal(true, challenges.all? {|c|c.challenger_id == CHALLENGER_ID && c.opponent_id == OPPONENT_ID})
  end

  ################################ get_ongoing_challenge_by_game ################################

  test "get_ongoing_challenge_by_game should_return_one_ongoing_challenge" do
    challenge = Challenge.new(game_id: 1, challenger_id: CHALLENGER_ID, opponent_id: OPPONENT_ID, wager: Subject::ART, prize: Subject::ENTERTAINMENT,
                              winner_id: 0, challenger_correct: 0, opponent_correct: 0)
    assert_equal(challenge, Challenge::get_ongoing_challenge_by_game(1))
  end

  test "get_ongoing_challenge_by_game should_return_correct_challenge_two_challenges_different_game_ids" do
    challenges = []
    2.times {
      c = Challenge.new
      challenges << c
    }
    (0..challenges.count-1).each { |i|
      challenges[i].update_attributes(game_id: i+1, challenger_id: CHALLENGER_ID, opponent_id: OPPONENT_ID, wager: Subject::ART, prize: Subject::ENTERTAINMENT,
                                      winner_id: 0, challenger_correct: 0, opponent_correct: 0)
    }
    challenges.shuffle
    game_id = challenges.first.game_id
    assert_equal(challenges.first, Challenge.get_ongoing_challenge_by_game(game_id))
  end

  test "get_ongoing_challenge_by_game should_return_correct_challenge_5_challenges_different_game_ids" do
    challenges = []
    5.times {
      c = Challenge.new
      challenges << c
    }
    (0..challenges.count-1).each { |i|
      challenges[i].update_attributes(game_id: i+1, challenger_id: CHALLENGER_ID, opponent_id: OPPONENT_ID, wager: Subject::ART, prize: Subject::ENTERTAINMENT,
                                      winner_id: 0, challenger_correct: 0, opponent_correct: 0)
    }
    challenges.shuffle
    game_id = challenges.first.game_id
    assert_equal(challenges.first, Challenge.get_ongoing_challenge_by_game(game_id))
  end

  test "get_ongoing_challenge_by_game should_return_correct_challenge_when_a_game_has_one_finished_challenge" do
    challenges = []
    5.times {
      c = Challenge.new
      challenges << c
    }
    (0..1).each { |i|
      if i == 0
        challenges[i].update_attributes(game_id: 1, challenger_id: CHALLENGER_ID, opponent_id: OPPONENT_ID, wager: Subject::ART, prize: Subject::ENTERTAINMENT,
                                        winner_id: 0, challenger_correct: 0, opponent_correct: 0)
      else
        challenges[i].update_attributes(game_id: 1, challenger_id: CHALLENGER_ID, opponent_id: OPPONENT_ID, wager: Subject::ART, prize: Subject::ENTERTAINMENT,
                                        winner_id: CHALLENGER_ID, challenger_correct: 0, opponent_correct: 0)
      end
    }
    (2..challenges.count-1).each { |i|
      challenges[i].update_attributes(game_id: i+1, challenger_id: CHALLENGER_ID, opponent_id: OPPONENT_ID, wager: Subject::ART, prize: Subject::ENTERTAINMENT,
                                      winner_id: 0, challenger_correct: 0, opponent_correct: 0)
    }
    challenges.shuffle
    game_id = challenges.first.game_id
    assert_equal(challenges.first, Challenge.get_ongoing_challenge_by_game(game_id))
  end

  test "get_ongoing_challenge_by_game should_return_correct_challenge_when_a_game_has_multiple_finished_challenges" do
    challenges = []
    8.times {
      c = Challenge.new
      challenges << c
    }
    (0..4).each { |i|
      if i == 0
        challenges[i].update_attributes(game_id: 1, challenger_id: CHALLENGER_ID, opponent_id: OPPONENT_ID, wager: Subject::ART, prize: Subject::ENTERTAINMENT,
                                        winner_id: 0, challenger_correct: 0, opponent_correct: 0)
      else
        challenges[i].update_attributes(game_id: 1, challenger_id: CHALLENGER_ID, opponent_id: OPPONENT_ID, wager: Subject::ART, prize: Subject::ENTERTAINMENT,
                                        winner_id: CHALLENGER_ID, challenger_correct: 0, opponent_correct: 0)
      end
    }
    (5..challenges.count-1).each { |i|
      challenges[i].update_attributes(game_id: i+1, challenger_id: CHALLENGER_ID, opponent_id: OPPONENT_ID, wager: Subject::ART, prize: Subject::ENTERTAINMENT,
                                      winner_id: 0, challenger_correct: 0, opponent_correct: 0)
    }
    challenges.shuffle
    game_id = challenges.first.game_id
    assert_equal(challenges.first, Challenge.get_ongoing_challenge_by_game(game_id))
  end

  ################################################## Instance Methods ##################################################

  ################################ counter ################################

  test "counter should_be_0_new_challenge" do
    challenge = Challenge.new
    assert_equal(0, challenge.counter)
  end

  ################################ initialization with attributes ################################

  test "should_be_true_players_set" do
    challenge = Challenge.new(id: 1, game_id: 1, challenger_id: CHALLENGER_ID, opponent_id: OPPONENT_ID, wager: Subject::ART, prize: Subject::ENTERTAINMENT,
                              winner_id: 0, challenger_correct: 0, opponent_correct: 0)
    challenge.generate_question_ids
    expression = challenge.challenger_id == CHALLENGER_ID && challenge.opponent_id == OPPONENT_ID
    assert_equal(true, expression)
  end

  test "should_be_true_challenger_is_david" do
    challenge = Challenge.new(id: 1, game_id: 1, challenger_id: CHALLENGER_ID, opponent_id: OPPONENT_ID, wager: Subject::ART, prize: Subject::ENTERTAINMENT,
                              winner_id: 0, challenger_correct: 0, opponent_correct: 0)
    challenge.generate_question_ids
    expression = challenge.challenger_id == CHALLENGER_ID
    assert_equal(true, expression)
  end

  test "should_be_false_challenger_is_david" do
    challenge = Challenge.new(id: 1, game_id: 1, challenger_id: CHALLENGER_ID, opponent_id: OPPONENT_ID, wager: Subject::ART, prize: Subject::ENTERTAINMENT,
                              winner_id: 0, challenger_correct: 0, opponent_correct: 0)
    challenge.generate_question_ids
    expression = challenge.challenger_id == OPPONENT_ID
    assert_equal(false, expression)
  end

  test "should_be_true_opponent_is_p2" do
    challenge = Challenge.new(id: 1, game_id: 1, challenger_id: CHALLENGER_ID, opponent_id: OPPONENT_ID, wager: Subject::ART, prize: Subject::ENTERTAINMENT,
                              winner_id: 0, challenger_correct: 0, opponent_correct: 0)
    challenge.generate_question_ids
    assert_equal(OPPONENT_ID, challenge.opponent_id)
  end

  ################################ challenger_winner? ################################

  test "challenger_winner? should_be_true_c1_v_o0" do
    challenge = Challenge.new(id: 1, game_id: 1, challenger_id: CHALLENGER_ID, opponent_id: OPPONENT_ID, wager: Subject::ART, prize: Subject::ENTERTAINMENT,
                              winner_id: 0, challenger_correct: 0, opponent_correct: 0)
    challenge.generate_question_ids
    challenge.update_attributes(:challenger_correct => 1)
    assert_equal(true, challenge.challenger_winner?)
  end

  test "challenger_winner? should_be_false_c0_v_o1" do
    challenge = Challenge.new(id: 1, game_id: 1, challenger_id: CHALLENGER_ID, opponent_id: OPPONENT_ID, wager: Subject::ART, prize: Subject::ENTERTAINMENT,
                              winner_id: 0, challenger_correct: 0, opponent_correct: 0)
    challenge.generate_question_ids
    challenge.update_attributes(:opponent_correct => 1)
    assert_equal(false, challenge.challenger_winner?)
  end

  test "challenger_winner? should_be_false_c1_v_o1" do
    challenge = Challenge.new(id: 1, game_id: 1, challenger_id: CHALLENGER_ID, opponent_id: OPPONENT_ID, wager: Subject::ART, prize: Subject::ENTERTAINMENT,
                              winner_id: 0, challenger_correct: 0, opponent_correct: 0)
    challenge.generate_question_ids
    challenge.update_attributes(:challenger_correct => 1, :opponent_correct => 1)
    assert_equal(false, challenge.challenger_winner?)
  end

  test "challenger_winner? should_be_true_c6_v_o1" do
    challenge = Challenge.new(id: 1, game_id: 1, challenger_id: CHALLENGER_ID, opponent_id: OPPONENT_ID, wager: Subject::ART, prize: Subject::ENTERTAINMENT,
                              winner_id: 0, challenger_correct: 0, opponent_correct: 0)
    challenge.generate_question_ids
    challenge.update_attributes(:challenger_correct => 6, :opponent_correct => 1)
    assert_equal(true, challenge.challenger_winner?)
  end

  ################################ opponent_winner? ################################

  test "opponent_winner? should_be_false_c1_v_o0" do
    challenge = Challenge.new(id: 1, game_id: 1, challenger_id: CHALLENGER_ID, opponent_id: OPPONENT_ID, wager: Subject::ART, prize: Subject::ENTERTAINMENT,
                              winner_id: 0, challenger_correct: 0, opponent_correct: 0)
    challenge.generate_question_ids
    challenge.update_attributes(:challenger_correct => 1)
    assert_equal(false, challenge.opponent_winner?)
  end

  test "opponent_winner? should_be_true_p2_c0_v_o1" do
    challenge = Challenge.new(id: 1, game_id: 1, challenger_id: CHALLENGER_ID, opponent_id: OPPONENT_ID, wager: Subject::ART, prize: Subject::ENTERTAINMENT,
                              winner_id: 0, challenger_correct: 0, opponent_correct: 0)
    challenge.generate_question_ids
    challenge.update_attributes(:opponent_correct => 1)
    assert_equal(true, challenge.opponent_winner?)
  end

  test "opponent_winner? should_be_false_c1_v_o1" do
    challenge = Challenge.new(id: 1, game_id: 1, challenger_id: CHALLENGER_ID, opponent_id: OPPONENT_ID, wager: Subject::ART, prize: Subject::ENTERTAINMENT,
                              winner_id: 0, challenger_correct: 0, opponent_correct: 0)
    challenge.generate_question_ids
    challenge.update_attributes(:challenger_correct => 1, :opponent_correct => 1)
    assert_equal(false, challenge.opponent_winner?)
  end

  test "opponent_winner? should_be_false_c0_v_c0" do
    challenge = Challenge.new(id: 1, game_id: 1, challenger_id: CHALLENGER_ID, opponent_id: OPPONENT_ID, wager: Subject::ART, prize: Subject::ENTERTAINMENT,
                              winner_id: 0, challenger_correct: 0, opponent_correct: 0)
    challenge.generate_question_ids
    assert_equal(false, challenge.opponent_winner?)
  end

  ################################ tie? ################################

  test "tie? should_be_true_c0_v_c0" do
    challenge = Challenge.new(id: 1, game_id: 1, challenger_id: CHALLENGER_ID, opponent_id: OPPONENT_ID, wager: Subject::ART, prize: Subject::ENTERTAINMENT,
                              winner_id: 0, challenger_correct: 0, opponent_correct: 0)
    challenge.generate_question_ids
    assert_equal(true, challenge.tie?)
  end

  ################################ winner? ################################

  test "winner? should_be_false_c0_v_o0" do
    challenge = Challenge.new(id: 1, game_id: 1, challenger_id: CHALLENGER_ID, opponent_id: OPPONENT_ID, wager: Subject::ART, prize: Subject::ENTERTAINMENT,
                              winner_id: 0, challenger_correct: 0, opponent_correct: 0)
    challenge.generate_question_ids
    assert_equal(false, challenge.winner?)
  end

  test "winner? should_be_true_c1_v_o0" do
    challenge = Challenge.new(id: 1, game_id: 1, challenger_id: CHALLENGER_ID, opponent_id: OPPONENT_ID, wager: Subject::ART, prize: Subject::ENTERTAINMENT,
                              winner_id: 0, challenger_correct: 0, opponent_correct: 0)
    challenge.generate_question_ids
    challenge.update_attributes(:challenger_correct => 1)
    assert_equal(true, challenge.winner?)
  end

  test "winner? should_be_true_c1_v_o7" do
    challenge = Challenge.new(id: 1, game_id: 1, challenger_id: CHALLENGER_ID, opponent_id: OPPONENT_ID, wager: Subject::ART, prize: Subject::ENTERTAINMENT,
                              winner_id: 0, challenger_correct: 0, opponent_correct: 0)
    challenge.generate_question_ids
    challenge.update_attributes(:challenger_correct => 1, :opponent_correct => 7)
    assert_equal(true, challenge.winner?)
  end

  test "winner? should_be_true_c0_v_o1" do
    challenge = Challenge.new(id: 1, game_id: 1, challenger_id: CHALLENGER_ID, opponent_id: OPPONENT_ID, wager: Subject::ART, prize: Subject::ENTERTAINMENT,
                               winner_id: 0, challenger_correct: 0, opponent_correct: 0)
    challenge.generate_question_ids
    challenge.update_attributes(:challenger_correct => 0, :opponent_correct => 1)
    assert_equal(true, challenge.winner?)
  end

  ################################ set_winner ################################

  test "set_winner should_be_challenger_c1_v_c0" do
    challenge = Challenge.new(id: 1, game_id: 1, challenger_id: CHALLENGER_ID, opponent_id: OPPONENT_ID, wager: Subject::ART, prize: Subject::ENTERTAINMENT,
                              winner_id: 0, challenger_correct: 0, opponent_correct: 0)
    challenge.generate_question_ids
    challenge.update_attributes(:challenger_correct => 1, :opponent_correct => 0)
    challenge.set_winner
    assert_equal(CHALLENGER_ID, challenge.winner_id)
  end

  ################################ add_correct_answer ################################

  test "add_correct_answer should_be_1_challenger" do
    challenge = Challenge.new(id: 1, game_id: 1, challenger_id: CHALLENGER_ID, opponent_id: OPPONENT_ID, wager: Subject::ART, prize: Subject::ENTERTAINMENT,
                              winner_id: 0, challenger_correct: 0, opponent_correct: 0)
    challenge.generate_question_ids
    challenge.add_correct_answer(CHALLENGER_ID)
    assert_equal(1, challenge.challenger_correct)
  end

  test "add_correct_answer should_be_1_opponent" do
    challenge = Challenge.new(id: 1, game_id: 1, challenger_id: CHALLENGER_ID, opponent_id: OPPONENT_ID, wager: Subject::ART, prize: Subject::ENTERTAINMENT,
                              winner_id: 0, challenger_correct: 0, opponent_correct: 0)
    challenge.generate_question_ids
    challenge.add_correct_answer(OPPONENT_ID)
    assert_equal(1, challenge.opponent_correct)
  end

  ################################ apply_question_result ################################

  ######## Testing raises error ########

  #### Testing CHALLENGER_ID ####

  ## Testing Game::BONUS_TRUE ##

  # Testing Question::CORRECT #

  test "apply_question_result raises_error_challenger_gets_bonus_question_correct_bonus_true_0v0" do
    challenge = Challenge.new(id: 1, game_id: 1, challenger_id: CHALLENGER_ID, opponent_id: OPPONENT_ID, wager: Subject::ART, prize: Subject::ENTERTAINMENT,
                              winner_id: 0, challenger_correct: 0, opponent_correct: 0)
    challenge.generate_question_ids
    assert_raises(RuntimeError) { challenge.apply_question_result(CHALLENGER_ID, Question::CORRECT, Game::BONUS_TRUE, 1) }
  end

  # Testing Question::INCORRECT #

  test "apply_question_result raises_error_challenger_gets_bonus_question_incorrect_bonus_true_0v0" do
    challenge = Challenge.new(id: 1, game_id: 1, challenger_id: CHALLENGER_ID, opponent_id: OPPONENT_ID, wager: Subject::ART, prize: Subject::ENTERTAINMENT,
                              winner_id: 0, challenger_correct: 0, opponent_correct: 0)
    challenge.generate_question_ids
    assert_raises(RuntimeError) { challenge.apply_question_result(CHALLENGER_ID, Question::INCORRECT, Game::BONUS_TRUE, 1) }
  end

  ## Testing Game::BONUS_FALSE ##

  # Testing Question::CORRECT #

  test "apply_question_result raises_error_challenger_gets_7th_question_correct_bonus_false" do
    challenge = Challenge.new(id: 1, game_id: 1, challenger_id: CHALLENGER_ID, opponent_id: OPPONENT_ID, wager: Subject::ART, prize: Subject::ENTERTAINMENT,
                              winner_id: 0, challenger_correct: 0, opponent_correct: 0)
    challenge.generate_question_ids
    challenge.counter = 6
    assert_raises(RuntimeError) { challenge.apply_question_result(CHALLENGER_ID, Question::CORRECT, Game::BONUS_FALSE, 7) }
  end

  # Testing Question::INCORRECT #

  test "apply_question_result raises_error_challenger_gets_7th_question_incorrect_bonus_false" do
    challenge = Challenge.new(id: 1, game_id: 1, challenger_id: CHALLENGER_ID, opponent_id: OPPONENT_ID, wager: Subject::ART, prize: Subject::ENTERTAINMENT,
                              winner_id: 0, challenger_correct: 0, opponent_correct: 0)
    challenge.generate_question_ids
    challenge.counter = 6
    assert_raises(RuntimeError) { challenge.apply_question_result(CHALLENGER_ID, Question::INCORRECT, Game::BONUS_FALSE, 7) }
  end

  # Testing mismatch question number and counter #

  test "apply_question_result raises_error_counter_mismatch_challenger_gets_2nd_question_counter_0" do
    challenge = Challenge.new(id: 1, game_id: 1, challenger_id: CHALLENGER_ID, opponent_id: OPPONENT_ID, wager: Subject::ART, prize: Subject::ENTERTAINMENT,
                              winner_id: 0, challenger_correct: 0, opponent_correct: 0)
    challenge.generate_question_ids
    challenge.counter = 0
    assert_raises(RuntimeError) { challenge.apply_question_result(CHALLENGER_ID, Question::CORRECT, Game::BONUS_FALSE, 2) }
  end

  test "apply_question_result raises_error_counter_mismatch_challenger_gets_5th_question_counter_6" do
    challenge = Challenge.new(id: 1, game_id: 1, challenger_id: CHALLENGER_ID, opponent_id: OPPONENT_ID, wager: Subject::ART, prize: Subject::ENTERTAINMENT,
                              winner_id: 0, challenger_correct: 0, opponent_correct: 0)
    challenge.generate_question_ids
    challenge.counter = 6
    assert_raises(RuntimeError) { challenge.apply_question_result(CHALLENGER_ID, Question::CORRECT, Game::BONUS_FALSE, 5) }
  end

  #### Testing OPPONENT_ID ####

  ## Testing Game::BONUS_FALSE ##

  # Testing Question::CORRECT #

  test "apply_question_result raises_error_opponent_gets_7th_question_correct_bonus_false_5v6" do
    challenge = Challenge.new(id: 1, game_id: 1, challenger_id: CHALLENGER_ID, opponent_id: OPPONENT_ID, wager: Subject::ART, prize: Subject::ENTERTAINMENT,
                              winner_id: 0, challenger_correct: 5, opponent_correct: 6)
    challenge.generate_question_ids
    challenge.counter = 6
    assert_raises(RuntimeError) { challenge.apply_question_result(OPPONENT_ID, Question::CORRECT, Game::BONUS_FALSE, 7) }
  end

  test "apply_question_result raises_error_opponent_gets_7th_question_correct_bonus_false_5v5" do
    challenge = Challenge.new(id: 1, game_id: 1, challenger_id: CHALLENGER_ID, opponent_id: OPPONENT_ID, wager: Subject::ART, prize: Subject::ENTERTAINMENT,
                              winner_id: 0, challenger_correct: 5, opponent_correct: 5)
    challenge.generate_question_ids
    challenge.counter = 6
    assert_raises(RuntimeError) { challenge.apply_question_result(OPPONENT_ID, Question::CORRECT, Game::BONUS_FALSE, 7) }
  end

  # Testing Question::INCORRECT #

  test "apply_question_result raises_error_opponent_gets_7th_question_correct_bonus_false_1v6" do
    challenge = Challenge.new(id: 1, game_id: 1, challenger_id: CHALLENGER_ID, opponent_id: OPPONENT_ID, wager: Subject::ART, prize: Subject::ENTERTAINMENT,
                              winner_id: 0, challenger_correct: 1, opponent_correct: 6)
    challenge.generate_question_ids
    challenge.counter = 6
    assert_raises(RuntimeError) { challenge.apply_question_result(OPPONENT_ID, Question::INCORRECT, Game::BONUS_FALSE, 7) }
  end

  test "apply_question_result raises_error_opponent_gets_7th_question_incorrect_bonus_false_5v6" do
    challenge = Challenge.new(id: 1, game_id: 1, challenger_id: CHALLENGER_ID, opponent_id: OPPONENT_ID, wager: Subject::ART, prize: Subject::ENTERTAINMENT,
                              winner_id: 0, challenger_correct: 5, opponent_correct: 6)
    challenge.generate_question_ids
    challenge.counter = 6
    assert_raises(RuntimeError) { challenge.apply_question_result(OPPONENT_ID, Question::INCORRECT, Game::BONUS_FALSE, 7) }
  end

  test "apply_question_result raises_error_opponent_gets_7th_question_incorrect_bonus_false_5v5" do
    challenge = Challenge.new(id: 1, game_id: 1, challenger_id: CHALLENGER_ID, opponent_id: OPPONENT_ID, wager: Subject::ART, prize: Subject::ENTERTAINMENT,
                              winner_id: 0, challenger_correct: 5, opponent_correct: 5)
    challenge.generate_question_ids
    challenge.counter = 6
    assert_raises(RuntimeError) { challenge.apply_question_result(OPPONENT_ID, Question::INCORRECT, Game::BONUS_FALSE, 7) }
  end

  # Testing mismatch question number and counter #

  test "apply_question_result raises_error_counter_mismatch_opponent_gets_2nd_question_counter_0_bonus_false" do
    challenge = Challenge.new(id: 1, game_id: 1, challenger_id: CHALLENGER_ID, opponent_id: OPPONENT_ID, wager: Subject::ART, prize: Subject::ENTERTAINMENT,
                              winner_id: 0, challenger_correct: 0, opponent_correct: 0)
    challenge.generate_question_ids
    challenge.counter = 0
    assert_raises(RuntimeError) { challenge.apply_question_result(OPPONENT_ID, Question::CORRECT, Game::BONUS_FALSE, 2) }
  end

  test "apply_question_result raises_error_counter_mismatch_opponent_gets_5th_question_counter_6_bonus_false" do
    challenge = Challenge.new(id: 1, game_id: 1, challenger_id: CHALLENGER_ID, opponent_id: OPPONENT_ID, wager: Subject::ART, prize: Subject::ENTERTAINMENT,
                              winner_id: 0, challenger_correct: 0, opponent_correct: 0)
    challenge.generate_question_ids
    challenge.counter = 6
    assert_raises(RuntimeError) { challenge.apply_question_result(OPPONENT_ID, Question::CORRECT, Game::BONUS_FALSE, 5) }
  end

  ## Testing Game::BONUS_TRUE ##

  test "apply_question_result raises_error_opponent_gets_8th_question_incorrect_bonus_true" do
    challenge = Challenge.new(id: 1, game_id: 1, challenger_id: CHALLENGER_ID, opponent_id: OPPONENT_ID, wager: Subject::ART, prize: Subject::ENTERTAINMENT,
                              winner_id: 0, challenger_correct: 0, opponent_correct: 0)
    challenge.generate_question_ids
    challenge.counter = 7
    assert_raises(RuntimeError) { challenge.apply_question_result(OPPONENT_ID, Question::INCORRECT, Game::BONUS_TRUE, 8) }
  end

  test "apply_question_result raises_error_opponent_gets_6th_question_correct_bonus_true" do
    challenge = Challenge.new(id: 1, game_id: 1, challenger_id: CHALLENGER_ID, opponent_id: OPPONENT_ID, wager: Subject::ART, prize: Subject::ENTERTAINMENT,
                              winner_id: 0, challenger_correct: 0, opponent_correct: 0)
    challenge.generate_question_ids
    challenge.counter = 5
    assert_raises(RuntimeError) { challenge.apply_question_result(OPPONENT_ID, Question::CORRECT, Game::BONUS_TRUE, 6) }
  end

  # Testing mismatch question number and counter #

  test "apply_question_result raises_error_counter_mismatch_opponent_gets_7th_question_counter_5_bonus_true" do
    challenge = Challenge.new(id: 1, game_id: 1, challenger_id: CHALLENGER_ID, opponent_id: OPPONENT_ID, wager: Subject::ART, prize: Subject::ENTERTAINMENT,
                              winner_id: 0, challenger_correct: 0, opponent_correct: 0)
    challenge.generate_question_ids
    challenge.counter = 5
    assert_raises(RuntimeError) { challenge.apply_question_result(OPPONENT_ID, Question::CORRECT, Game::BONUS_TRUE, 7) }
  end

  test "apply_question_result raises_error_counter_mismatch_opponent_gets_7th_question_counter_8_bonus_true" do
    challenge = Challenge.new(id: 1, game_id: 1, challenger_id: CHALLENGER_ID, opponent_id: OPPONENT_ID, wager: Subject::ART, prize: Subject::ENTERTAINMENT,
                              winner_id: 0, challenger_correct: 0, opponent_correct: 0)
    challenge.generate_question_ids
    challenge.counter = 8
    assert_raises(RuntimeError) { challenge.apply_question_result(OPPONENT_ID, Question::CORRECT, Game::BONUS_TRUE, 7) }
  end

  ######## Testing nothing raised ########

  #### Testing OPPONENT_ID ####

  ## Testing Game::BONUS_TRUE ##

  test "apply_question_result nothing_raised_opponent_gets_7th_question_correct_bonus_true_6v6" do
    challenge = Challenge.new(id: 1, game_id: 1, challenger_id: CHALLENGER_ID, opponent_id: OPPONENT_ID, wager: Subject::ART, prize: Subject::ENTERTAINMENT,
                              winner_id: 0, challenger_correct: 6, opponent_correct: 6)
    challenge.generate_question_ids
    challenge.counter = 6
    assert_nothing_raised(RuntimeError) { challenge.apply_question_result(OPPONENT_ID, Question::CORRECT, Game::BONUS_TRUE, 7) }
  end

  test "apply_question_result nothing_raised_opponent_gets_7th_question_incorrect_bonus_true_6v6" do
    challenge = Challenge.new(id: 1, game_id: 1, challenger_id: CHALLENGER_ID, opponent_id: OPPONENT_ID, wager: Subject::ART, prize: Subject::ENTERTAINMENT,
                              winner_id: 0, challenger_correct: 6, opponent_correct: 6)
    challenge.generate_question_ids
    challenge.counter = 6
    assert_nothing_raised(RuntimeError) { challenge.apply_question_result(OPPONENT_ID, Question::INCORRECT, Game::BONUS_TRUE, 7) }
  end

  ######## Testing challenger_correct ########

  test "apply_question_result challenger_correct_should_be_1_1st_question_correct" do
    challenge = Challenge.new(id: 1, game_id: 1, challenger_id: CHALLENGER_ID, opponent_id: OPPONENT_ID, wager: Subject::ART, prize: Subject::ENTERTAINMENT,
                              winner_id: 0, challenger_correct: 0, opponent_correct: 0)
    challenge.generate_question_ids
    challenge.apply_question_result(CHALLENGER_ID, Question::CORRECT, Game::BONUS_FALSE, 1)
    assert_equal(1, challenge.challenger_correct)
  end

  test "apply_question_result challenger_correct_should_be_0_opponent_turn" do
    challenge = Challenge.new(id: 1, game_id: 1, challenger_id: CHALLENGER_ID, opponent_id: OPPONENT_ID, wager: Subject::ART, prize: Subject::ENTERTAINMENT,
                              winner_id: 0, challenger_correct: 0, opponent_correct: 0)
    challenge.generate_question_ids
    challenge.apply_question_result(OPPONENT_ID, Question::CORRECT, Game::BONUS_FALSE, 1)
    assert_equal(0, challenge.challenger_correct)
  end

  ######## Testing opponent_correct ########

  test "apply_question_result opponent_correct_should_be_0_challenger_turn" do
    challenge = Challenge.new(id: 1, game_id: 1, challenger_id: CHALLENGER_ID, opponent_id: OPPONENT_ID, wager: Subject::ART, prize: Subject::ENTERTAINMENT,
                              winner_id: 0, challenger_correct: 0, opponent_correct: 0)
    challenge.generate_question_ids
    challenge.apply_question_result(CHALLENGER_ID, Question::CORRECT, Game::BONUS_FALSE, 1)
    assert_equal(0, challenge.opponent_correct)
  end

  test "apply_question_result opponent_correct_should_be_1_1st_question_correct" do
    challenge = Challenge.new(id: 1, game_id: 1, challenger_id: CHALLENGER_ID, opponent_id: OPPONENT_ID, wager: Subject::ART, prize: Subject::ENTERTAINMENT,
                              winner_id: 0, challenger_correct: 0, opponent_correct: 0)
    challenge.generate_question_ids
    challenge.apply_question_result(OPPONENT_ID, Question::CORRECT, Game::BONUS_FALSE, 1)
    assert_equal(1, challenge.opponent_correct)
  end

  ######## Testing return value opponent_turn ########

  test "apply_question_result should_not_return_opponent_turn_opponent_bonus_question_correct" do
    challenge = Challenge.new(id: 1, game_id: 1, challenger_id: CHALLENGER_ID, opponent_id: OPPONENT_ID, wager: Subject::ART, prize: Subject::ENTERTAINMENT,
                              winner_id: 0, challenger_correct: 0, opponent_correct: 0)
    challenge.generate_question_ids
    challenge.counter = 6
    result = challenge.apply_question_result(OPPONENT_ID, Question::CORRECT, Game::BONUS_TRUE, 7)
    assert_not_equal(Challenge::RESULT_OPPONENT_TURN, result)
  end

  test "apply_question_result should_return_opponent_turn_challenger_6th_question_correct" do
    challenge = Challenge.new(id: 1, game_id: 1, challenger_id: CHALLENGER_ID, opponent_id: OPPONENT_ID, wager: Subject::ART, prize: Subject::ENTERTAINMENT,
                              winner_id: 0, challenger_correct: 5, opponent_correct: 0)
    challenge.generate_question_ids
    challenge.counter = 5
    result = challenge.apply_question_result(CHALLENGER_ID, Question::CORRECT, Game::BONUS_FALSE, 6)
    assert_equal(Challenge::RESULT_OPPONENT_TURN, result)
  end

  test "apply_question_result should_return_opponent_turn_challenger_6th_question_incorrect" do
    challenge = Challenge.new(id: 1, game_id: 1, challenger_id: CHALLENGER_ID, opponent_id: OPPONENT_ID, wager: Subject::ART, prize: Subject::ENTERTAINMENT,
                              winner_id: 0, challenger_correct: 5, opponent_correct: 0)
    challenge.generate_question_ids
    challenge.counter = 5
    result = challenge.apply_question_result(CHALLENGER_ID, Question::INCORRECT, Game::BONUS_FALSE, 6)
    assert_equal(Challenge::RESULT_OPPONENT_TURN, result)
  end

  ######## Testing return value tie ########

  test "apply_question_result should_not_return_tie_opponent_bonus_question_correct" do
    challenge = Challenge.new(id: 1, game_id: 1, challenger_id: CHALLENGER_ID, opponent_id: OPPONENT_ID, wager: Subject::ART, prize: Subject::ENTERTAINMENT,
                              winner_id: 0, challenger_correct: 0, opponent_correct: 0)
    challenge.generate_question_ids
    challenge.counter = 6
    result = challenge.apply_question_result(OPPONENT_ID, Question::CORRECT, Game::BONUS_TRUE, 7)
    assert_not_equal(Challenge::RESULT_TIE, result)
  end

  test "apply_question_result should_return_tie_opponent_6th_question_correct_6v6" do
    challenge = Challenge.new(id: 1, game_id: 1, challenger_id: CHALLENGER_ID, opponent_id: OPPONENT_ID, wager: Subject::ART, prize: Subject::ENTERTAINMENT,
                              winner_id: 0, challenger_correct: 6, opponent_correct: 5)
    challenge.generate_question_ids
    challenge.counter = 5
    result = challenge.apply_question_result(OPPONENT_ID, Question::CORRECT, Game::BONUS_FALSE, 6)
    assert_equal(Challenge::RESULT_TIE, result)
  end

  test "apply_question_result should_return_tie_opponent_6th_question_incorrect_0v0" do
    challenge = Challenge.new(id: 1, game_id: 1, challenger_id: CHALLENGER_ID, opponent_id: OPPONENT_ID, wager: Subject::ART, prize: Subject::ENTERTAINMENT,
                              winner_id: 0, challenger_correct: 0, opponent_correct: 0)
    challenge.generate_question_ids
    challenge.counter = 5
    result = challenge.apply_question_result(OPPONENT_ID, Question::INCORRECT, Game::BONUS_FALSE, 6)
    assert_equal(Challenge::RESULT_TIE, result)
  end

  test "apply_question_result should_return_tie_opponent_6th_question_incorrect_5v5_bonus_false" do
    challenge = Challenge.new(id: 1, game_id: 1, challenger_id: CHALLENGER_ID, opponent_id: OPPONENT_ID, wager: Subject::ART, prize: Subject::ENTERTAINMENT,
                              winner_id: 0, challenger_correct: 5, opponent_correct: 5)
    challenge.generate_question_ids
    challenge.counter = 5
    result = challenge.apply_question_result(OPPONENT_ID, Question::INCORRECT, Game::BONUS_FALSE, 6)
    assert_equal(Challenge::RESULT_TIE, result)
  end

  test "apply_question_result should_not_return_tie_opponent_6th_question_incorrect_1v0" do
    challenge = Challenge.new(id: 1, game_id: 1, challenger_id: CHALLENGER_ID, opponent_id: OPPONENT_ID, wager: Subject::ART, prize: Subject::ENTERTAINMENT,
                              winner_id: 0, challenger_correct: 1, opponent_correct: 0)
    challenge.generate_question_ids
    challenge.counter = 5
    result = challenge.apply_question_result(OPPONENT_ID, Question::INCORRECT, Game::BONUS_FALSE, 6)
    assert_not_equal(Challenge::RESULT_TIE, result)
  end

  test "apply_question_result should_not_return_tie_opponent_6th_question_incorrect_0v1" do
    challenge = Challenge.new(id: 1, game_id: 1, challenger_id: CHALLENGER_ID, opponent_id: OPPONENT_ID, wager: Subject::ART, prize: Subject::ENTERTAINMENT,
                              winner_id: 0, challenger_correct: 0, opponent_correct: 1)
    challenge.generate_question_ids
    challenge.counter = 5
    result = challenge.apply_question_result(OPPONENT_ID, Question::INCORRECT, Game::BONUS_FALSE, 6)
    assert_not_equal(Challenge::RESULT_TIE, result)
  end

  test "apply_question_result should_not_return_tie_opponent_6th_question_incorrect_6v1" do
    challenge = Challenge.new(id: 1, game_id: 1, challenger_id: CHALLENGER_ID, opponent_id: OPPONENT_ID, wager: Subject::ART, prize: Subject::ENTERTAINMENT,
                              winner_id: 0, challenger_correct: 6, opponent_correct: 1)
    challenge.generate_question_ids
    challenge.counter = 5
    result = challenge.apply_question_result(OPPONENT_ID, Question::INCORRECT, Game::BONUS_FALSE, 6)
    assert_not_equal(Challenge::RESULT_TIE, result)
  end

  test "apply_question_result should_not_return_tie_opponent_6th_question_incorrect_6v5" do
    challenge = Challenge.new(id: 1, game_id: 1, challenger_id: CHALLENGER_ID, opponent_id: OPPONENT_ID, wager: Subject::ART, prize: Subject::ENTERTAINMENT,
                              winner_id: 0, challenger_correct: 6, opponent_correct: 5)
    challenge.generate_question_ids
    challenge.counter = 5
    result = challenge.apply_question_result(OPPONENT_ID, Question::INCORRECT, Game::BONUS_FALSE, 6)
    assert_not_equal(Challenge::RESULT_TIE, result)
  end

  test "apply_question_result should_return_tie_opponent_6th_question_incorrect_5v5" do
    challenge = Challenge.new(id: 1, game_id: 1, challenger_id: CHALLENGER_ID, opponent_id: OPPONENT_ID, wager: Subject::ART, prize: Subject::ENTERTAINMENT,
                              winner_id: 0, challenger_correct: 5, opponent_correct: 5)
    challenge.generate_question_ids
    challenge.counter = 5
    result = challenge.apply_question_result(OPPONENT_ID, Question::INCORRECT, Game::BONUS_FALSE, 6)
    assert_equal(Challenge::RESULT_TIE, result)
  end

  ######## Testing return value winner ########

  test "apply_question_result should_return_winner_opponent_bonus_question_correct_0v0" do
    challenge = Challenge.new(id: 1, game_id: 1, challenger_id: CHALLENGER_ID, opponent_id: OPPONENT_ID, wager: Subject::ART, prize: Subject::ENTERTAINMENT,
                              winner_id: 0, challenger_correct: 0, opponent_correct: 0)
    challenge.generate_question_ids
    challenge.counter = 6
    result = challenge.apply_question_result(OPPONENT_ID, Question::CORRECT, Game::BONUS_TRUE, 7)
    assert_equal(Challenge::RESULT_WINNER, result)
  end

  test "apply_question_result should_return_winner_opponent_6th_question_incorrect_1v0" do
    challenge = Challenge.new(id: 1, game_id: 1, challenger_id: CHALLENGER_ID, opponent_id: OPPONENT_ID, wager: Subject::ART, prize: Subject::ENTERTAINMENT,
                              winner_id: 0, challenger_correct: 1, opponent_correct: 0)
    challenge.generate_question_ids
    challenge.counter = 5
    result = challenge.apply_question_result(OPPONENT_ID, Question::INCORRECT, Game::BONUS_FALSE, 6)
    assert_equal(Challenge::RESULT_WINNER, result)
  end

  test "apply_question_result should_return_winner_opponent_6th_question_incorrect_0v1" do
    challenge = Challenge.new(id: 1, game_id: 1, challenger_id: CHALLENGER_ID, opponent_id: OPPONENT_ID, wager: Subject::ART, prize: Subject::ENTERTAINMENT,
                              winner_id: 0, challenger_correct: 0, opponent_correct: 1)
    challenge.generate_question_ids
    challenge.counter = 5
    result = challenge.apply_question_result(OPPONENT_ID, Question::INCORRECT, Game::BONUS_FALSE, 6)
    assert_equal(Challenge::RESULT_WINNER, result)
  end

  test "apply_question_result should_return_winner_opponent_6th_question_incorrect_6v1" do
    challenge = Challenge.new(id: 1, game_id: 1, challenger_id: CHALLENGER_ID, opponent_id: OPPONENT_ID, wager: Subject::ART, prize: Subject::ENTERTAINMENT,
                              winner_id: 0, challenger_correct: 6, opponent_correct: 1)
    challenge.generate_question_ids
    challenge.counter = 5
    result = challenge.apply_question_result(OPPONENT_ID, Question::INCORRECT, Game::BONUS_FALSE, 6)
    assert_equal(Challenge::RESULT_WINNER, result)
  end

  test "apply_question_result should_return_winner_opponent_6th_question_incorrect_1v5" do
    challenge = Challenge.new(id: 1, game_id: 1, challenger_id: CHALLENGER_ID, opponent_id: OPPONENT_ID, wager: Subject::ART, prize: Subject::ENTERTAINMENT,
                              winner_id: 0, challenger_correct: 1, opponent_correct: 5)
    challenge.generate_question_ids
    challenge.counter = 5
    result = challenge.apply_question_result(OPPONENT_ID, Question::INCORRECT, Game::BONUS_FALSE, 6)
    assert_equal(Challenge::RESULT_WINNER, result)
  end

  test "apply_question_result should_return_winner_opponent_6th_question_incorrect_6v5" do
    challenge = Challenge.new(id: 1, game_id: 1, challenger_id: CHALLENGER_ID, opponent_id: OPPONENT_ID, wager: Subject::ART, prize: Subject::ENTERTAINMENT,
                              winner_id: 0, challenger_correct: 6, opponent_correct: 5)
    challenge.generate_question_ids
    challenge.counter = 5
    result = challenge.apply_question_result(OPPONENT_ID, Question::INCORRECT, Game::BONUS_FALSE, 6)
    assert_equal(Challenge::RESULT_WINNER, result)
  end

  ######## Testing winner_id ########

  #### With BONUS_TRUE ####

  test "apply_question_result winner_id_is_opponent_bonus_question_correct" do
    challenge = Challenge.new(id: 1, game_id: 1, challenger_id: CHALLENGER_ID, opponent_id: OPPONENT_ID, wager: Subject::ART, prize: Subject::ENTERTAINMENT,
                              winner_id: 0, challenger_correct: 0, opponent_correct: 0)
    challenge.generate_question_ids
    challenge.counter = 6
    challenge.apply_question_result(OPPONENT_ID, Question::CORRECT, Game::BONUS_TRUE, 7)
    assert_equal(OPPONENT_ID, challenge.winner_id)
  end

  test "apply_question_result winner_id_is_challenger_bonus_question_incorrect" do
    challenge = Challenge.new(id: 1, game_id: 1, challenger_id: CHALLENGER_ID, opponent_id: OPPONENT_ID, wager: Subject::ART, prize: Subject::ENTERTAINMENT,
                              winner_id: 0, challenger_correct: 0, opponent_correct: 0)
    challenge.generate_question_ids
    challenge.counter = 6
    challenge.apply_question_result(OPPONENT_ID, Question::INCORRECT, Game::BONUS_TRUE, 7)
    assert_equal(CHALLENGER_ID, challenge.winner_id)
  end

  #### With BONUS_FALSE ####

  #### Testing CHALLENGER_ID ####

  test "apply_question_result winner_id_is_challenger_id_1v0" do
    challenge = Challenge.new(id: 1, game_id: 1, challenger_id: CHALLENGER_ID, opponent_id: OPPONENT_ID, wager: Subject::ART, prize: Subject::ENTERTAINMENT,
                              winner_id: 0, challenger_correct: 1, opponent_correct: 0)
    challenge.generate_question_ids
    challenge.counter = 5
    challenge.apply_question_result(OPPONENT_ID, Question::INCORRECT, Game::BONUS_FALSE, 6)
    assert_equal(CHALLENGER_ID, challenge.winner_id)
  end

  test "apply_question_result winner_id_is_challenger_id_6v5" do
    challenge = Challenge.new(id: 1, game_id: 1, challenger_id: CHALLENGER_ID, opponent_id: OPPONENT_ID, wager: Subject::ART, prize: Subject::ENTERTAINMENT,
                              winner_id: 0, challenger_correct: 6, opponent_correct: 5)
    challenge.generate_question_ids
    challenge.counter = 5
    challenge.apply_question_result(OPPONENT_ID, Question::INCORRECT, Game::BONUS_FALSE, 6)
    assert_equal(CHALLENGER_ID, challenge.winner_id)
  end

  #### Testing OPPONENT_ID ####

  test "apply_question_result winner_id_is_opponent_id_0v1" do
    challenge = Challenge.new(id: 1, game_id: 1, challenger_id: CHALLENGER_ID, opponent_id: OPPONENT_ID, wager: Subject::ART, prize: Subject::ENTERTAINMENT,
                              winner_id: 0, challenger_correct: 0, opponent_correct: 0)
    challenge.generate_question_ids
    challenge.counter = 5
    challenge.apply_question_result(OPPONENT_ID, Question::CORRECT, Game::BONUS_FALSE, 6)
    assert_equal(OPPONENT_ID, challenge.winner_id)
  end

  test "apply_question_result winner_id_is_opponent_id_5v6" do
    challenge = Challenge.new(id: 1, game_id: 1, challenger_id: CHALLENGER_ID, opponent_id: OPPONENT_ID, wager: Subject::ART, prize: Subject::ENTERTAINMENT,
                              winner_id: 0, challenger_correct: 5, opponent_correct: 5)
    challenge.generate_question_ids
    challenge.counter = 5
    challenge.apply_question_result(OPPONENT_ID, Question::CORRECT, Game::BONUS_FALSE, 6)
    assert_equal(OPPONENT_ID, challenge.winner_id)
  end

  ######## Testing counter ########

  #### with CHALLENGER_ID ####

  test "apply_question_result counter_should_be_1_challenger_1st_question_correct" do
    challenge = Challenge.new(id: 1, game_id: 1, challenger_id: CHALLENGER_ID, opponent_id: OPPONENT_ID, wager: Subject::ART, prize: Subject::ENTERTAINMENT,
                              winner_id: 0, challenger_correct: 0, opponent_correct: 0)
    challenge.generate_question_ids
    challenge.apply_question_result(CHALLENGER_ID, Question::CORRECT, Game::BONUS_FALSE, 1)
    assert_equal(1, challenge.counter)
  end

  test "apply_question_result counter_should_be_2_challenger_questions_1-2_correct" do
    challenge = Challenge.new(id: 1, game_id: 1, challenger_id: CHALLENGER_ID, opponent_id: OPPONENT_ID, wager: Subject::ART, prize: Subject::ENTERTAINMENT,
                              winner_id: 0, challenger_correct: 0, opponent_correct: 0)
    challenge.generate_question_ids
    (1..2).each { |i| challenge.apply_question_result(CHALLENGER_ID, Question::CORRECT, Game::BONUS_FALSE, i) }
    assert_equal(2, challenge.counter)
  end

  test "apply_question_result counter_should_be_6_challenger_questions_1-6_correct" do
    challenge = Challenge.new(id: 1, game_id: 1, challenger_id: CHALLENGER_ID, opponent_id: OPPONENT_ID, wager: Subject::ART, prize: Subject::ENTERTAINMENT,
                              winner_id: 0, challenger_correct: 0, opponent_correct: 0)
    challenge.generate_question_ids
    (1..Challenge::MAX_NUM_QUESTIONS_CHALLENGER).each { |i| challenge.apply_question_result(CHALLENGER_ID, Question::CORRECT, Game::BONUS_FALSE, i) }
    assert_equal(Challenge::MAX_NUM_QUESTIONS_CHALLENGER, challenge.counter)
  end

  test "apply_question_result counter_should_be_6_challenger_questions_1-6_incorrect" do
    challenge = Challenge.new(id: 1, game_id: 1, challenger_id: CHALLENGER_ID, opponent_id: OPPONENT_ID, wager: Subject::ART, prize: Subject::ENTERTAINMENT,
                              winner_id: 0, challenger_correct: 0, opponent_correct: 0)
    challenge.generate_question_ids
    (1..Challenge::MAX_NUM_QUESTIONS_CHALLENGER).each { |i| challenge.apply_question_result(CHALLENGER_ID, Question::INCORRECT, Game::BONUS_FALSE, i) }
    assert_equal(Challenge::MAX_NUM_QUESTIONS_CHALLENGER, challenge.counter)
  end

  test "apply_question_result counter_should_be_6_challenger_questions_mixed_results" do
    challenge = Challenge.new(id: 1, game_id: 1, challenger_id: CHALLENGER_ID, opponent_id: OPPONENT_ID, wager: Subject::ART, prize: Subject::ENTERTAINMENT,
                              winner_id: 0, challenger_correct: 0, opponent_correct: 0)
    challenge.generate_question_ids
    (1..Challenge::MAX_NUM_QUESTIONS_CHALLENGER).each { |i|
      if i.even?
        challenge.apply_question_result(CHALLENGER_ID, Question::CORRECT, Game::BONUS_FALSE, i)
      end
      if i.odd?
        challenge.apply_question_result(CHALLENGER_ID, Question::INCORRECT, Game::BONUS_FALSE, i)
      end
    }
    assert_equal(Challenge::MAX_NUM_QUESTIONS_CHALLENGER, challenge.counter)
  end

  #### with OPPONENT_ID ####

  ## with Game::BONUS_FALSE ##

  test "apply_question_result counter_should_be_1_opponent_1st_question_correct" do
    challenge = Challenge.new(id: 1, game_id: 1, challenger_id: CHALLENGER_ID, opponent_id: OPPONENT_ID, wager: Subject::ART, prize: Subject::ENTERTAINMENT,
                              winner_id: 0, challenger_correct: 0, opponent_correct: 0)
    challenge.generate_question_ids
    challenge.apply_question_result(OPPONENT_ID, Question::CORRECT, Game::BONUS_FALSE, 1)
    assert_equal(1, challenge.counter)
  end

  test "apply_question_result counter_should_be_2_opponent_questions_1-2_correct" do
    challenge = Challenge.new(id: 1, game_id: 1, challenger_id: CHALLENGER_ID, opponent_id: OPPONENT_ID, wager: Subject::ART, prize: Subject::ENTERTAINMENT,
                              winner_id: 0, challenger_correct: 0, opponent_correct: 0)
    challenge.generate_question_ids
    (1..2).each { |i| challenge.apply_question_result(OPPONENT_ID, Question::CORRECT, Game::BONUS_FALSE, i) }
    assert_equal(2, challenge.counter)
  end

  test "apply_question_result counter_should_be_6_opponent_questions_1-6_correct" do
    challenge = Challenge.new(id: 1, game_id: 1, challenger_id: CHALLENGER_ID, opponent_id: OPPONENT_ID, wager: Subject::ART, prize: Subject::ENTERTAINMENT,
                              winner_id: 0, challenger_correct: 0, opponent_correct: 0)
    challenge.generate_question_ids
    (1..Challenge::MAX_NUM_QUESTIONS_NO_BONUS).each { |i| challenge.apply_question_result(OPPONENT_ID, Question::CORRECT, Game::BONUS_FALSE, i) }
    assert_equal(Challenge::MAX_NUM_QUESTIONS_NO_BONUS, challenge.counter)
  end

  test "apply_question_result counter_should_be_6_opponent_questions_1-6_incorrect" do
    challenge = Challenge.new(id: 1, game_id: 1, challenger_id: CHALLENGER_ID, opponent_id: OPPONENT_ID, wager: Subject::ART, prize: Subject::ENTERTAINMENT,
                              winner_id: 0, challenger_correct: 0, opponent_correct: 0)
    challenge.generate_question_ids
    (1..Challenge::MAX_NUM_QUESTIONS_NO_BONUS).each { |i| challenge.apply_question_result(OPPONENT_ID, Question::INCORRECT, Game::BONUS_FALSE, i) }
    assert_equal(Challenge::MAX_NUM_QUESTIONS_NO_BONUS, challenge.counter)
  end

  test "apply_question_result counter_should_be_6_opponent_questions_mixed_results" do
    challenge = Challenge.new(id: 1, game_id: 1, challenger_id: CHALLENGER_ID, opponent_id: OPPONENT_ID, wager: Subject::ART, prize: Subject::ENTERTAINMENT,
                              winner_id: 0, challenger_correct: 0, opponent_correct: 0)
    challenge.generate_question_ids
    (1..Challenge::MAX_NUM_QUESTIONS_NO_BONUS).each { |i|
      if i.even?
        challenge.apply_question_result(OPPONENT_ID, Question::CORRECT, Game::BONUS_FALSE, i)
      end
      if i.odd?
        challenge.apply_question_result(OPPONENT_ID, Question::INCORRECT, Game::BONUS_FALSE, i)
      end
    }
    assert_equal(Challenge::MAX_NUM_QUESTIONS_NO_BONUS, challenge.counter)
  end

  ## with Game::BONUS_TRUE ##

  test "apply_question_result counter_should_be_7_opponent_questions_mixed_results_bonus_round" do
    challenge = Challenge.new(id: 1, game_id: 1, challenger_id: CHALLENGER_ID, opponent_id: OPPONENT_ID, wager: Subject::ART, prize: Subject::ENTERTAINMENT,
                              winner_id: 0, challenger_correct: 0, opponent_correct: 0)
    challenge.generate_question_ids
    (1..Challenge::MAX_NUM_QUESTIONS_OPPONENT).each { |i|
      if i <= 2
        challenge.apply_question_result(OPPONENT_ID, Question::CORRECT, Game::BONUS_FALSE, i)
      end
      if i > 2 && i < Challenge::MAX_NUM_QUESTIONS_OPPONENT
        challenge.apply_question_result(OPPONENT_ID, Question::INCORRECT, Game::BONUS_FALSE, i)
      end
      if i == Challenge::MAX_NUM_QUESTIONS_OPPONENT
        challenge.apply_question_result(OPPONENT_ID, Question::INCORRECT, Game::BONUS_TRUE, i)
      end
    }
    assert_equal(Challenge::MAX_NUM_QUESTIONS_OPPONENT, challenge.counter)
  end

  ################################ get_total_correct ################################

  #### Testing CHALLENGER_ID ####

  test "get_total_correct is_0_using_challenger_id" do
    challenge = Challenge.new(id: 1, game_id: 1, challenger_id: CHALLENGER_ID, opponent_id: OPPONENT_ID, wager: Subject::ART, prize: Subject::ENTERTAINMENT,
                              winner_id: 0, challenger_correct: 0, opponent_correct: 0)
    challenge.generate_question_ids
    assert_equal(0, challenge.get_total_correct(CHALLENGER_ID))
  end

  test "get_total_correct is_6_using_challenger_id" do
    challenge = Challenge.new(id: 1, game_id: 1, challenger_id: CHALLENGER_ID, opponent_id: OPPONENT_ID, wager: Subject::ART, prize: Subject::ENTERTAINMENT,
                              winner_id: 0, challenger_correct: 6, opponent_correct: 0)
    challenge.generate_question_ids
    assert_equal(6, challenge.get_total_correct(CHALLENGER_ID))
  end

  test "get_total_correct is_not_opponent_correct_using_challenger_id" do
    challenge = Challenge.new(id: 1, game_id: 1, challenger_id: CHALLENGER_ID, opponent_id: OPPONENT_ID, wager: Subject::ART, prize: Subject::ENTERTAINMENT,
                              winner_id: 0, challenger_correct: 6, opponent_correct: 0)
    challenge.generate_question_ids
    assert_not_equal(challenge.opponent_correct, challenge.get_total_correct(CHALLENGER_ID))
  end

  #### Testing OPPONENT_ID ####

  test "get_total_correct is_0_opponent_id" do
    challenge = Challenge.new(id: 1, game_id: 1, challenger_id: CHALLENGER_ID, opponent_id: OPPONENT_ID, wager: Subject::ART, prize: Subject::ENTERTAINMENT,
                              winner_id: 0, challenger_correct: 0, opponent_correct: 0)
    challenge.generate_question_ids
    assert_equal(0, challenge.get_total_correct(OPPONENT_ID))
  end

  test "get_total_correct is_6_opponent_id" do
    challenge = Challenge.new(id: 1, game_id: 1, challenger_id: CHALLENGER_ID, opponent_id: OPPONENT_ID, wager: Subject::ART, prize: Subject::ENTERTAINMENT,
                              winner_id: 0, challenger_correct: 0, opponent_correct: 6)
    challenge.generate_question_ids
    assert_equal(6, challenge.get_total_correct(OPPONENT_ID))
  end

  test "get_total_correct is_not_challenger_correct_using_opponent_id" do
    challenge = Challenge.new(id: 1, game_id: 1, challenger_id: CHALLENGER_ID, opponent_id: OPPONENT_ID, wager: Subject::ART, prize: Subject::ENTERTAINMENT,
                              winner_id: 0, challenger_correct: 0, opponent_correct: 6)
    challenge.generate_question_ids
    assert_not_equal(challenge.challenger_correct, challenge.get_total_correct(OPPONENT_ID))
  end
end
