# encoding: UTF-8
#!/usr/bin/env ruby

require 'time'
require 'koala'
require 'optparse'
require 'poligaffes/facebook/cursor'
require 'paperclip'
require 'httparty'

# token = FbApiToken.order(expires: :desc).first
# if token.expires < DateTime.now
#   raise "Invalid access token, enter a new one in /admin/fb_api_tokens"
# end

# g = Koala::Facebook::API.new(token.token)

RawPost.where("timestamp >?", 1.month.ago).
where('attachment_file_name is null').
where("post ->> 'object_id' LIKE ?", "%%").each do |rp|

  puts rp.id

  if rp.post['type'] == "photo"
    link = 'https://graph.facebook.com/' + rp.post['object_id'] + '/picture'
    puts link
    rp.attachment = URI.parse(link)

  elsif rp.post['type'] == "video" 
    link = rp.post['source']
    rp.attachment = URI.parse(link)

    puts link

  end

  if rp.save
    puts "saved"
  end

end