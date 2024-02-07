class UserMailer < ApplicationMailer
  def welcome
    @user = params[:user]

    mail to: @user.email, subject: "Welcome to our site"
  end
end
