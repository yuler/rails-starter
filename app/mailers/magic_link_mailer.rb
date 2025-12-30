class MagicLinkMailer < ApplicationMailer
  def sign_in(magic_link)
    @magic_link = magic_link
    @identity = @magic_link.identify

    mail to: @identity.email, subject: "Sign in to your account"
  end
end
