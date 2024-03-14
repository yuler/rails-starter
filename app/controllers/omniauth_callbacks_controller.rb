require "oauth2"

class OmniauthCallbacksController < ApplicationController
  allow_unauthenticated_access only: [ :show ]

  def show
    email = request.env["omniauth.auth"].info.email
    provider = request.env["omniauth.auth"][:provider]

    user = User.find_by(email: email)

    if user.blank?
      user = User.create!(email: email, password: SecureRandom.hex(10), provider: provider)
      notice = "Create success"
    end

    authentication_as(user)
    redirect_to post_authenticating_url, notice: notice
  end
end
