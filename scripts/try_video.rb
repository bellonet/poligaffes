# encoding: UTF-8
#!/usr/bin/env ruby

require 'time'
require 'koala'
require 'optparse'
require 'poligaffes/facebook/cursor'
require 'paperclip'
require 'httparty'

token = FbApiToken.order(expires: :desc).first
if token.expires < DateTime.now
  raise "Invalid access token, enter a new one in /admin/fb_api_tokens"
end

g = Koala::Facebook::API.new(token.token)

acc = SocialMediaAccount.find_by_id('144')

  latest_post = acc.raw_posts.order('timestamp').last
  latest_post_datetime = latest_post ? latest_post.timestamp : DateTime.new(1970)

  SinceRespectingCursor.new(g, :get_connections, acc.link, 'posts', since: latest_post_datetime).each do |post|

    @RP = RawPost.new(post: post,
                   timestamp: DateTime.strptime(post['created_time']),
                   id_in_site: post['id'],
                   social_media_account: acc)

    if post['object_id']

      if post['type'] == "photo"
        link = 'https://graph.facebook.com/' + @RP.post['object_id'] + '/picture'
        puts link
        @RP.attachment = URI.parse(link)

      elsif post['type'] == "video" 
        link = post['source']
        @RP.attachment = URI.parse(link)

        puts link

      end

    end

    if @RP.save
      puts "saved"
    end

  end