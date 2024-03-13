class PasswordResetsController < ApplicationController
  allow_unauthenticated_access only: [ :new, :create, :edit, :update ]
  before_action :set_token, only: [ :edit, :update ]

  def new
    @user = User.new
  end

  def create
    @user = User.find_by(user_params)

    # Blank?
    if @user.blank?
      flash.now.alert = "No user found with that email address"
      render :new, status: :unprocessable_entity
      return
    end

    @user.send_password_reset_email
    redirect_to new_session_path, notice: "Password reset instructions have been sent to your email"
  end

  def edit
    @user = User.find_by_token_for(:password_reset, @token)

    if @user.blank?
      redirect_to new_password_reset_path, alert: "Invalid or expired password reset token, please request a new one"
    end
  end

  def update
    @user = User.find_by_token_for(:password_reset, @token)

    if @user.blank?
      redirect_to new_password_reset_path, alert: "Invalid or expired password reset token, please request a new one"
      return
    end

    if @user.update(user_params)
      redirect_to new_session_path, notice: "Password has been reset"
    else
      render :edit, status: :unprocessable_entity, alert: "Something went wrong"
    end
  end

  private
    def user_params
      params.require(:user).permit(:email, :password, :password_confirmation)
    end

    def set_token
      @token = params[:token]
    end
end
