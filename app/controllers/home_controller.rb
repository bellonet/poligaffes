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
    end

  def search
  	@yairs = Yair.where("last_name LIKE ?", "%#{params[:search]}%").paginate(page: params[:page], per_page: 10)
  	render :index
  end
  
end
