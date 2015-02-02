module Poligaffes
  module Stats

    GRAPH_SQL = """ SELECT date_trunc('day',created_at) AS day, status, count(*)
                    FROM posts WHERE created_at > '%s'
                    GROUP BY status, date_trunc('day',created_at)
                    UNION
                    SELECT date_trunc('day',created_at) AS day, 'total', count(*)
                    FROM raw_posts
                    WHERE created_at > '%s'
                    GROUP BY 1
                    ORDER BY 1;
      """

      def self.weekly_activity_bar
        res = ActiveRecord::Base::connection.execute(GRAPH_SQL % [ 1.week.ago.strftime('%Y-%m-%d'), 1.week.ago.strftime('%Y-%m-%d') ])
        data = res.reduce(Hash.new) do |r, row|
          date = Date.parse(row['day'])
          status = {
            'deleted' => 'deletes',
            'edited'  => 'edits',
            'total'   => 'raw_posts'
          }[row['status']]
          r[row['day']] ||= Hash.new
          r[row['day']]['day'] = date
          r[row['day']]['name'] =  'אבגדהוש'[date.wday]
          r[row['day']][I18n.t("stats.#{status}")] = row['count'].to_i
          r
        end
        ret = data.keys.sort.reverse.map { |d| data[d] }
      end # def self.weekly_activity_bar

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

      RAW_POSTS_REPORT_SQL = "SELECT yairs.id, yairs.first_name || ' ' || yairs.last_name AS name, count(*)
                          FROM raw_posts
                              JOIN social_media_accounts ON (raw_posts.social_media_account_id = social_media_accounts.id)
                              JOIN yairs ON (social_media_accounts.yair_id = yairs.id)
                          WHERE raw_posts.created_at > %s
                          GROUP BY yairs.id
                          ORDER BY count(*) DESC
                          LIMIT 5;"
      def self.top_posts(type, days_ago)
        if type == 'posts'
          ActiveRecord::Base::connection.execute(RAW_POSTS_REPORT_SQL % [ days_ago.days.ago ].map { |e| ActiveRecord::Base.sanitize(e) }).map { |e| e }
        else
          ActiveRecord::Base::connection.execute(TOP_POSTS_SQL % [ type, days_ago.days.ago ].map { |e| ActiveRecord::Base.sanitize(e) }).map { |e| e }
        end
      end # def self.top_posts

  end # module Stats
end # module Poligaffes