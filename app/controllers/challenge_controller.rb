class ChallengeController < ApplicationController

  def create
    @challenge = Challenge.create(challenge_params)
  end

  def show

  end

  def challenge_params
    params.permit(:game_id, :challenger_id, :opponent_id, :winner_id, :challenger_correct, :opponent_correct, :art_id, :ent_id, :history_id, :geo_id, :science_id, :sports_id, :wager, :prize)
  end

end
