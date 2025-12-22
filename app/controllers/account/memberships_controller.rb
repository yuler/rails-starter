class Account::MembershipsController < ApplicationController
  def index
    @memberships = Current.account.memberships
  end

  def new
    @membership = @account.memberships.new
  end
end
