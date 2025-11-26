class Accounts::MembershipsController < AccountsController
  before_action :set_account, only: [ :index, :new, :create, :destroy ]

  def index
    @memberships = @account.memberships
  end

  def new
    @membership = @account.memberships.new
  end
end
