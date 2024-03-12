class UserMailer < ApplicationMailer
  def welcome
    @user = params[:user]

    mail to: @user.email, subject: "Welcome to our site"
  end

  def confirmation
    @user = params[:user]
    @confirmation_link = confirmation_url(token: @user.generate_token_for(:confirmation))

    mail to: @user.email, subject: "Please confirm your email"
  end

  def password_reset
    @user = params[:user]
    @reset_password_link = edit_password_reset_url(token: @user.generate_token_for(:password_reset))

    mail to: @user.email, subject: "Password Reset"
  end
end
