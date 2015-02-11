require 'poligaffes/stats/polistats'
class StatsController < ApplicationController

	before_filter { use_cover_photo 'stats.jpg' }


  def index
    @weekly_top =  Rails.cache.fetch('weekly_top-cache-key')  { Hash[['posts', 'deleted', 'edited'].map { |k| [k, Poligaffes::Stats.top_posts(k, 7)] }] }
    @monthly_top = Rails.cache.fetch('monthly_top-cache-key') { Hash[['posts', 'deleted', 'edited'].map { |k| [k, Poligaffes::Stats.top_posts(k, 31)] }] }
    @alltime_top = Rails.cache.fetch('alltime_top-cache-key') { Hash[['posts', 'deleted', 'edited'].map { |k| [k, Poligaffes::Stats.top_posts(k, 1e4)] }] }

    @bar_graph = Rails.cache.fetch('weekly_activity-cache-key') { Poligaffes::Stats.weekly_activity_bar }
  end

end
