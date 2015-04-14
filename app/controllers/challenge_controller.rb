class ChallengeController < ApplicationController

  def create
    @challenge = Challenge.new
    @challenge.save
  end

  def show

  end

end
