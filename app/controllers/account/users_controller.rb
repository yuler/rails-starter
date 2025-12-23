class Account::UsersController < ApplicationController
  def index
    @users = Current.account.users
  end

  def new
    @user = @account.users.new
  end
end
