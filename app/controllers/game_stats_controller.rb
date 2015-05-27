class GameStatsController < ApplicationController

  ############################################################
  #####################     PRIVATE     ######################
  ############################################################

  private

  def game_stat_params
    params.permit(:art_total, :art_correct, :ent_total, :ent_correct, :geo_total, :geo_correct, :hist_total, :hist_correct, :sci_total, :sci_correct, :sports_total, :sports_correct)
  end

end
