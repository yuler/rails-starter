class ConfirmationsController < ApplicationController
  allow_unauthenticated_access only: [ :show ]
  before_action :set_token, only: [ :show ]

  def show
    @user = User.find_by_token_for(:confirmation, @token)

    if @user.blank?
      redirect_to root_path, alert: "Invalid or expired password reset token, please request a new one"
      return
    end

    @user.update!(confirmed_at: Time.current)
    redirect_to root_path, notice: "Email address confirmed"
  end

  def create
    Current.user.send_confirmation_email
    redirect_to root_path, notice: "Check your email for a confirmation link"
  end

  private
    def set_token
      @token = params[:token]
    end
end
