class StatsController < ApplicationController

	STATS_SQL = """
  SELECT date_trunc('day',created_at) AS day, status, count(*)
  FROM posts WHERE created_at > '%s'
  GROUP BY status, date_trunc('day',created_at)
  ORDER BY date_trunc('day', created_at);
  """

  def index
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
  end

end
