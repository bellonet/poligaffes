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
          'day' => (DateTime.now - date).to_i,
          'count' => row['count'].to_i,
          'name' => 'אבגדהוש'[date.wday]
          }
        else
          @stats[1] << {
          'day' => (DateTime.now - date).to_i,
          'count' => row['count'].to_i,
          'name' => 'אבגדהוש'[date.wday]
          }
        end
      end
      @stats = [[{"day"=>(211695790437271/28800000000000), "count"=>7, "name"=>"ש"}, {"day"=>(109737474301829/17280000000000), "count"=>4, "name"=>"א"}, {"day"=>(125295790577299/28800000000000), "count"=>8, "name"=>"ג"}, {"day"=>(72371842966279/21600000000000), "count"=>6, "name"=>"ד"}, {"day"=>(8123494880099/3456000000000), "count"=>6, "name"=>"ה"}, {"day"=>(116687372172149/86400000000000), "count"=>7, "name"=>"ו"}], [{"day"=>(635087371436783/86400000000000), "count"=>18, "name"=>"ש"}, {"day"=>(137171842899061/21600000000000), "count"=>8, "name"=>"א"}, {"day"=>(462287371665047/86400000000000), "count"=>6, "name"=>"ב"}, {"day"=>(375887371796603/86400000000000), "count"=>24, "name"=>"ג"}, {"day"=>(57897474386977/17280000000000), "count"=>17, "name"=>"ד"}, {"day"=>(203087372089409/86400000000000), "count"=>21, "name"=>"ה"}, {"day"=>(116687372238667/86400000000000), "count"=>19, "name"=>"ו"}]]
    end

  def search
  	@yairs = Yair.where("last_name LIKE ?", "%#{params[:search]}%").paginate(page: params[:page], per_page: 10)
  	render :index
  end
  
end
