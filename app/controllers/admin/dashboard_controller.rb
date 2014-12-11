class Admin::DashboardController < Admin::BaseController

  RAW_POSTS_REPORT_SQL = "SELECT yairs.first_name || ' ' || yairs.last_name AS name, count(*)
                          FROM raw_posts
                              JOIN social_media_accounts ON (raw_posts.social_media_account_id = social_media_accounts.id)
                              JOIN yairs ON (social_media_accounts.yair_id = yairs.id)
                          GROUP BY yairs.id
                          ORDER BY count(*) DESC
                          LIMIT 5;"
  def index
    @raw_post_counts = ActiveRecord::Base::connection.execute(RAW_POSTS_REPORT_SQL)
  end
end
