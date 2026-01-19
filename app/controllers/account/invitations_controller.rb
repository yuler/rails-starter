class Account::InvitationsController < ApplicationController
  before_action :ensure_admin, only: %i[ index create ]

  def new
    @invitation = Current.account.invitations.new
  end

  def index
    @invitations = Current.account.invitations
  end

  def create
    @invitation = Current.account.invitations.new(**invitation_params)

    if @invitation.save
      redirect_to account_invitations_path, notice: "Invitation sent."
    else
      render :index, status: :unprocessable_entity
    end
  end

  private
    def invitation_params
      params.require(:invitation).permit(:email).merge(invited_by: Current.user, account: Current.account)
    end
end
