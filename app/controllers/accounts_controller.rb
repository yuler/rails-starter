class AccountsController < ApplicationController
  before_action :set_account, only: [ :show, :update, :destroy ]

  def new
    @account = Account.new
  end

  def create
    @account = Account.new(account_params)
  end

  def update
    if @account.update(account_params)
      redirect_to @account, notice: "Account was successfully updated."
    else
      render :edit
    end
  end

  def destroy
    @account.destroy
    redirect_to accounts_url, notice: "Account was successfully destroyed."
  end

  private
    def set_account
      puts "params: #{params.inspect}"
      if params[:account_id].present?
        @account = Account.find(params[:account_id] || params[:id])
      else
        @account = Current.user.personal_account
      end
    end

    def account_params
      params.require(:account).permit(:name, :description, :kind)
    end
end
