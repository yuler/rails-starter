class AccountInvitations::AcceptancesController < AccountInvitationsController
  def show
  end

  def update
    @account_invitation.accept!
    redirect_to root_path, notice: "Invitation accepted!"
  end
end
