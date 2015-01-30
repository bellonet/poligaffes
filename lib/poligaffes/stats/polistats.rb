module Poligaffes
  module Stats

    STATS_SQL = """
      SELECT date_trunc('day',created_at) AS day, status, count(*)
      FROM posts WHERE created_at > '%s'
      GROUP BY status, date_trunc('day',created_at)
      ORDER BY date_trunc('day', created_at);
      """
      def self.weekly_activity_graph
        res = ActiveRecord::Base::connection.execute(STATS_SQL % 1.week.ago.strftime('%Y-%m-%d'))
        ret = [[],[]]
        res.each do |row|
          date = Date.parse(row['day'])
          if row['status'] == 'deleted'
            ret[0] << {
              'day' => (DateTime.now - date).to_i,
              'count' => row['count'].to_i,
              'name' => 'אבגדהוש'[date.wday]
              }
            else
              ret[1] << {
              'day' => (DateTime.now - date).to_i,
              'count' => row['count'].to_i,
              'name' => 'אבגדהוש'[date.wday]
              }
          end
        end
        ret
      end # def self.weekly_activity_graph

      TOP_POSTS_SQL = "SELECT yairs.id, yairs.first_name || ' ' || yairs.last_name AS name, count(*)
                       FROM posts
                         JOIN raw_posts ON raw_posts.id = posts.raw_post_id
                         JOIN social_media_accounts ON raw_posts.social_media_account_id = social_media_accounts.id
                         JOIN yairs ON yairs.id = social_media_accounts.id
                       WHERE posts.status = %s
                         AND posts.created_at > %s
                       GROUP BY yairs.id
                       ORDER BY count(*) DESC
                       LIMIT 5;"
      def self.top_posts(type, days_ago)
        ActiveRecord::Base::connection.execute(TOP_POSTS_SQL % [ type, days_ago.days.ago ].map { |e| ActiveRecord::Base.sanitize(e) }).map { |e| e }
      end # def self.top_posts

  end # module Stats
end # module Poligaffes