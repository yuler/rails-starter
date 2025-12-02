class AccountsController < ApplicationController
  before_action :set_account, only: [ :show, :update, :destroy ]

  def index
    @accounts = Current.user.accounts
  end

  def show
    @account = Account.find(params[:id])
  end

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
      if account = Current.user.accounts.find_by(id: params[:account_id] || params[:id])
        @account = account
      else
        redirect_to root_url, alert: "Account not found or inaccessible."
      end
    end

    def account_params
      params.require(:account).permit(:name, :description, :kind)
    end
end
