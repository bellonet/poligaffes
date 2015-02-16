require 'poligaffes/stats/polistats'
class StatsController < ApplicationController
  caches_action :index

	before_filter { use_cover_photo 'stats.jpg' }


  def index
    @weekly_top  = Hash[['posts', 'deleted', 'edited'].map { |k| [k, Poligaffes::Stats.top_posts(k, 7)] }]
    @monthly_top = Hash[['posts', 'deleted', 'edited'].map { |k| [k, Poligaffes::Stats.top_posts(k, 31)] }]
    @alltime_top = Hash[['posts', 'deleted', 'edited'].map { |k| [k, Poligaffes::Stats.top_posts(k, 1e4)] }]

    @bar_graph   = Poligaffes::Stats.weekly_activity_bar
  end

end
