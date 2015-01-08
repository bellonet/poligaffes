class Admin::DashboardController < Admin::BaseController

  RAW_POSTS_REPORT_SQL = "SELECT yairs.first_name || ' ' || yairs.last_name AS name, count(*)
                          FROM raw_posts
                              JOIN social_media_accounts ON (raw_posts.social_media_account_id = social_media_accounts.id)
                              JOIN yairs ON (social_media_accounts.yair_id = yairs.id)
                          GROUP BY yairs.id
                          ORDER BY count(*) DESC
                          LIMIT 5;"

  TOP_POSTS_SQL = "SELECT yairs.first_name || ' ' || yairs.last_name AS name, count(*)
                    FROM posts
                      JOIN social_media_accounts ON posts.social_media_account_id = social_media_accounts.id
                      JOIN yairs ON yairs.id = social_media_accounts.id
                    WHERE posts.status = '%s'
                    GROUP BY yairs.id
                    ORDER BY count(*) DESC
                    LIMIT 5;"


  def index
    @raw_post_counts = ActiveRecord::Base::connection.execute(RAW_POSTS_REPORT_SQL)
    @latest_raw_posts = RawPost.last(5)
    @top_posts = Hash[['deleted', 'edited'].map { |k| [k, ActiveRecord::Base::connection.execute(top_posts_sql k)] }]
  end

  private

  def top_posts_sql(type)
    return TOP_POSTS_SQL % type
  end


end
