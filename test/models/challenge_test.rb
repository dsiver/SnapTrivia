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
    challenge.save
    assert_equal(true, true)
  end

  test "empty expression_should_be_false_question_ids_not_nil" do
    challenge = Challenge.new
    expression = challenge.art_id.nil? || challenge.ent_id.nil? || challenge.history_id.nil? || challenge.geo_id.nil? || challenge.science_id.nil? || challenge.sports_id.nil?
    assert_not(false, expression)
  end

  ################################################### Class Methods ###################################################

  ################################ create_challenge ################################

  test "raises_error game_id_should_not_be_zero" do
    assert_raises(RuntimeError){Challenge.create_challenge(0, CHALLENGER_ID, OPPONENT_ID, Subject::ART, Subject::ENTERTAINMENT)}
  end

  test "raises_error challenger_id_should_not_be_zero" do
    assert_raises(RuntimeError){Challenge.create_challenge(1, 0, OPPONENT_ID, Subject::ART, Subject::ENTERTAINMENT)}
  end

  test "raises_error opponent_id_should_not_be_zero" do
    assert_raises(RuntimeError){Challenge.create_challenge(1, CHALLENGER_ID, 0, Subject::ART, Subject::ENTERTAINMENT)}
  end

  test "raises_error wager_invalid" do
    assert_raises(RuntimeError){Challenge.create_challenge(1, CHALLENGER_ID, OPPONENT_ID, 'stuffandthings', Subject::ENTERTAINMENT)}
  end

  test "raises_error prize_invalid" do
    assert_raises(RuntimeError){Challenge.create_challenge(1, CHALLENGER_ID, OPPONENT_ID, Subject::ART, 'stuffandthings')}
  end

  test "create_challenge should_not_be_nil" do
    challenge = Challenge.create_challenge(1, CHALLENGER_ID, OPPONENT_ID, Subject::ART, Subject::ENTERTAINMENT)
    assert_not_equal(nil, challenge)
  end

  test "create_challenge game_id_should_be_1" do
    challenge = Challenge.create_challenge(1, CHALLENGER_ID, OPPONENT_ID, Subject::ART, Subject::ENTERTAINMENT)
    assert_equal(1, challenge.game_id)
  end

  test "create_challenge challenger_id_should_be_CHALLENGER_ID" do
    challenge = Challenge.create_challenge(1, CHALLENGER_ID, OPPONENT_ID, Subject::ART, Subject::ENTERTAINMENT)
    assert_equal(CHALLENGER_ID, challenge.challenger_id)
  end

  test "create_challenge opponent_id_should_be_OPPONENT_ID" do
    challenge = Challenge.create_challenge(1, CHALLENGER_ID, OPPONENT_ID, Subject::ART, Subject::ENTERTAINMENT)
    assert_equal(OPPONENT_ID, challenge.opponent_id)
  end

  test "create_challenge wager_should_be_art" do
    challenge = Challenge.create_challenge(1, CHALLENGER_ID, OPPONENT_ID, Subject::ART, Subject::ENTERTAINMENT)
    assert_equal(Subject::ART, challenge.wager)
  end

  test "create_challenge prize_should_be_ent" do
    challenge = Challenge.create_challenge(1, CHALLENGER_ID, OPPONENT_ID, Subject::ART, Subject::ENTERTAINMENT)
    assert_equal(Subject::ART, challenge.wager)
  end

  test "create_challenge question_ids_should_be_integers" do
    challenge = Challenge.create_challenge(1, CHALLENGER_ID, OPPONENT_ID, Subject::ART, Subject::ENTERTAINMENT)
    assert_equal(true, challenge.art_id.integer?)
    assert_equal(true, challenge.ent_id.integer?)
    assert_equal(true, challenge.history_id.integer?)
    assert_equal(true, challenge.geo_id.integer?)
    assert_equal(true, challenge.science_id.integer?)
    assert_equal(true, challenge.sports_id.integer?)
  end

  ################################ get_ongoing_challenge ################################

  test "get_ongoing_challenge" do
    challenge = Challenge.new(game_id: 1, challenger_id: CHALLENGER_ID, opponent_id: OPPONENT_ID, wager: Subject::ART, prize: Subject::ENTERTAINMENT,
                              winner_id: 0, challenger_correct: 0, opponent_correct: 0)
    challenge.save
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
    challenges.shuffle!
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
    challenges.shuffle!
    game_id = challenges.first.game_id
    assert_equal(challenges.first, Challenge.get_ongoing_challenge(game_id, CHALLENGER_ID, OPPONENT_ID))
  end

  test "get_ongoing_challenge should_return_correct_challenge_when_a_game_has_one_finished_challenge" do
    game_id = 1
    loop_index = 0
    challenge_to_find = Challenge.new
    challenges = []
    5.times {
      c = Challenge.new
      challenges << c
    }
    (0..1).each { |i|
      if i == loop_index
        challenges[i].update_attributes(game_id: game_id, challenger_id: CHALLENGER_ID, opponent_id: OPPONENT_ID, wager: Subject::ART, prize: Subject::ENTERTAINMENT,
                                        winner_id: 0, challenger_correct: 0, opponent_correct: 0)
        challenge_to_find = challenges[i]
      else
        challenges[i].update_attributes(game_id: game_id, challenger_id: CHALLENGER_ID, opponent_id: OPPONENT_ID, wager: Subject::ART, prize: Subject::ENTERTAINMENT,
                                        winner_id: CHALLENGER_ID, challenger_correct: 0, opponent_correct: 0)
      end
    }
    (2..challenges.count-1).each { |i|
      challenges[i].update_attributes(game_id: i+1, challenger_id: CHALLENGER_ID, opponent_id: OPPONENT_ID, wager: Subject::ART, prize: Subject::ENTERTAINMENT,
                                      winner_id: 0, challenger_correct: 0, opponent_correct: 0)
    }
    challenges.shuffle!
    assert_equal(challenge_to_find, Challenge.get_ongoing_challenge(game_id, CHALLENGER_ID, OPPONENT_ID))
  end

  test "get_ongoing_challenge should_return_correct_challenge_when_a_game_has_multiple_finished_challenges" do
    game_id = 1
    loop_index = 3
    challenge_to_find = Challenge.new
    challenges = []
    8.times {
      c = Challenge.new
      challenges << c
    }
    (0..4).each { |i|
      if i == loop_index
        challenges[i].update_attributes(game_id: game_id, challenger_id: CHALLENGER_ID, opponent_id: OPPONENT_ID, wager: Subject::ART, prize: Subject::ENTERTAINMENT,
                                        winner_id: 0, challenger_correct: 0, opponent_correct: 0)
        challenge_to_find = challenges[i]
      else
        challenges[i].update_attributes(game_id: game_id, challenger_id: CHALLENGER_ID, opponent_id: OPPONENT_ID, wager: Subject::ART, prize: Subject::ENTERTAINMENT,
                                        winner_id: CHALLENGER_ID, challenger_correct: 0, opponent_correct: 0)
      end
    }
    (5..challenges.count-1).each { |i|
      challenges[i].update_attributes(game_id: i+1, challenger_id: CHALLENGER_ID, opponent_id: OPPONENT_ID, wager: Subject::ART, prize: Subject::ENTERTAINMENT,
                                      winner_id: 0, challenger_correct: 0, opponent_correct: 0)
    }
    challenges.shuffle!
    game_id = challenge_to_find.game_id
    assert_equal(challenge_to_find, Challenge.get_ongoing_challenge(game_id, CHALLENGER_ID, OPPONENT_ID))
  end

  test "get_ongoing_challenge test" do
    count = 25
    stop = 10
    restart = 11
    game_id = 1
    loop_index = 0
    challenge_to_find = Challenge.new
    challenges = []
    count.times {
      c = Challenge.new
      challenges << c
    }
    assert_equal(count, challenges.count)
    assert_not_equal(true, challenges.any? { |c| c.nil?})
    (0..stop).each { |i|
      if i == loop_index
        challenges[i].update_attributes(game_id: game_id, challenger_id: CHALLENGER_ID, opponent_id: OPPONENT_ID, wager: Subject::ART, prize: Subject::ENTERTAINMENT,
                                        winner_id: 0, challenger_correct: 0, opponent_correct: 0)
        challenge_to_find = challenges[i]
      else
        challenges[i].update_attributes(game_id: game_id, challenger_id: CHALLENGER_ID, opponent_id: OPPONENT_ID, wager: Subject::ART, prize: Subject::ENTERTAINMENT,
                                        winner_id: CHALLENGER_ID, challenger_correct: 0, opponent_correct: 0)
      end
    }
    (restart..challenges.count-1).each { |i|
      challenges[i].update_attributes(game_id: i+1, challenger_id: CHALLENGER_ID, opponent_id: OPPONENT_ID, wager: Subject::ART, prize: Subject::ENTERTAINMENT,
                                      winner_id: 0, challenger_correct: 0, opponent_correct: 0)
    }
    challenges.shuffle!
    game_id = challenge_to_find.game_id
    assert_equal(challenge_to_find, Challenge.get_ongoing_challenge(game_id, CHALLENGER_ID, OPPONENT_ID))
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
    challenges.shuffle!
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
    challenges.shuffle!
    game_id = challenges.first.game_id
    assert_equal(challenges.first, Challenge.get_ongoing_challenge_by_game(game_id))
  end

  test "get_ongoing_challenge_by_game should_return_correct_challenge_when_a_game_has_one_finished_challenge" do
    game_id = 1
    loop_index = 0
    challenge_to_find = Challenge.new
    challenges = []
    5.times {
      c = Challenge.new
      challenges << c
    }
    (0..1).each { |i|
      if i == loop_index
        challenges[i].update_attributes(game_id: game_id, challenger_id: CHALLENGER_ID, opponent_id: OPPONENT_ID, wager: Subject::ART, prize: Subject::ENTERTAINMENT,
                                        winner_id: 0, challenger_correct: 0, opponent_correct: 0)
        challenge_to_find = challenges[i]
      else
        challenges[i].update_attributes(game_id: game_id, challenger_id: CHALLENGER_ID, opponent_id: OPPONENT_ID, wager: Subject::ART, prize: Subject::ENTERTAINMENT,
                                        winner_id: CHALLENGER_ID, challenger_correct: 0, opponent_correct: 0)
      end
    }
    (2..challenges.count-1).each { |i|
      challenges[i].update_attributes(game_id: i+1, challenger_id: CHALLENGER_ID, opponent_id: OPPONENT_ID, wager: Subject::ART, prize: Subject::ENTERTAINMENT,
                                      winner_id: 0, challenger_correct: 0, opponent_correct: 0)
    }
    challenges.shuffle!
    game_id = challenge_to_find.game_id
    assert_equal(challenge_to_find, Challenge.get_ongoing_challenge_by_game(game_id))
  end

  test "get_ongoing_challenge_by_game should_return_correct_challenge_when_a_game_has_multiple_finished_challenges" do
    game_id = 1
    loop_index = 0
    challenge_to_find = Challenge.new
    challenges = []
    8.times {
      c = Challenge.new
      challenges << c
    }
    (0..4).each { |i|
      if i == loop_index
        challenges[i].update_attributes(game_id: game_id, challenger_id: CHALLENGER_ID, opponent_id: OPPONENT_ID, wager: Subject::ART, prize: Subject::ENTERTAINMENT,
                                        winner_id: 0, challenger_correct: 0, opponent_correct: 0)
        challenge_to_find = challenges[i]
      else
        challenges[i].update_attributes(game_id: game_id, challenger_id: CHALLENGER_ID, opponent_id: OPPONENT_ID, wager: Subject::ART, prize: Subject::ENTERTAINMENT,
                                        winner_id: CHALLENGER_ID, challenger_correct: 0, opponent_correct: 0)
      end
    }
    (5..challenges.count-1).each { |i|
      challenges[i].update_attributes(game_id: i+1, challenger_id: CHALLENGER_ID, opponent_id: OPPONENT_ID, wager: Subject::ART, prize: Subject::ENTERTAINMENT,
                                      winner_id: 0, challenger_correct: 0, opponent_correct: 0)
    }
    challenges.shuffle!
    game_id = challenge_to_find.game_id
    assert_equal(challenge_to_find, Challenge.get_ongoing_challenge_by_game(game_id))
  end

  test "get_ongoing_challenge_by_game multiple_instances_should_be_same_challenge" do
    game_id = 1
    number_of_challenge_copies = 25
    challenge = Challenge.new(game_id: game_id, challenger_id: CHALLENGER_ID, opponent_id: OPPONENT_ID, wager: Subject::ART, prize: Subject::ENTERTAINMENT,
                              winner_id: 0, challenger_correct: 0, opponent_correct: 0)
    challenge.generate_question_ids
    challenge_question_ids = [challenge.art_id, challenge.ent_id, challenge.history_id, challenge.geo_id, challenge.science_id, challenge.sports_id]
    (1..number_of_challenge_copies).each {
      temp_challenge = Challenge::get_ongoing_challenge_by_game(game_id)
      temp_challenge_question_ids = [temp_challenge.art_id, temp_challenge.ent_id, temp_challenge.history_id, temp_challenge.geo_id, temp_challenge.science_id, temp_challenge.sports_id]
      assert_equal(challenge, temp_challenge)
      assert_equal(challenge_question_ids, temp_challenge_question_ids)
    }
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
    assert_raises(RuntimeError) { challenge.apply_question_result(CHALLENGER_ID, Question::CORRECT, Game::BONUS_TRUE) }
  end

  # Testing Question::INCORRECT #

  test "apply_question_result raises_error_challenger_gets_bonus_question_incorrect_bonus_true_0v0" do
    challenge = Challenge.new(id: 1, game_id: 1, challenger_id: CHALLENGER_ID, opponent_id: OPPONENT_ID, wager: Subject::ART, prize: Subject::ENTERTAINMENT,
                              winner_id: 0, challenger_correct: 0, opponent_correct: 0)
    challenge.generate_question_ids
    assert_raises(RuntimeError) { challenge.apply_question_result(CHALLENGER_ID, Question::INCORRECT, Game::BONUS_TRUE) }
  end

  ## Testing Game::BONUS_FALSE ##

  # Testing Question::CORRECT #

  test "apply_question_result raises_error_challenger_gets_7th_question_correct_bonus_false" do
    challenge = Challenge.new(id: 1, game_id: 1, challenger_id: CHALLENGER_ID, opponent_id: OPPONENT_ID, wager: Subject::ART, prize: Subject::ENTERTAINMENT,
                              winner_id: 0, challenger_correct: 0, opponent_correct: 0)
    challenge.generate_question_ids
    challenge.counter = 6
    assert_raises(RuntimeError) { challenge.apply_question_result(CHALLENGER_ID, Question::CORRECT, Game::BONUS_FALSE) }
  end

  # Testing Question::INCORRECT #

  test "apply_question_result raises_error_challenger_gets_7th_question_incorrect_bonus_false" do
    challenge = Challenge.new(id: 1, game_id: 1, challenger_id: CHALLENGER_ID, opponent_id: OPPONENT_ID, wager: Subject::ART, prize: Subject::ENTERTAINMENT,
                              winner_id: 0, challenger_correct: 0, opponent_correct: 0)
    challenge.generate_question_ids
    challenge.counter = 6
    assert_raises(RuntimeError) { challenge.apply_question_result(CHALLENGER_ID, Question::INCORRECT, Game::BONUS_FALSE) }
  end

  #### Testing OPPONENT_ID ####

  ## Testing Game::BONUS_FALSE ##

  # Testing Question::CORRECT #

  test "apply_question_result raises_error_opponent_gets_7th_question_correct_bonus_false_5v6" do
    challenge = Challenge.new(id: 1, game_id: 1, challenger_id: CHALLENGER_ID, opponent_id: OPPONENT_ID, wager: Subject::ART, prize: Subject::ENTERTAINMENT,
                              winner_id: 0, challenger_correct: 5, opponent_correct: 6)
    challenge.generate_question_ids
    challenge.counter = 6
    assert_raises(RuntimeError) { challenge.apply_question_result(OPPONENT_ID, Question::CORRECT, Game::BONUS_FALSE) }
  end

  test "apply_question_result raises_error_opponent_gets_7th_question_correct_bonus_false_5v5" do
    challenge = Challenge.new(id: 1, game_id: 1, challenger_id: CHALLENGER_ID, opponent_id: OPPONENT_ID, wager: Subject::ART, prize: Subject::ENTERTAINMENT,
                              winner_id: 0, challenger_correct: 5, opponent_correct: 5)
    challenge.generate_question_ids
    challenge.counter = 6
    assert_raises(RuntimeError) { challenge.apply_question_result(OPPONENT_ID, Question::CORRECT, Game::BONUS_FALSE) }
  end

  # Testing Question::INCORRECT #

  test "apply_question_result raises_error_opponent_gets_7th_question_correct_bonus_false_1v6" do
    challenge = Challenge.new(id: 1, game_id: 1, challenger_id: CHALLENGER_ID, opponent_id: OPPONENT_ID, wager: Subject::ART, prize: Subject::ENTERTAINMENT,
                              winner_id: 0, challenger_correct: 1, opponent_correct: 6)
    challenge.generate_question_ids
    challenge.counter = 6
    assert_raises(RuntimeError) { challenge.apply_question_result(OPPONENT_ID, Question::INCORRECT, Game::BONUS_FALSE) }
  end

  test "apply_question_result raises_error_opponent_gets_7th_question_incorrect_bonus_false_5v6" do
    challenge = Challenge.new(id: 1, game_id: 1, challenger_id: CHALLENGER_ID, opponent_id: OPPONENT_ID, wager: Subject::ART, prize: Subject::ENTERTAINMENT,
                              winner_id: 0, challenger_correct: 5, opponent_correct: 6)
    challenge.generate_question_ids
    challenge.counter = 6
    assert_raises(RuntimeError) { challenge.apply_question_result(OPPONENT_ID, Question::INCORRECT, Game::BONUS_FALSE) }
  end

  test "apply_question_result raises_error_opponent_gets_7th_question_incorrect_bonus_false_5v5" do
    challenge = Challenge.new(id: 1, game_id: 1, challenger_id: CHALLENGER_ID, opponent_id: OPPONENT_ID, wager: Subject::ART, prize: Subject::ENTERTAINMENT,
                              winner_id: 0, challenger_correct: 5, opponent_correct: 5)
    challenge.generate_question_ids
    challenge.counter = 6
    assert_raises(RuntimeError) { challenge.apply_question_result(OPPONENT_ID, Question::INCORRECT, Game::BONUS_FALSE) }
  end

  ## Testing Game::BONUS_TRUE ##

  test "apply_question_result raises_error_opponent_gets_8th_question_incorrect_bonus_true" do
    challenge = Challenge.new(id: 1, game_id: 1, challenger_id: CHALLENGER_ID, opponent_id: OPPONENT_ID, wager: Subject::ART, prize: Subject::ENTERTAINMENT,
                              winner_id: 0, challenger_correct: 0, opponent_correct: 0)
    challenge.generate_question_ids
    challenge.counter = 7
    assert_raises(RuntimeError) { challenge.apply_question_result(OPPONENT_ID, Question::INCORRECT, Game::BONUS_TRUE) }
  end

  test "apply_question_result raises_error_opponent_gets_6th_question_correct_bonus_true" do
    challenge = Challenge.new(id: 1, game_id: 1, challenger_id: CHALLENGER_ID, opponent_id: OPPONENT_ID, wager: Subject::ART, prize: Subject::ENTERTAINMENT,
                              winner_id: 0, challenger_correct: 0, opponent_correct: 0)
    challenge.generate_question_ids
    challenge.counter = 5
    assert_raises(RuntimeError) { challenge.apply_question_result(OPPONENT_ID, Question::CORRECT, Game::BONUS_TRUE) }
  end

  # Testing mismatch question number and counter #

  test "apply_question_result raises_error_counter_mismatch_opponent_gets_7th_question_counter_5_bonus_true" do
    challenge = Challenge.new(id: 1, game_id: 1, challenger_id: CHALLENGER_ID, opponent_id: OPPONENT_ID, wager: Subject::ART, prize: Subject::ENTERTAINMENT,
                              winner_id: 0, challenger_correct: 0, opponent_correct: 0)
    challenge.generate_question_ids
    challenge.counter = 5
    assert_raises(RuntimeError) { challenge.apply_question_result(OPPONENT_ID, Question::CORRECT, Game::BONUS_TRUE) }
  end

  test "apply_question_result raises_error_counter_mismatch_opponent_gets_7th_question_counter_8_bonus_true" do
    challenge = Challenge.new(id: 1, game_id: 1, challenger_id: CHALLENGER_ID, opponent_id: OPPONENT_ID, wager: Subject::ART, prize: Subject::ENTERTAINMENT,
                              winner_id: 0, challenger_correct: 0, opponent_correct: 0)
    challenge.generate_question_ids
    challenge.counter = 8
    assert_raises(RuntimeError) { challenge.apply_question_result(OPPONENT_ID, Question::CORRECT, Game::BONUS_TRUE) }
  end

  ######## Testing nothing raised ########

  #### Testing OPPONENT_ID ####

  ## Testing Game::BONUS_TRUE ##

  test "apply_question_result nothing_raised_opponent_gets_7th_question_correct_bonus_true_6v6" do
    challenge = Challenge.new(id: 1, game_id: 1, challenger_id: CHALLENGER_ID, opponent_id: OPPONENT_ID, wager: Subject::ART, prize: Subject::ENTERTAINMENT,
                              winner_id: 0, challenger_correct: 6, opponent_correct: 6)
    challenge.generate_question_ids
    challenge.counter = 6
    assert_nothing_raised(RuntimeError) { challenge.apply_question_result(OPPONENT_ID, Question::CORRECT, Game::BONUS_TRUE) }
  end

  test "apply_question_result nothing_raised_opponent_gets_7th_question_incorrect_bonus_true_6v6" do
    challenge = Challenge.new(id: 1, game_id: 1, challenger_id: CHALLENGER_ID, opponent_id: OPPONENT_ID, wager: Subject::ART, prize: Subject::ENTERTAINMENT,
                              winner_id: 0, challenger_correct: 6, opponent_correct: 6)
    challenge.generate_question_ids
    challenge.counter = 6
    assert_nothing_raised(RuntimeError) { challenge.apply_question_result(OPPONENT_ID, Question::INCORRECT, Game::BONUS_TRUE) }
  end

  ######## Testing challenger_correct ########

  test "apply_question_result challenger_correct_should_be_1_1st_question_correct" do
    challenge = Challenge.new(id: 1, game_id: 1, challenger_id: CHALLENGER_ID, opponent_id: OPPONENT_ID, wager: Subject::ART, prize: Subject::ENTERTAINMENT,
                              winner_id: 0, challenger_correct: 0, opponent_correct: 0)
    challenge.generate_question_ids
    challenge.apply_question_result(CHALLENGER_ID, Question::CORRECT, Game::BONUS_FALSE)
    assert_equal(1, challenge.challenger_correct)
  end

  test "apply_question_result challenger_correct_should_be_0_opponent_turn" do
    challenge = Challenge.new(id: 1, game_id: 1, challenger_id: CHALLENGER_ID, opponent_id: OPPONENT_ID, wager: Subject::ART, prize: Subject::ENTERTAINMENT,
                              winner_id: 0, challenger_correct: 0, opponent_correct: 0)
    challenge.generate_question_ids
    challenge.apply_question_result(OPPONENT_ID, Question::CORRECT, Game::BONUS_FALSE)
    assert_equal(0, challenge.challenger_correct)
  end

  ######## Testing opponent_correct ########

  test "apply_question_result opponent_correct_should_be_0_challenger_turn" do
    challenge = Challenge.new(id: 1, game_id: 1, challenger_id: CHALLENGER_ID, opponent_id: OPPONENT_ID, wager: Subject::ART, prize: Subject::ENTERTAINMENT,
                              winner_id: 0, challenger_correct: 0, opponent_correct: 0)
    challenge.generate_question_ids
    challenge.apply_question_result(CHALLENGER_ID, Question::CORRECT, Game::BONUS_FALSE)
    assert_equal(0, challenge.opponent_correct)
  end

  test "apply_question_result opponent_correct_should_be_1_1st_question_correct" do
    challenge = Challenge.new(id: 1, game_id: 1, challenger_id: CHALLENGER_ID, opponent_id: OPPONENT_ID, wager: Subject::ART, prize: Subject::ENTERTAINMENT,
                              winner_id: 0, challenger_correct: 0, opponent_correct: 0)
    challenge.generate_question_ids
    challenge.apply_question_result(OPPONENT_ID, Question::CORRECT, Game::BONUS_FALSE)
    assert_equal(1, challenge.opponent_correct)
  end

  ######## Testing return value opponent_turn ########

  test "apply_question_result should_not_return_opponent_turn_opponent_bonus_question_correct" do
    challenge = Challenge.new(id: 1, game_id: 1, challenger_id: CHALLENGER_ID, opponent_id: OPPONENT_ID, wager: Subject::ART, prize: Subject::ENTERTAINMENT,
                              winner_id: 0, challenger_correct: 0, opponent_correct: 0)
    challenge.generate_question_ids
    challenge.counter = 6
    result = challenge.apply_question_result(OPPONENT_ID, Question::CORRECT, Game::BONUS_TRUE)
    assert_not_equal(Challenge::RESULT_OPPONENT_TURN, result)
  end

  test "apply_question_result should_return_opponent_turn_challenger_6th_question_correct" do
    challenge = Challenge.new(id: 1, game_id: 1, challenger_id: CHALLENGER_ID, opponent_id: OPPONENT_ID, wager: Subject::ART, prize: Subject::ENTERTAINMENT,
                              winner_id: 0, challenger_correct: 5, opponent_correct: 0)
    challenge.generate_question_ids
    challenge.counter = 5
    result = challenge.apply_question_result(CHALLENGER_ID, Question::CORRECT, Game::BONUS_FALSE)
    assert_equal(Challenge::RESULT_OPPONENT_TURN, result)
  end

  test "apply_question_result should_return_opponent_turn_challenger_6th_question_incorrect" do
    challenge = Challenge.new(id: 1, game_id: 1, challenger_id: CHALLENGER_ID, opponent_id: OPPONENT_ID, wager: Subject::ART, prize: Subject::ENTERTAINMENT,
                              winner_id: 0, challenger_correct: 5, opponent_correct: 0)
    challenge.generate_question_ids
    challenge.counter = 5

    result = challenge.apply_question_result(CHALLENGER_ID, Question::INCORRECT, Game::BONUS_FALSE)
    assert_equal(Challenge::RESULT_OPPONENT_TURN, result)
  end

  ######## Testing return value tie ########

  test "apply_question_result should_not_return_tie_opponent_bonus_question_correct" do
    challenge = Challenge.new(id: 1, game_id: 1, challenger_id: CHALLENGER_ID, opponent_id: OPPONENT_ID, wager: Subject::ART, prize: Subject::ENTERTAINMENT,
                              winner_id: 0, challenger_correct: 0, opponent_correct: 0)
    challenge.generate_question_ids
    challenge.counter = 6
    result = challenge.apply_question_result(OPPONENT_ID, Question::CORRECT, Game::BONUS_TRUE)
    assert_not_equal(Challenge::RESULT_TIE, result)
  end

  test "apply_question_result should_return_tie_opponent_6th_question_correct_6v6" do
    challenge = Challenge.new(id: 1, game_id: 1, challenger_id: CHALLENGER_ID, opponent_id: OPPONENT_ID, wager: Subject::ART, prize: Subject::ENTERTAINMENT,
                              winner_id: 0, challenger_correct: 6, opponent_correct: 5)
    challenge.generate_question_ids
    challenge.counter = 5
    result = challenge.apply_question_result(OPPONENT_ID, Question::CORRECT, Game::BONUS_FALSE)
    assert_equal(Challenge::RESULT_TIE, result)
  end

  test "apply_question_result should_return_tie_opponent_6th_question_incorrect_0v0" do
    challenge = Challenge.new(id: 1, game_id: 1, challenger_id: CHALLENGER_ID, opponent_id: OPPONENT_ID, wager: Subject::ART, prize: Subject::ENTERTAINMENT,
                              winner_id: 0, challenger_correct: 0, opponent_correct: 0)
    challenge.generate_question_ids
    challenge.counter = 5
    result = challenge.apply_question_result(OPPONENT_ID, Question::INCORRECT, Game::BONUS_FALSE)
    assert_equal(Challenge::RESULT_TIE, result)
  end

  test "apply_question_result should_return_tie_opponent_6th_question_incorrect_5v5_bonus_false" do
    challenge = Challenge.new(id: 1, game_id: 1, challenger_id: CHALLENGER_ID, opponent_id: OPPONENT_ID, wager: Subject::ART, prize: Subject::ENTERTAINMENT,
                              winner_id: 0, challenger_correct: 5, opponent_correct: 5)
    challenge.generate_question_ids
    challenge.counter = 5
    result = challenge.apply_question_result(OPPONENT_ID, Question::INCORRECT, Game::BONUS_FALSE)
    assert_equal(Challenge::RESULT_TIE, result)
  end

  test "apply_question_result should_not_return_tie_opponent_6th_question_incorrect_1v0" do
    challenge = Challenge.new(id: 1, game_id: 1, challenger_id: CHALLENGER_ID, opponent_id: OPPONENT_ID, wager: Subject::ART, prize: Subject::ENTERTAINMENT,
                              winner_id: 0, challenger_correct: 1, opponent_correct: 0)
    challenge.generate_question_ids
    challenge.counter = 5
    result = challenge.apply_question_result(OPPONENT_ID, Question::INCORRECT, Game::BONUS_FALSE)
    assert_not_equal(Challenge::RESULT_TIE, result)
  end

  test "apply_question_result should_not_return_tie_opponent_6th_question_incorrect_0v1" do
    challenge = Challenge.new(id: 1, game_id: 1, challenger_id: CHALLENGER_ID, opponent_id: OPPONENT_ID, wager: Subject::ART, prize: Subject::ENTERTAINMENT,
                              winner_id: 0, challenger_correct: 0, opponent_correct: 1)
    challenge.generate_question_ids
    challenge.counter = 5
    result = challenge.apply_question_result(OPPONENT_ID, Question::INCORRECT, Game::BONUS_FALSE)
    assert_not_equal(Challenge::RESULT_TIE, result)
  end

  test "apply_question_result should_not_return_tie_opponent_6th_question_incorrect_6v1" do
    challenge = Challenge.new(id: 1, game_id: 1, challenger_id: CHALLENGER_ID, opponent_id: OPPONENT_ID, wager: Subject::ART, prize: Subject::ENTERTAINMENT,
                              winner_id: 0, challenger_correct: 6, opponent_correct: 1)
    challenge.generate_question_ids
    challenge.counter = 5
    result = challenge.apply_question_result(OPPONENT_ID, Question::INCORRECT, Game::BONUS_FALSE)
    assert_not_equal(Challenge::RESULT_TIE, result)
  end

  test "apply_question_result should_not_return_tie_opponent_6th_question_incorrect_6v5" do
    challenge = Challenge.new(id: 1, game_id: 1, challenger_id: CHALLENGER_ID, opponent_id: OPPONENT_ID, wager: Subject::ART, prize: Subject::ENTERTAINMENT,
                              winner_id: 0, challenger_correct: 6, opponent_correct: 5)
    challenge.generate_question_ids
    challenge.counter = 5
    result = challenge.apply_question_result(OPPONENT_ID, Question::INCORRECT, Game::BONUS_FALSE)
    assert_not_equal(Challenge::RESULT_TIE, result)
  end

  test "apply_question_result should_return_tie_opponent_6th_question_incorrect_5v5" do
    challenge = Challenge.new(id: 1, game_id: 1, challenger_id: CHALLENGER_ID, opponent_id: OPPONENT_ID, wager: Subject::ART, prize: Subject::ENTERTAINMENT,
                              winner_id: 0, challenger_correct: 5, opponent_correct: 5)
    challenge.generate_question_ids
    challenge.counter = 5
    result = challenge.apply_question_result(OPPONENT_ID, Question::INCORRECT, Game::BONUS_FALSE)
    assert_equal(Challenge::RESULT_TIE, result)
  end

  ######## Testing return value winner ########

  test "apply_question_result should_return_winner_opponent_bonus_question_correct_0v0" do
    challenge = Challenge.new(id: 1, game_id: 1, challenger_id: CHALLENGER_ID, opponent_id: OPPONENT_ID, wager: Subject::ART, prize: Subject::ENTERTAINMENT,
                              winner_id: 0, challenger_correct: 0, opponent_correct: 0)
    challenge.generate_question_ids
    challenge.counter = 6
    result = challenge.apply_question_result(OPPONENT_ID, Question::CORRECT, Game::BONUS_TRUE)
    assert_equal(Challenge::RESULT_WINNER, result)
  end

  test "apply_question_result should_return_winner_opponent_6th_question_incorrect_1v0" do
    challenge = Challenge.new(id: 1, game_id: 1, challenger_id: CHALLENGER_ID, opponent_id: OPPONENT_ID, wager: Subject::ART, prize: Subject::ENTERTAINMENT,
                              winner_id: 0, challenger_correct: 1, opponent_correct: 0)
    challenge.generate_question_ids
    challenge.counter = 5
    result = challenge.apply_question_result(OPPONENT_ID, Question::INCORRECT, Game::BONUS_FALSE)
    assert_equal(Challenge::RESULT_WINNER, result)
  end

  test "apply_question_result should_return_winner_opponent_6th_question_incorrect_0v1" do
    challenge = Challenge.new(id: 1, game_id: 1, challenger_id: CHALLENGER_ID, opponent_id: OPPONENT_ID, wager: Subject::ART, prize: Subject::ENTERTAINMENT,
                              winner_id: 0, challenger_correct: 0, opponent_correct: 1)
    challenge.generate_question_ids
    challenge.counter = 5
    result = challenge.apply_question_result(OPPONENT_ID, Question::INCORRECT, Game::BONUS_FALSE)
    assert_equal(Challenge::RESULT_WINNER, result)
  end

  test "apply_question_result should_return_winner_opponent_6th_question_incorrect_6v1" do
    challenge = Challenge.new(id: 1, game_id: 1, challenger_id: CHALLENGER_ID, opponent_id: OPPONENT_ID, wager: Subject::ART, prize: Subject::ENTERTAINMENT,
                              winner_id: 0, challenger_correct: 6, opponent_correct: 1)
    challenge.generate_question_ids
    challenge.counter = 5
    result = challenge.apply_question_result(OPPONENT_ID, Question::INCORRECT, Game::BONUS_FALSE)
    assert_equal(Challenge::RESULT_WINNER, result)
  end

  test "apply_question_result should_return_winner_opponent_6th_question_incorrect_1v5" do
    challenge = Challenge.new(id: 1, game_id: 1, challenger_id: CHALLENGER_ID, opponent_id: OPPONENT_ID, wager: Subject::ART, prize: Subject::ENTERTAINMENT,
                              winner_id: 0, challenger_correct: 1, opponent_correct: 5)
    challenge.generate_question_ids
    challenge.counter = 5
    result = challenge.apply_question_result(OPPONENT_ID, Question::INCORRECT, Game::BONUS_FALSE)
    assert_equal(Challenge::RESULT_WINNER, result)
  end

  test "apply_question_result should_return_winner_opponent_6th_question_incorrect_6v5" do
    challenge = Challenge.new(id: 1, game_id: 1, challenger_id: CHALLENGER_ID, opponent_id: OPPONENT_ID, wager: Subject::ART, prize: Subject::ENTERTAINMENT,
                              winner_id: 0, challenger_correct: 6, opponent_correct: 5)
    challenge.generate_question_ids
    challenge.counter = 5
    result = challenge.apply_question_result(OPPONENT_ID, Question::INCORRECT, Game::BONUS_FALSE)
    assert_equal(Challenge::RESULT_WINNER, result)
  end

  ######## Testing winner_id ########

  #### With BONUS_TRUE ####

  test "apply_question_result winner_id_is_opponent_bonus_question_correct" do
    challenge = Challenge.new(id: 1, game_id: 1, challenger_id: CHALLENGER_ID, opponent_id: OPPONENT_ID, wager: Subject::ART, prize: Subject::ENTERTAINMENT,
                              winner_id: 0, challenger_correct: 0, opponent_correct: 0)
    challenge.generate_question_ids
    challenge.counter = 6
    challenge.save!
    challenge.apply_question_result(OPPONENT_ID, Question::CORRECT, Game::BONUS_TRUE)
    assert_equal(OPPONENT_ID, challenge.winner_id)
  end

  test "apply_question_result winner_id_is_challenger_bonus_question_incorrect" do
    challenge = Challenge.new(id: 1, game_id: 1, challenger_id: CHALLENGER_ID, opponent_id: OPPONENT_ID, wager: Subject::ART, prize: Subject::ENTERTAINMENT,
                              winner_id: 0, challenger_correct: 0, opponent_correct: 0)
    challenge.generate_question_ids
    challenge.counter = 6
    challenge.apply_question_result(OPPONENT_ID, Question::INCORRECT, Game::BONUS_TRUE)
    assert_equal(CHALLENGER_ID, challenge.winner_id)
  end

  #### With BONUS_FALSE ####

  #### Testing CHALLENGER_ID ####

  test "apply_question_result winner_id_is_challenger_id_1v0" do
    challenge = Challenge.new(id: 1, game_id: 1, challenger_id: CHALLENGER_ID, opponent_id: OPPONENT_ID, wager: Subject::ART, prize: Subject::ENTERTAINMENT,
                              winner_id: 0, challenger_correct: 1, opponent_correct: 0)
    challenge.generate_question_ids
    challenge.counter = 5
    challenge.apply_question_result(OPPONENT_ID, Question::INCORRECT, Game::BONUS_FALSE)
    assert_equal(CHALLENGER_ID, challenge.winner_id)
  end

  test "apply_question_result winner_id_is_challenger_id_6v5" do
    challenge = Challenge.new(id: 1, game_id: 1, challenger_id: CHALLENGER_ID, opponent_id: OPPONENT_ID, wager: Subject::ART, prize: Subject::ENTERTAINMENT,
                              winner_id: 0, challenger_correct: 6, opponent_correct: 5)
    challenge.generate_question_ids
    challenge.counter = 5
    challenge.apply_question_result(OPPONENT_ID, Question::INCORRECT, Game::BONUS_FALSE)
    assert_equal(CHALLENGER_ID, challenge.winner_id)
  end

  #### Testing OPPONENT_ID ####

  test "apply_question_result winner_id_is_opponent_id_0v1" do
    challenge = Challenge.new(id: 1, game_id: 1, challenger_id: CHALLENGER_ID, opponent_id: OPPONENT_ID, wager: Subject::ART, prize: Subject::ENTERTAINMENT,
                              winner_id: 0, challenger_correct: 0, opponent_correct: 0)
    challenge.generate_question_ids
    challenge.counter = 5
    challenge.save!
    challenge.apply_question_result(OPPONENT_ID, Question::CORRECT, Game::BONUS_FALSE)
    assert_equal(1, challenge.opponent_correct)
    assert_equal(6, challenge.counter)
    assert_equal(OPPONENT_ID, challenge.winner_id)
  end

  test "apply_question_result winner_id_is_opponent_id_5v6" do
    challenge = Challenge.new(id: 1, game_id: 1, challenger_id: CHALLENGER_ID, opponent_id: OPPONENT_ID, wager: Subject::ART, prize: Subject::ENTERTAINMENT,
                              winner_id: 0, challenger_correct: 5, opponent_correct: 5)
    challenge.generate_question_ids
    challenge.counter = 5
    challenge.apply_question_result(OPPONENT_ID, Question::CORRECT, Game::BONUS_FALSE)
    assert_equal(OPPONENT_ID, challenge.winner_id)
  end

  ######## Testing counter ########

  #### with CHALLENGER_ID ####

  test "apply_question_result counter_should_be_1_challenger_1st_question_correct" do
    challenge = Challenge.new(id: 1, game_id: 1, challenger_id: CHALLENGER_ID, opponent_id: OPPONENT_ID, wager: Subject::ART, prize: Subject::ENTERTAINMENT,
                              winner_id: 0, challenger_correct: 0, opponent_correct: 0)
    challenge.generate_question_ids
    challenge.apply_question_result(CHALLENGER_ID, Question::CORRECT, Game::BONUS_FALSE)
    assert_equal(1, challenge.counter)
  end

  test "apply_question_result counter_should_be_2_challenger_questions_1-2_correct" do
    challenge = Challenge.new(id: 1, game_id: 1, challenger_id: CHALLENGER_ID, opponent_id: OPPONENT_ID, wager: Subject::ART, prize: Subject::ENTERTAINMENT,
                              winner_id: 0, challenger_correct: 0, opponent_correct: 0)
    challenge.generate_question_ids
    (1..2).each {  challenge.apply_question_result(CHALLENGER_ID, Question::CORRECT, Game::BONUS_FALSE) }
    assert_equal(2, challenge.counter)
  end

  test "apply_question_result counter_should_be_0_challenger_questions_1-6_correct" do
    challenge = Challenge.new(id: 1, game_id: 1, challenger_id: CHALLENGER_ID, opponent_id: OPPONENT_ID, wager: Subject::ART, prize: Subject::ENTERTAINMENT,
                              winner_id: 0, challenger_correct: 0, opponent_correct: 0)
    challenge.generate_question_ids
    (1..Challenge::MAX_NUM_QUESTIONS_CHALLENGER).each {  challenge.apply_question_result(CHALLENGER_ID, Question::CORRECT, Game::BONUS_FALSE) }
    assert_equal(0, challenge.counter)
  end

  test "apply_question_result counter_should_be_0_challenger_questions_1-6_incorrect" do
    challenge = Challenge.new(id: 1, game_id: 1, challenger_id: CHALLENGER_ID, opponent_id: OPPONENT_ID, wager: Subject::ART, prize: Subject::ENTERTAINMENT,
                              winner_id: 0, challenger_correct: 0, opponent_correct: 0)
    challenge.generate_question_ids
    (1..Challenge::MAX_NUM_QUESTIONS_CHALLENGER).each {  challenge.apply_question_result(CHALLENGER_ID, Question::INCORRECT, Game::BONUS_FALSE) }
    assert_equal(0, challenge.counter)
  end

  test "apply_question_result counter_should_be_0_challenger_questions_mixed_results" do
    challenge = Challenge.new(id: 1, game_id: 1, challenger_id: CHALLENGER_ID, opponent_id: OPPONENT_ID, wager: Subject::ART, prize: Subject::ENTERTAINMENT,
                              winner_id: 0, challenger_correct: 0, opponent_correct: 0)
    challenge.generate_question_ids
    (1..Challenge::MAX_NUM_QUESTIONS_CHALLENGER).each { |i|
      if i.even?
        challenge.apply_question_result(CHALLENGER_ID, Question::CORRECT, Game::BONUS_FALSE)
      end
      if i.odd?
        challenge.apply_question_result(CHALLENGER_ID, Question::INCORRECT, Game::BONUS_FALSE)
      end
    }
    assert_equal(0, challenge.counter)
  end

  #### with OPPONENT_ID ####

  ## with Game::BONUS_FALSE ##

  test "apply_question_result counter_should_be_1_opponent_1st_question_correct" do
    challenge = Challenge.new(id: 1, game_id: 1, challenger_id: CHALLENGER_ID, opponent_id: OPPONENT_ID, wager: Subject::ART, prize: Subject::ENTERTAINMENT,
                              winner_id: 0, challenger_correct: 0, opponent_correct: 0)
    challenge.generate_question_ids
    challenge.apply_question_result(OPPONENT_ID, Question::CORRECT, Game::BONUS_FALSE)
    assert_equal(1, challenge.counter)
  end

  test "apply_question_result counter_should_be_2_opponent_questions_1-2_correct" do
    challenge = Challenge.new(id: 1, game_id: 1, challenger_id: CHALLENGER_ID, opponent_id: OPPONENT_ID, wager: Subject::ART, prize: Subject::ENTERTAINMENT,
                              winner_id: 0, challenger_correct: 0, opponent_correct: 0)
    challenge.generate_question_ids
    (1..2).each {  challenge.apply_question_result(OPPONENT_ID, Question::CORRECT, Game::BONUS_FALSE) }
    assert_equal(2, challenge.counter)
  end

  test "apply_question_result counter_should_be_6_opponent_questions_1-6_correct" do
    challenge = Challenge.new(id: 1, game_id: 1, challenger_id: CHALLENGER_ID, opponent_id: OPPONENT_ID, wager: Subject::ART, prize: Subject::ENTERTAINMENT,
                              winner_id: 0, challenger_correct: 0, opponent_correct: 0)
    challenge.generate_question_ids
    (1..Challenge::MAX_NUM_QUESTIONS_NO_BONUS).each {  challenge.apply_question_result(OPPONENT_ID, Question::CORRECT, Game::BONUS_FALSE) }
    assert_equal(Challenge::MAX_NUM_QUESTIONS_NO_BONUS, challenge.counter)
  end

  test "apply_question_result counter_should_be_6_opponent_questions_1-6_incorrect" do
    challenge = Challenge.new(id: 1, game_id: 1, challenger_id: CHALLENGER_ID, opponent_id: OPPONENT_ID, wager: Subject::ART, prize: Subject::ENTERTAINMENT,
                              winner_id: 0, challenger_correct: 0, opponent_correct: 0)
    challenge.generate_question_ids
    (1..Challenge::MAX_NUM_QUESTIONS_NO_BONUS).each {  challenge.apply_question_result(OPPONENT_ID, Question::INCORRECT, Game::BONUS_FALSE) }
    assert_equal(Challenge::MAX_NUM_QUESTIONS_NO_BONUS, challenge.counter)
  end

  test "apply_question_result counter_should_be_6_opponent_questions_mixed_results" do
    challenge = Challenge.new(id: 1, game_id: 1, challenger_id: CHALLENGER_ID, opponent_id: OPPONENT_ID, wager: Subject::ART, prize: Subject::ENTERTAINMENT,
                              winner_id: 0, challenger_correct: 0, opponent_correct: 0)
    challenge.generate_question_ids
    (1..Challenge::MAX_NUM_QUESTIONS_NO_BONUS).each { |i|
      if i.even?
        challenge.apply_question_result(OPPONENT_ID, Question::CORRECT, Game::BONUS_FALSE)
      end
      if i.odd?
        challenge.apply_question_result(OPPONENT_ID, Question::INCORRECT, Game::BONUS_FALSE)
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
        challenge.apply_question_result(OPPONENT_ID, Question::CORRECT, Game::BONUS_FALSE)
      end
      if i > 2 && i < Challenge::MAX_NUM_QUESTIONS_OPPONENT
        challenge.apply_question_result(OPPONENT_ID, Question::INCORRECT, Game::BONUS_FALSE)
      end
      if i == Challenge::MAX_NUM_QUESTIONS_OPPONENT
        challenge.apply_question_result(OPPONENT_ID, Question::INCORRECT, Game::BONUS_TRUE)
      end
    }
    assert_equal(Challenge::MAX_NUM_QUESTIONS_OPPONENT, challenge.counter)
  end

  ######## Testing entire duration ########

  test "apply_question_result challenger_6_correct_opponent_6_correct_opponent_wins_tie_breaker" do
    challenge = Challenge.new(id: 1, game_id: 1, challenger_id: CHALLENGER_ID, opponent_id: OPPONENT_ID, wager: Subject::ART, prize: Subject::ENTERTAINMENT,
                              winner_id: 0, challenger_correct: 0, opponent_correct: 0)
    challenge.generate_question_ids
    question_ids = [challenge.art_id, challenge.ent_id, challenge.history_id, challenge.geo_id, challenge.science_id, challenge.sports_id]
    challenge_result = ''
    (1..Challenge::MAX_NUM_QUESTIONS_CHALLENGER).each {
      challenge_result = challenge.apply_question_result(CHALLENGER_ID, Question::CORRECT, Game::BONUS_FALSE)
      assert_equal(question_ids[0], challenge.art_id)
      assert_equal(question_ids[1], challenge.ent_id)
      assert_equal(question_ids[2], challenge.history_id)
      assert_equal(question_ids[3], challenge.geo_id)
      assert_equal(question_ids[4], challenge.science_id)
      assert_equal(question_ids[5], challenge.sports_id)
    }
    assert_equal(0, challenge.counter)
    assert_equal(Challenge::RESULT_OPPONENT_TURN, challenge_result)
    (1..Challenge::MAX_NUM_QUESTIONS_NO_BONUS).each {
      challenge_result = challenge.apply_question_result(OPPONENT_ID, Question::CORRECT, Game::BONUS_FALSE)
      assert_equal(question_ids[0], challenge.art_id)
      assert_equal(question_ids[1], challenge.ent_id)
      assert_equal(question_ids[2], challenge.history_id)
      assert_equal(question_ids[3], challenge.geo_id)
      assert_equal(question_ids[4], challenge.science_id)
      assert_equal(question_ids[5], challenge.sports_id)
    }
    assert_equal(Challenge::MAX_NUM_QUESTIONS_NO_BONUS, challenge.counter)
    assert_equal(Challenge::RESULT_TIE, challenge_result)
    challenge_result = challenge.apply_question_result(OPPONENT_ID, Question::CORRECT, Game::BONUS_TRUE)
    assert_equal(Challenge::MAX_NUM_QUESTIONS_OPPONENT, challenge.counter)
    assert_equal(Challenge::RESULT_WINNER, challenge_result)
    assert_equal(OPPONENT_ID, challenge.winner_id)
  end

  test "apply_question_result challenger_6_correct_opponent_6_correct_opponent_loses_tie_breaker" do
    challenge = Challenge.new(id: 1, game_id: 1, challenger_id: CHALLENGER_ID, opponent_id: OPPONENT_ID, wager: Subject::ART, prize: Subject::ENTERTAINMENT,
                              winner_id: 0, challenger_correct: 0, opponent_correct: 0)
    challenge.generate_question_ids
    question_ids = [challenge.art_id, challenge.ent_id, challenge.history_id, challenge.geo_id, challenge.science_id, challenge.sports_id]
    challenge_result = ''
    (1..Challenge::MAX_NUM_QUESTIONS_CHALLENGER).each {
      challenge_result = challenge.apply_question_result(CHALLENGER_ID, Question::CORRECT, Game::BONUS_FALSE)
      assert_equal(question_ids[0], challenge.art_id)
      assert_equal(question_ids[1], challenge.ent_id)
      assert_equal(question_ids[2], challenge.history_id)
      assert_equal(question_ids[3], challenge.geo_id)
      assert_equal(question_ids[4], challenge.science_id)
      assert_equal(question_ids[5], challenge.sports_id)
    }
    assert_equal(0, challenge.counter)
    assert_equal(Challenge::RESULT_OPPONENT_TURN, challenge_result)
    (1..Challenge::MAX_NUM_QUESTIONS_NO_BONUS).each {
      challenge_result = challenge.apply_question_result(OPPONENT_ID, Question::CORRECT, Game::BONUS_FALSE)
      assert_equal(question_ids[0], challenge.art_id)
      assert_equal(question_ids[1], challenge.ent_id)
      assert_equal(question_ids[2], challenge.history_id)
      assert_equal(question_ids[3], challenge.geo_id)
      assert_equal(question_ids[4], challenge.science_id)
      assert_equal(question_ids[5], challenge.sports_id)
    }
    assert_equal(Challenge::MAX_NUM_QUESTIONS_NO_BONUS, challenge.counter)
    assert_equal(Challenge::RESULT_TIE, challenge_result)
    challenge_result = challenge.apply_question_result(OPPONENT_ID, Question::INCORRECT, Game::BONUS_TRUE)
    assert_equal(Challenge::MAX_NUM_QUESTIONS_OPPONENT, challenge.counter)
    assert_equal(Challenge::RESULT_WINNER, challenge_result)
    assert_equal(CHALLENGER_ID, challenge.winner_id)
  end

  ######## Testing art_id ########

  #### With BONUS_FALSE ####

  ## With CHALLENGER_ID ##

  test "apply_question_result art_id_should_be_same_challenger_1st_question_correct" do
    challenge = Challenge.new(id: 1, game_id: 1, challenger_id: CHALLENGER_ID, opponent_id: OPPONENT_ID, wager: Subject::ART, prize: Subject::ENTERTAINMENT,
                              winner_id: 0, challenger_correct: 0, opponent_correct: 0)
    challenge.generate_question_ids
    art_id = challenge.art_id
    challenge.apply_question_result(CHALLENGER_ID, Question::CORRECT, Game::BONUS_FALSE)
    assert_equal(art_id, challenge.art_id)
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

  ################################ get_question_id_by_counter ################################

  test "get_question_id_by_counter should_return_art_id_counter_is_0" do
    challenge = Challenge.new(id: 1, game_id: 1, challenger_id: CHALLENGER_ID, opponent_id: OPPONENT_ID, wager: Subject::ART, prize: Subject::ENTERTAINMENT,
                              winner_id: 0, challenger_correct: 0, opponent_correct: 0, counter: 0)
    challenge.generate_question_ids
    assert_equal(challenge.art_id, challenge.get_question_id_by_counter)
  end

  test "get_question_id_by_counter should_return_ent_id_counter_is_1" do
    challenge = Challenge.new(id: 1, game_id: 1, challenger_id: CHALLENGER_ID, opponent_id: OPPONENT_ID, wager: Subject::ART, prize: Subject::ENTERTAINMENT,
                              winner_id: 0, challenger_correct: 0, opponent_correct: 0, counter: 1)
    challenge.generate_question_ids
    assert_equal(challenge.ent_id, challenge.get_question_id_by_counter)
  end

  test "get_question_id_by_counter should_return_sports_id_counter_is_5" do
    challenge = Challenge.new(id: 1, game_id: 1, challenger_id: CHALLENGER_ID, opponent_id: OPPONENT_ID, wager: Subject::ART, prize: Subject::ENTERTAINMENT,
                              winner_id: 0, challenger_correct: 0, opponent_correct: 0, counter: 5)
    challenge.generate_question_ids
    assert_equal(challenge.sports_id, challenge.get_question_id_by_counter)
  end

  test "get_question_id_by_counter should_not_return_nil_counter_is_6" do
    challenge = Challenge.new(id: 1, game_id: 1, challenger_id: CHALLENGER_ID, opponent_id: OPPONENT_ID, wager: Subject::ART, prize: Subject::ENTERTAINMENT,
                              winner_id: 0, challenger_correct: 0, opponent_correct: 0, counter: 6)
    challenge.generate_question_ids
    assert_not_equal(nil, challenge.get_question_id_by_counter)
  end

  test "get_question_id_by_counter should_return_integer_counter_is_6" do
    challenge = Challenge.new(id: 1, game_id: 1, challenger_id: CHALLENGER_ID, opponent_id: OPPONENT_ID, wager: Subject::ART, prize: Subject::ENTERTAINMENT,
                              winner_id: 0, challenger_correct: 0, opponent_correct: 0, counter: 6)
    challenge.generate_question_ids
    assert_equal(true, challenge.get_question_id_by_counter.integer?)
  end
end
