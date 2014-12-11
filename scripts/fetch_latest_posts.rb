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
  posts = g.get_connections(acc.link, 'posts', since: latest_post_datetime)

  SinceRespectingCursor.new(g, :get_connections, acc.link, 'posts', since: latest_post_datetime).each do |post|
    RawPost.create(post: post,
                   timestamp: DateTime.strptime(post['created_time']),
                   id_in_site: post['id'],
                   social_media_account: acc)
    $stdout.write '.'
  end
  # TODO also, in case all these posts were newer than what's in DB, we need to go to the next page and also save those
  # posts = posts.next_page
  # and when you hit "next_page (which chronologically, is "previous" i.e. older posts)
  # it's not sure that facebook will respect your "since" parameter, so we'll need to
  # check this one here manually.
  $stdout.write "\n"
end
