require 'spreadsheet'
require 'koala'

Spreadsheet.client_encoding = 'UTF-8'

book = Spreadsheet.open 'representatives.xls'

sheet = book.worksheet 2

api_key = File.read("#{Rails.root}/config/facebook_api_key.txt").strip
g = Koala::Facebook::API.new(api_key)

sheet.each do |row|

	yair_first_name = row[0]
	yair_last_name = row[1]
	yair_party = row[2]
	account_name = row[3].to_i.to_s
	puts account_name
	account_site = "Facebook"

	picture = g.get_picture(account_name, type: 'normal')

	##HAVE TO CHANGE THIS - PEOPLE MIGHT HAVE SAME LAST NAME!!!!!!
	if Yair.find_by_last_name(yair_last_name).blank?
		@yair = Yair.new(last_name: yair_last_name, first_name: yair_first_name, party: yair_party, field: 'politician')
		@yair.save
	else
		@yair = Yair.find_by_last_name(yair_last_name)
	end

	@social_media_account = SocialMediaAccount.new(name: account_name, site: account_site, link: account_name)
	@social_media_account.photo = URI.parse(picture)
	@social_media_account.yair = @yair
	@social_media_account.save

end

