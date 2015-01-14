require "httparty"
require 'json'
require 'koala'

token = FbApiToken.order(expires: :desc).first
g = Koala::Facebook::API.new(token.token)

Dir.mkdir 'attachments_test' unless File.directory? 'attachments_test'

RawPost.where("timestamp >?", 1.month.ago).each_with_index do |rp, i|
	
	# We're interested in all photos (all have object_id) and videos that have object_id 
	if rp.post['object_id']

		# Photos:
		if rp.post['type'] == "photo"
		 	link = 'https://graph.facebook.com/' + rp.post['object_id'] + '/picture'

		 	File.open("attachments_test/file#{i}.jpg", "wb") do |f| 
   			f.write HTTParty.get(link).parsed_response
		 	end

		# Videos:
		elsif rp.post['type'] == "video"   #### SHOULD BE ELSIF

			# post["source"] changes with time - fetching it again to download video
			begin
				fb_link = g.get_object(rp.id_in_site, fields: "source")
			rescue
				puts rp.id_in_site + " was not found"
			else
				link = fb_link['source']

		 		File.open("attachments_test/file#{i}.mp4", "wb") do |f| 
   				f.write HTTParty.get(link).parsed_response
   			end
   		end
   	end

		#puts JSON.dump(rp.post)

	end

	end

end