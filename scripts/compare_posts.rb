require 'koala'

token = FbApiToken.order(expires: :desc).first
if token.expires < DateTime.now
	raise "Invalid access token, enter a new one in /admin/fb_api_tokens"
end
puts "Got an access token than expires #{token.expires}"

g = Koala::Facebook::API.new(token.token)

acc = SocialMediaAccount.find_by_id('129')
facebook_id = SocialMediaAccount.find_by_id('129').link

latest_raw_posts = acc.raw_posts.order('timestamp desc').limit(10)
lrp = latest_raw_posts.map { |p| p.post['message'] }
latest_post_datetime = latest_raw_posts.first.timestamp

latest_fb_posts = g.get_connections(facebook_id, 'posts', until: latest_post_datetime, limit: 10)
lfp  = latest_fb_posts.map { |p| p['message'] }

lrp.each do |l|
	unless lfp.include? l
		Post.create(body: l, social_media_account: acc)
	end
end