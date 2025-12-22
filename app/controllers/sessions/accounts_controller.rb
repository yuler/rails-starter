class Sessions::AccountsController < ApplicationController
  disallow_account_scope

  def index
    @accounts = Current.identity.accounts

    if @accounts.one?
      redirect_to root_url(script_name: @accounts.first.slug_path)
    end
  end
end
