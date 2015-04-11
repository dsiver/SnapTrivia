class StatisticsController < ApplicationController
  def new
  end

  #def user_stats
   # @user_options = User.all.map{|u| [ u.name, u.id ] }
  #end

  def site_stats
    @total_all = 0
    @total_correct = 0
    @art_all = 0
    @art_correct = 0
    @ent_all = 0
    @ent_correct = 0
    @geog_all = 0
    @geog_correct = 0
    @hist_all = 0
    @hist_correct = 0
    @science_all = 0
    @science_correct = 0
    @sports_all = 0
    @sports_correct = 0
  end
end
