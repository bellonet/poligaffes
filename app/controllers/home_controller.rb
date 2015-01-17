class HomeController < ApplicationController

  STATS_SQL = """
  SELECT date_trunc('day',created_at) AS day, status, count(*)
  FROM posts WHERE created_at > '%s'
  GROUP BY status, date_trunc('day',created_at)
  ORDER BY date_trunc('day', created_at);
  """

  def index
  	@posts = Post.all.order(created_at: :desc).paginate(page: params[:page], per_page: 5)
  	@length = 400

    res = ActiveRecord::Base::connection.execute(STATS_SQL % 1.week.ago.strftime('%Y-%m-%d'))
    @stats = [[],[]]
    res.each do |row|
      date = Date.parse(row['day'])
      if row['status'] == 'deleted'
        @stats[0] << {
          'day' => DateTime.now - date,
          'count' => row['count'].to_i,
          'name' => 'אבגדהוש'[date.wday]
          }
        else
          @stats[1] << {
          'day' => DateTime.now - date,
          'count' => row['count'].to_i,
          'name' => 'אבגדהוש'[date.wday]
          }
        end
      end

      @stats = [[{"day"=>(63472518368929/8640000000000), "count"=>7, "name"=>"ש"}, {"day"=>(91387530639109/14400000000000), "count"=>4, "name"=>"א"}, {"day"=>(25035012264299/5760000000000), "count"=>8, "name"=>"ג"}, {"day"=>(57825036809413/17280000000000), "count"=>6, "name"=>"ד"}, {"day"=>(12670324009133/5400000000000), "count"=>6, "name"=>"ה"}, {"day"=>(116325184246033/86400000000000), "count"=>7, "name"=>"ו"}], [{"day"=>(634725183774707/86400000000000), "count"=>18, "name"=>"ש"}, {"day"=>(274162591941223/43200000000000), "count"=>8, "name"=>"א"}, {"day"=>(230962591961557/43200000000000), "count"=>6, "name"=>"ב"}, {"day"=>(187762592002279/43200000000000), "count"=>24, "name"=>"ג"}, {"day"=>(5782503682009/1728000000000), "count"=>17, "name"=>"ד"}, {"day"=>(202725184200187/86400000000000), "count"=>21, "name"=>"ה"}, {"day"=>(116325184287101/86400000000000), "count"=>19, "name"=>"ו"}]]
    end

  def search
  	@yairs = Yair.where("last_name LIKE ?", "%#{params[:search]}%").paginate(page: params[:page], per_page: 10)
  	render :index
  end
  
end
