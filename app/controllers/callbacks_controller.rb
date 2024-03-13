require "oauth2"

class CallbacksController < ApplicationController
  allow_unauthenticated_access only: [ :show ]

  def show
    email = request.env["omniauth.auth"].info.email
    provider = request.env["omniauth.auth"][:provider]

    user = User.find_by(email: email, provider: provider)

    if user.blank?
      user = User.create!(email: email, password: SecureRandom.hex(10), provider: provider)
    end

    authentication_as(user)
    redirect_to post_authenticating_url, notice: "Create success"

    # rescue => error
    #   logger.error error.message
    #   flash.now.alert = error.message
    #   redirect_to new_session_url, status: :unauthorized
  end
end
