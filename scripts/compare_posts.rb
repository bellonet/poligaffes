require 'koala'

token = FbApiToken.order(expires: :desc).first
if token.expires < DateTime.now
	raise "Invalid access token, enter a new one in /admin/fb_api_tokens"
end
puts "Got an access token than expires #{token.expires}"

g = Koala::Facebook::API.new(token.token)

SocialMediaAccount.where(site: 'Facebook').each do |acc|

	latest_raw_posts = acc.raw_posts.order('timestamp desc').limit(10)
	
	next unless latest_raw_posts.any?

	latest_post_datetime = latest_raw_posts.first.timestamp

	latest_fb_posts = g.get_connections(acc.link, 'posts', until: latest_post_datetime, limit: 10)

	lfp_m  = latest_fb_posts.map { |p| p['message'] }
	lfp_id = latest_fb_posts.map { |p| p['id'] }

	latest_raw_posts.each do |lrp|
		unless lfp_m.include? lrp.post['message']
			if (lrp.posts.any?) && !(lfp_m.include? lrp.posts.last.body)
				next
			end
			unless lfp_id.include? lrp.post['id']
				status = "deleted"
			else
				status = "edited"
			end
			Post.create(body: lrp.post['message'], 
						status: status,
						created_at: lrp.timestamp,
						social_media_account: acc,
						raw_post: lrp)
		end
	end
end