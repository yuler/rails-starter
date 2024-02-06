class SessionsController < ApplicationController
  allow_unauthenticated_access only: [ :new, :create ]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if User.authenticate(@user)
      authentication_as(user)
      redirect_to post_authenticating_url
    else
      render :new, status: :unauthorized, alert: "Invalid email or password"
    end
  end

  def destroy
    reset_authentication
  end

  private
    def user_params
      params.require(:user).permit(:email, :password)
    end
end
