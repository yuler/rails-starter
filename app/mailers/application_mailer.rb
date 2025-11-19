class ApplicationMailer < ActionMailer::Base
  default from: email_address_with_name(ENV.fetch("EMAIL_SENDER", "sender@example.com"), "rails_starter")
  layout "mailer"
end
