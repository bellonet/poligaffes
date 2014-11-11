# encoding: UTF-8
#!/usr/bin/env ruby

require 'koala'
api_key = File.read("#{Rails.root}/config/facebook_api_key.txt").strip
g = Koala::Facebook::API.new(api_key)

facebook_id = 'yairlapid'

posts = g.get_connections(facebook_id, 'posts')
posts.each do |post|
  RawPost.create(post:         post,
                 site_id:      post['id'],
                 site_user_id: post['from']['id'],
                 yair_id:      1)
end
