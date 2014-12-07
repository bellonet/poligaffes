# encoding: UTF-8
#!/usr/bin/env ruby

require 'koala'
#api_key = File.read("#{Rails.root}/config/facebook_api_key.txt").strip
api_key = 'CAACEdEose0cBAGExnpeV9q5ZB1ncxqKOCZCospkafQQZCFbZAZCZBqrTnnj7KCQR7tumVnal4Dkth5QvLXLhYTrI2ggeCsCzzzymZB6hEZBB0PIhZCKm5U7rGT7WspaAaO91ZChRkdLAZCWwXg2oNKftLTsmJosnyugaZAm1aqmayuOYeImPWMjSyyIzeYqamOnqy9AndtHH5esbjZBhYFOlIBGjPpFVZAQeZCZCT04ZD'
g = Koala::Facebook::API.new(api_key)


# token = FbApiToken.order(expires: :desc).first
# if token.expires < DateTime.now
# 	raise "Invalid access token, enter a new one in /admin/fb_api_tokens"
# end

#g = Koala::Facebook::API.new(token.token)
facebook_id = 'yairlapid'

posts = g.get_connections(facebook_id, 'posts')
posts.each do |post|
  RawPost.create(post:         post,
                 site_id:      post['id'],
                 site_user_id: post['from']['id'],
                 yair_id:      1)
end
