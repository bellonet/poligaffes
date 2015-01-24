# encoding: UTF-8
#!/usr/bin/env ruby

require 'paperclip'
require 'optparse'
require 'time'

@logfile = $stdout
@type = nil
@minutes_ago = 2
OptionParser.new do |opts|
  opts.on("-lLOGFILE", "--logfile=LOGFILE", "file to output to") do |l|
    @logfile = File.open(l, 'a') if l
  end
  opts.on("-tTYPE", "--type=TYPE", "which attachments to get [photo/video]") do |t|
    @type = t
  end
  opts.on("-mMINUTES", "--minutes=MINUTES", "how many minutes to go back") do |m|
    @minutes_ago = m
  end
end.parse!

raise OptionParser::MissingArgument if @type.nil?
raise OptionParser::ParseError.new("choose photo/video") if !(['photo','video'].include? @type)

@logfile.puts "(#{DateTime.now})fetching attachments (#{@type}."
RawPost.where("timestamp >?", @minutes_ago.to_i.minutes.ago).
  where('attachment_file_name is null').
  where("post ->> 'object_id' LIKE ?", "%%").
  where("post ->> 'type' = ?", @type).each do |rp|

  @logfile.write "#{rp.id} - #{rp.social_media_account.link}"

  ok = true
  begin
    if rp.post['type'] == "photo"
      link = 'https://graph.facebook.com/' + rp.post['object_id'] + '/picture'
      rp.attachment = URI.parse(link)

    elsif rp.post['type'] == "video"
      rp.attachment = URI.parse(rp.post['source'])
    end
  rescue OpenURI::HTTPError => e
    ok = false
    @logfile.puts e.inspect
  end

  if rp.save && ok
    @logfile.puts "... saved\n"
  else
    @logfile.puts "... skipped\n"
  end

end
@logfile.puts "finished run (#{DateTime.now})"
