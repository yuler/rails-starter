class Accounts::InvitationsController < AccountsController
  before_action :set_account

  def new
    @invitation = AccountInvitation.new
  end

  def create
    @invitation = @account.account_invitations.new(invitation_params)
    @invitation.invited_by = Current.user

    if @invitation.save
      redirect_to account_memberships_path(@account), notice: "Invitation sent."
    else
      render :new, status: :unprocessable_entity
    end
  end

  private
    def invitation_params
      params.require(:account_invitation).permit(:email)
    end
    def set_invitation_by_token
      @invitation = AccountInvitation.find_by!(token: params[:token])
    end
end
