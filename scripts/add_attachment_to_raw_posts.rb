# encoding: UTF-8
#!/usr/bin/env ruby

require 'paperclip'
require 'time'

puts "(#{DateTime.now})fetching attachments."
RawPost.where("timestamp >?", 5.minutes.ago).
where('attachment_file_name is null').
where("post ->> 'object_id' LIKE ?", "%%").each do |rp|

  $stdout.write "#{rp.id} - #{rp.social_media_account.link}"

  if rp.post['type'] == "photo"
    link = 'https://graph.facebook.com/' + rp.post['object_id'] + '/picture'
    rp.attachment = URI.parse(link)

  elsif rp.post['type'] == "video"
    rp.attachment = URI.parse(rp.post['source'])
  end

  if rp.save
    puts "... saved\n"
  else
    puts "\n"
  end

end
puts "finished run (#{DateTime.now})"
