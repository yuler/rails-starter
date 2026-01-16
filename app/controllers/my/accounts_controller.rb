class My::AccountsController < ApplicationController
  def new
    @account = Current.identity.accounts.new
  end

  def create
    # Create account with owner
    @account = Account.create_with_owner(
      account: account_params,
      owner: {
        name: Current.identity.full_name,
        identity: Current.identity
      }
    )

    if @account.persisted?
      redirect_to my_accounts_path
    else
      render :new, status: :unprocessable_entity
    end
  rescue => error
    @account ||= Account.new(account_params)
    @account.errors.add(:base, "Something went wrong, and we couldn't create your account. Please give it another try.")
    Rails.error.report(error, severity: :error)
    Rails.logger.error error
    Rails.logger.error error.backtrace.join("\n")
    render :new, status: :unprocessable_entity
  end

  def index
    @accounts = Current.identity.accounts

    # TODO:
    # if @accounts.one?
    #   redirect_to root_url(script_name: @accounts.first.slug_path)
    # end
  end

  private
    def account_params
      params.require(:account).permit(:name, :description)
    end
end
