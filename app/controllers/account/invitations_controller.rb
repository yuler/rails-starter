class Account::InvitationsController < ApplicationController
  def new
    @invitation = Current.account.account_invitations.new
  end

  def create
    @invitation = Current.account.account_invitations.new(invitation_params)
    @invitation.invited_by = Current.user

    if @invitation.save
      redirect_to account_memberships_path, notice: "Invitation sent."
    else
      render :new, status: :unprocessable_entity
    end
  end

  private
    def invitation_params
      params.require(:account_invitation).permit(:email)
    end
end
