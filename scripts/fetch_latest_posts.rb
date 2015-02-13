# encoding: UTF-8
#!/usr/bin/env ruby

require 'time'
require 'koala'
require 'optparse'
require 'poligaffes/facebook/cursor'

logfile = $stdout
token_purpose = nil
tracking = true
OptionParser.new do |opts|
  opts.on("-lLOGFILE", "--logfile=LOGFILE", "file to output to") do |l|
    logfile = File.open(l, 'a') if l
  end

  opts.on("-pTOKEN_PURPOSE", "--token-purpose=TOKEN_PURPOSE", "which kind of token to use [fetch]") do |p|
    token_purpose = p
  end
  opts.on("-n", "--non-tracking", "run the script for non-tracking accounts (as an initial thing)") do |n|
    tracking = false
  end
end.parse!

logfile.puts "(#{DateTime.now})Updating raw posts."
if token_purpose
  token = FbApiToken.where('purpose = ?', token_purpose).order(expires: :desc).first
  token or raise "No token found!"
  if token.expires < DateTime.now
    raise "Invalid access token, enter a new one in /admin/fb_api_tokens"
  end
  logfile.puts "Got an access token than expires #{token.expires}"

  g = Koala::Facebook::API.new(token.token)
else
  tokens = FbApiToken.where(purpose: 'fetch').where("expires > ?", DateTime.now)
  graphs = tokens.map { |t| Koala::Facebook::API.new(t.token) }
  g = Poligaffes::Facebook::ApiPool.new *graphs
end


if tracking
  cursor = SocialMediaAccount.tracking.where(site: 'Facebook').order('random()')
else
  cursor = SocialMediaAccount.non_tracking.where(site: 'Facebook').order('random()')
end

cursor.each do |acc|
  logfile.write "fetching for #{acc['name']}"
  latest_post = acc.raw_posts.order('timestamp').last
  latest_post_datetime = latest_post ? latest_post.timestamp : DateTime.new(1970)

  SinceRespectingCursor.new(g, :get_connections, acc.link, 'posts', since: latest_post_datetime, locale: 'he_IL').each do |post|
    RawPost.create(post: post,
                   timestamp: DateTime.strptime(post['created_time']),
                   id_in_site: post['id'],
                   social_media_account: acc)
    logfile.write '.'
  end
  logfile.write "\n"
end

logfile.close