require 'poligaffes/stats/polistats'
class StatsController < ApplicationController


  def index
    @weekly_activity = Poligaffes::Stats.weekly_activity_graph
    @weekly_top =  Rails.cache.fetch('weekly_top-cache-key') { Hash[['deleted', 'edited'].map { |k| [k, Poligaffes::Stats.top_posts(k, 7)] }] }
    @monthly_top = Rails.cache.fetch('monthly_top-cache-key') { Hash[['deleted', 'edited'].map { |k| [k, Poligaffes::Stats.top_posts(k, 31)] }] }
    @alltime_top = Rails.cache.fetch('alltime_top-cache-key') { Hash[['deleted', 'edited'].map { |k| [k, Poligaffes::Stats.top_posts(k, 1e4)] }] }
  end

end
