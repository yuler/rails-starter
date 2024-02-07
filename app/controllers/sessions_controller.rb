class SessionsController < ApplicationController
  allow_unauthenticated_access only: [ :new, :create ]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    # Validate the user
    @user.errors.add(:email, "can't be blank") if @user.email.blank?
    @user.errors.add(:password, "can't be blank") if @user.password.blank?

    if @user.errors.any?
      render :new, status: :unprocessable_entity
    elsif user = User.authenticate_by(email: @user.email, password: @user.password)
      authentication_as(user)
      redirect_to post_authenticating_url
    else
      flash.now.alert = "Invalid email or password"
      render :new, status: :unauthorized
    end
  end

  def destroy
    reset_authentication
    redirect_to root_path, notice: "You have been logged out"
  end

  private
    def user_params
      params.require(:user).permit(:email, :password)
    end
end
