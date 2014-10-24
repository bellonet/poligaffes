class ContactMailer < ActionMailer::Base
  default from: "bellonet@gmail.com", to: "bellonet@gmail.com"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.contact_mailer.contact_email.subject
  #
  def contact_email(contact)
  	@contact = contact

    mail subject: "Someone Contacted Poligaffes"
  end
end
