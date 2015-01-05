require 'set'
require 'koala'
require 'optparse'

def post_deleted(acc, raw_post)
  @logfile.write "D"
  Post.create(
    body:                 raw_post.post['message'], 
    status:               'deleted',
    created_at:           raw_post.timestamp,
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
@how_many = 5
OptionParser.new do |opts|
  opts.on("-lLOGFILE", "--logfile=LOGFILE", "file to output to") do |l|
    @logfile = File.open(l, 'a') if l
  end
  opts.on("-nHOWMANY", "--how-many=HOWMANY", "how many of the last posts to check") do |n|
    @how_many = n if n
  end
end.parse!

@logfile.puts "(#{DateTime.now})Checking for edits and deletes."

token = FbApiToken.where('purpose = ?', 'compare').order(expires: :desc).last
if token.expires < DateTime.now
  raise "Invalid access token, enter a new one in /admin/fb_api_tokens"
end
puts "Got an access token than expires #{token.expires}"

g = Koala::Facebook::API.new(token.token)

SocialMediaAccount.where(site: 'Facebook').each do |acc|
  @logfile.write "#{acc.link}"
  latest_raw_posts = acc.raw_posts.order('timestamp desc').limit(@how_many)
  next unless latest_raw_posts.any?

  latest_post_datetime = latest_raw_posts.first.timestamp
  latest_fb_posts = g.get_connections(acc.link, 'posts', until: latest_post_datetime, limit: @how_many)

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
