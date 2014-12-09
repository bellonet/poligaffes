# encoding: UTF-8
#!/usr/bin/env ruby

require 'koala'
require 'time'

puts "Updating raw posts."
token = FbApiToken.order(expires: :desc).first
if token.expires < DateTime.now
	raise "Invalid access token, enter a new one in /admin/fb_api_tokens"
end
puts "Got an access token than expires #{token.expires}"

g = Koala::Facebook::API.new(token.token)

SocialMediaAccount.where(site: 'Facebook').each do |acc|
  $stdout.write "fetching for #{acc['name']}"
  # TODO instead of this next line, only get the posts SINCE THE LATEST WE ALREADY HAVE
  # this is something like .get_connections(acc.link, 'posts', since: latest_post_datetime)
  posts = g.get_connections(acc.link, 'posts')

  posts.each do |post|
    RawPost.create(post: post,
                   timestamp: post['updated_time'],
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
