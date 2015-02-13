require 'set'
require 'koala'
require 'optparse'
require 'poligaffes/facebook/errors'

include Poligaffes::Facebook::Errors

def post_deleted(acc, raw_post)
  return if raw_post.posts.any? && raw_post.posts.last.status == 'deleted'
  @logfile.write "D"
  Post.create(
    body:                 raw_post.post['message'], 
    status:               'deleted',
    social_media_account: acc,
    raw_post:             raw_post)
end

def post_edited(acc, raw_post, new_post)
  return if raw_post.posts.any? && raw_post.posts.last.body == new_post['message']
  @logfile.write "E"

  Post.create(
    body:                 new_post['message'],
    status:               'edited',
    social_media_account: acc,
    raw_post:             raw_post)
end


@logfile = $stdout
@how_many_from_fb = 20
@how_many_from_db = 10
OptionParser.new do |opts|
  opts.on("-lLOGFILE", "--logfile=LOGFILE", "file to output to") do |l|
    @logfile = File.open(l, 'a') if l
  end
  opts.on("-nHOWMANY", "--how-many-from-fb=HOWMANY", "how many posts to fetch from facebook ") do |n|
    @how_many_from_fb = n if n
  end
  opts.on("-mFROMDB", "--how-many-from-db=FROMDB", "how many posts to compare from db") do |m|
    @how_many_from_db = m if m
  end
end.parse!

@logfile.puts "(#{DateTime.now})Checking for edits and deletes."

tokens = FbApiToken.where(purpose: 'compare').where("expires > ?", DateTime.now)
graphs = tokens.map { |t| Koala::Facebook::API.new(t.token) }
g = Poligaffes::Facebook::ApiPool.new *graphs

SocialMediaAccount.tracking.where(site: 'Facebook').each do |acc|
  @logfile.write "#{acc.link}"
  latest_raw_posts = acc.raw_posts.order('timestamp desc').limit(@how_many_from_db)
  next unless latest_raw_posts.any?

  latest_post_datetime = latest_raw_posts.first.timestamp

  latest_fb_posts = call_with_retries do
    g.get_connections(acc.link, 'posts', until: latest_post_datetime, limit: @how_many_from_fb)
  end
  next unless latest_fb_posts # if too many errors

  ids_in_facebook      = Set.new latest_fb_posts.map { |p| p['id'] }
  facebook_posts       = Hash[latest_fb_posts.map { |p| [p['id'], p] }]

  latest_raw_posts.each do |raw_post|
    if ids_in_facebook.exclude? raw_post.post['id']
      post_deleted(acc, raw_post)
    elsif facebook_posts[raw_post.post['id']]['message'] != raw_post.post['message']
      post_edited(acc, raw_post, facebook_posts[raw_post.post['id']])
    end
  end
  @logfile.write "\n"
end
