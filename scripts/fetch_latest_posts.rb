# encoding: UTF-8
#!/usr/bin/env ruby

require 'time'
require 'koala'
require 'optparse'
require 'poligaffes/facebook/cursor'

logfile = $stdout
OptionParser.new do |opts|
  opts.on("-lLOGFILE", "--logfile=LOGFILE", "file to output to") do |l|
    logfile = File.open(l, 'a') if l
  end
end.parse!

logfile.puts "(#{DateTime.now})Updating raw posts."
token = FbApiToken.order(expires: :desc).first
if token.expires < DateTime.now
	raise "Invalid access token, enter a new one in /admin/fb_api_tokens"
end
logfile.puts "Got an access token than expires #{token.expires}"

g = Koala::Facebook::API.new(token.token)

SocialMediaAccount.where(site: 'Facebook').each do |acc|
  logfile.write "fetching for #{acc['name']}"
  latest_post = acc.raw_posts.order('timestamp').last
  latest_post_datetime = latest_post ? latest_post.timestamp : DateTime.new(1970)

  SinceRespectingCursor.new(g, :get_connections, acc.link, 'posts', since: latest_post_datetime).each do |post|
    RawPost.create(post: post,
                   timestamp: DateTime.strptime(post['created_time']),
                   id_in_site: post['id'],
                   social_media_account: acc)
    logfile.write '.'
  end
  logfile.write "\n"
end

logfile.close