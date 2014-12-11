# encoding: UTF-8
#!/usr/bin/env ruby

require 'koala'
require 'time'
require 'poligaffes/facebook/cursor'

puts "Updating raw posts."
token = FbApiToken.order(expires: :desc).first
if token.expires < DateTime.now
	raise "Invalid access token, enter a new one in /admin/fb_api_tokens"
end
puts "Got an access token than expires #{token.expires}"

g = Koala::Facebook::API.new(token.token)

SocialMediaAccount.where(site: 'Facebook').each do |acc|
  $stdout.write "fetching for #{acc['name']}"
  latest_post = acc.raw_posts.order('timestamp').last
  latest_post_datetime = latest_post ? latest_post.timestamp : DateTime.new(1970)

  SinceRespectingCursor.new(g, :get_connections, acc.link, 'posts', since: latest_post_datetime).each do |post|
    RawPost.create(post: post,
                   timestamp: DateTime.strptime(post['created_time']),
                   id_in_site: post['id'],
                   social_media_account: acc)
    $stdout.write '.'
  end
  $stdout.write "\n"
end
