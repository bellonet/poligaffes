# encoding: UTF-8
#!/usr/bin/env ruby

require 'paperclip'

RawPost.where("timestamp >?", 1.month.ago).
where('attachment_file_name is null').
where("post ->> 'object_id' LIKE ?", "%%").each do |rp|

  puts rp.id

  if rp.post['type'] == "photo"
    link = 'https://graph.facebook.com/' + rp.post['object_id'] + '/picture'
    rp.attachment = URI.parse(link)

  elsif rp.post['type'] == "video" 
    rp.attachment = URI.parse(rp.post['source'])
  end

  if rp.save
    puts "saved"
  end

end