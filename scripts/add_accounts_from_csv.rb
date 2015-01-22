require 'koala'
require 'optparse'
require 'paperclip'

logfile = $stdout
filename = nil
field = nil
OptionParser.new do |opts|
  opts.on("-lLOGFILE", "--logfile=LOGFILE", "file to output to") do |l|
    logfile = File.open(l, 'a') if l
  end
  opts.on("-iINPUT", "--input-file=INPUT", "input csv file") do |i|
    filename = i
  end
    opts.on("-fFIELD", "--field=FIELD", "field to put on yairs") do |f|
    field = f
  end
end.parse!

raise "Please specify filename" unless filename and File.file? filename
raise "Please specify field" unless field

token = FbApiToken.where(purpose: 'misc').order(expires: :desc).first
raise "No token found!" unless token
if token.expires < DateTime.now
  raise "Invalid access token, enter a new one in /admin/fb_api_tokens"
end

g = Koala::Facebook::API.new(token.token)

## Needs to be changed acording to the sheet

CSV.foreach(filename) do |row|
  yair_first_name = row[0]
  yair_last_name = row[1]
  yair_party = row[2]
  account_name = row[3]
  if account_name.is_a? Numeric
    account_name = account_name.round.to_s
  end
  account_site = "Facebook"

  unless SocialMediaAccount.find_by_link(account_name)
    begin
      picture = g.get_picture(account_name, type: 'normal')

    rescue Exception => e
      logfile.puts e.fb_error_message
      next
    end

    begin
      about = g.get_object(account_name, fields: 'about')["about"]
    rescue
      logfile.puts account_name + " about was not found"
    end

    if (Yair.find_by_last_name(yair_last_name)) \
    && (Yair.find_by_last_name(yair_last_name).first_name==yair_first_name)
      @yair = Yair.find_by_last_name(yair_last_name)
    else
      @yair = Yair.new(last_name: yair_last_name, first_name: yair_first_name, party: yair_party, field: field)
      @yair.save
      logfile.puts @yair.last_name
    end

    @social_media_account = SocialMediaAccount.new(name: account_name,
                          site: account_site,
                          about: about,
                          link: account_name)
    @social_media_account.photo = URI.parse(picture)

    @social_media_account.yair = @yair

    if @social_media_account.save
      logfile.puts "saved"
    else
      @social_media_account.errors.full_messages.each do |msg|
            logfile.puts msg
          end
    end
  end
end

