require 'test_helper'

class GameTest < ActiveSupport::TestCase
  test "neither_players_have_trophies? should_be_true_no_trophies" do
    game = Game.new
    game.player1_id = 3
    game.player2_id = 4
    game.save
    assert_equal(true, game.neither_players_have_trophies?)
  end

  test "neither_players_have_trophies? should_be_false_one_trophy_p1" do
    game = Game.new
    game.player1_id = 3
    game.player2_id = 4
    game.art_trophy_p1 = true
    game.save
    assert_equal(false, game.neither_players_have_trophies?)
  end

  test "neither_players_have_trophies? should_be_false_both_have_1" do
    game = Game.new
    game.player1_id = 3
    game.player2_id = 4
    game.art_trophy_p1 = true
    game.art_trophy_p2=true
    game.save
    assert_equal(false, game.neither_players_have_trophies?)
  end

  test "both_have_only_one_trophy? should_be_false_no_trophies" do
    game = Game.new
    game.player1_id = 3
    game.player2_id = 4
    game.save
    assert_equal(false, game.both_have_only_one_trophy?)
  end

  test "both_have_only_one_trophy? should_be_false_p1_1" do
    game = Game.new
    game.player1_id = 3
    game.player2_id = 4
    game.art_trophy_p1 = true
    game.save
    assert_equal(false, game.both_have_only_one_trophy?)
  end

  test "both_have_only_one_trophy? should_be_false_p2" do
    game = Game.new
    game.player1_id = 3
    game.player2_id = 4
    game.art_trophy_p2 = true
    game.save
    assert_equal(false, game.both_have_only_one_trophy?)
  end

  test "both_have_only_one_trophy? should_be_true_p1&2" do
    game = Game.new
    game.player1_id = 3
    game.player2_id = 4
    game.art_trophy_p1 = true
    game.art_trophy_p2 = true
    game.save
    assert_equal(true, game.both_have_only_one_trophy?)
  end

  test "both_have_only_one_trophy? should_be_false_p1_has_1_more" do
    game = Game.new
    game.player1_id = 3
    game.player2_id = 4
    game.art_trophy_p1 = true
    game.entertainment_trophy_p1 = true
    game.art_trophy_p2 = true
    game.save
    assert_equal(false, game.both_have_only_one_trophy?)
  end

  test "same_trophies? should_be_false_none" do
    game = Game.new
    game.player1_id = 3
    game.player2_id = 4
    game.save
    assert_equal(false, game.same_trophies?)
  end

  test "same_trophies? should_be_false_p1_has_1" do
    game = Game.new
    game.player1_id = 3
    game.player2_id = 4
    game.art_trophy_p1 = true
    game.save
    assert_equal(false, game.same_trophies?)
  end

  test "same_trophies? should_be_false_p2_has_1" do
    game = Game.new
    game.player1_id = 3
    game.player2_id = 4
    game.art_trophy_p2 = true
    game.save
    assert_equal(false, game.same_trophies?)
  end

  test "same_trophies? should_be_false_different_ones" do
    game = Game.new
    game.player1_id = 3
    game.player2_id = 4
    game.entertainment_trophy_p1 = true
    game.art_trophy_p2 = true
    game.save
    assert_equal(false, game.same_trophies?)
  end

end
