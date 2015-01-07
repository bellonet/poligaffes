require 'spreadsheet'
require 'koala'
require 'paperclip'

Spreadsheet.client_encoding = 'UTF-8'

book = Spreadsheet.open 'yairs.xls'

#api_key = File.read("#{Rails.root}/config/facebook_api_key.txt").strip

token = FbApiToken.order(expires: :desc).first
if token.expires < DateTime.now
	raise "Invalid access token, enter a new one in /admin/fb_api_tokens"
end

g = Koala::Facebook::API.new(token.token)

## Needs to be changed acording to the sheet
sheet = book.worksheet 0
field = "representatives"

sheet.each do |row|
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
			puts e.fb_error_message
			next
		end

		if (Yair.find_by_last_name(yair_last_name)) \
		&& (Yair.find_by_last_name(yair_last_name).first_name==yair_first_name)
			@yair = Yair.find_by_last_name(yair_last_name)
		else
			@yair = Yair.new(last_name: yair_last_name, first_name: yair_first_name, party: yair_party, field: field)
			@yair.save
			puts @yair.last_name
		end

		@social_media_account = SocialMediaAccount.new(name: account_name, 
													site: account_site, 
													about: about,
													link: account_name)
		@social_media_account.photo = URI.parse(picture)
		@social_media_account.yair = @yair

		if @social_media_account.save
			puts "saved"
		else
			@social_media_account.errors.full_messages.each do |msg|
	          puts msg
	        end
		end
	end
end

