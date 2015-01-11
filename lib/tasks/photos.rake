namespace :poligaffes do
  desc "Re-fetch photos for social media accounts"
  task :reset_photos => :environment do
    token = FbApiToken.where(purpose: 'misc').order(expires: :desc).first
    if token.expires < DateTime.now
      raise "Invalid access token, enter a new one in /admin/fb_api_tokens"
    end

    g = Koala::Facebook::API.new(token.token)

    SocialMediaAccount.where('site = ?', 'Facebook').each do |acc|
      $stdout.write acc.link
      begin
        picture = g.get_picture(acc.link, type: 'normal')

      rescue Exception => e
        puts e.fb_error_message
        next
      end
      acc.photo = URI.parse(picture)
      if acc.save
        $stdout.write "saved\n"
      else
        acc.errors.full_messages.each do |msg|
          $stdout.write "\n\t#{msg}"
        end
        $stdout.write "\n"
      end
    end
  end
end