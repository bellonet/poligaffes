require 'koala'

token = FbApiToken.order(expires: :desc).first
if token.expires < DateTime.now
	raise "Invalid access token, enter a new one in /admin/fb_api_tokens"
end

g = Koala::Facebook::API.new(token.token)

SocialMediaAccount.where(site: 'Facebook').each do |acc|

	begin
		about = g.get_object(acc.name, fields: 'about')["about"]
	rescue Exception => e
		puts e.fb_error_message
		next
	end

	acc.about = about
	acc.save
end