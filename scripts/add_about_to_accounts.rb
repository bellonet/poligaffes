require 'koala'

token = FbApiToken.where(purpose: 'misc').order(expires: :desc).first
if token.expires < DateTime.now
	raise "Invalid access token, enter a new one in /admin/fb_api_tokens"
end

g = Koala::Facebook::API.new(token.token)

SocialMediaAccount.where(site: 'Facebook').each do |acc|

	begin
		about = g.get_object(acc.name, fields: 'about')["about"]
	rescue
		puts acc.name + " about was not found"
	else
		acc.about = about
		acc.save
	end
end