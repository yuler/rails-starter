class AccountInvitationsController < ApplicationController
  before_action :set_account_invitation

  def show
  end

  private
    def set_account_invitation
      @account_invitation = AccountInvitation.find_by!(token: params[:token] || params[:account_invitation_token])
    rescue ActiveRecord::RecordNotFound
      redirect_to root_path, alert: "Invitation not found or expired"
    end
end
