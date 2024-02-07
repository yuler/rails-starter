class RegistrationsController < ApplicationController
  allow_unauthenticated_access only: [ :new, :create ]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      authentication_as(@user)
      redirect_to root_path, notice: "Create success"
    else
      render :new, status: :unprocessable_entity, alert: "Something went wrong"
    end
  end

  private
    def user_params
      params.require(:user).permit(:email, :password, :password_confirmation)
    end
end
