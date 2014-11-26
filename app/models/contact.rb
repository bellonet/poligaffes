class Contact < MailForm::Base
  attribute :name,      :validate => true
  attribute :email,     :validate => /\A([\w\.%\+\-]+)@([\w\-]+\.)+([\w]{2,})\z/i
  attribute :message

  HUMAN_ATTRIBUTE_NAMES = {
    name: 'שם',
    email: 'אימייל',
    message: 'הודעה',
  }

  class << self
    def human_attribute_name attribute_name
      HUMAN_ATTRIBUTE_NAMES[attribute_name.to_sym] || super
    end
  end

  # Declare the e-mail headers. It accepts anything the mail method
  # in ActionMailer accepts.
  def headers
    {
      :subject => "My Contact Form",
      :to => "bellonet@gmail.com",
      :from => %("#{name}" <#{email}>)
    }
  end
end
