require 'test_helper'

class GameStatTest < ActiveSupport::TestCase
  BILL_ID = 2
  DAVID_ID = 3

  test "game_stat.game should_return_game_with_same_id" do
    game = Game.new
    game.player1_id = BILL_ID
    game.player2_id = DAVID_ID
    game.save
    game_stat = GameStat.new(game_id: game.id)
    game_stat.save
    assert_equal(game.id, game_stat.game.id)
  end
end
