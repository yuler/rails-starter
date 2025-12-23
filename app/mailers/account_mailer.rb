class AccountMailer < ApplicationMailer
  def invite
    @invitation = params[:invitation]
    @account = @invitation.account
    @invited_by = @invitation.invited_by

    mail subject: "You've been invited to join #{Current.account.name} on #{ENV['SITE_NAME']}", to: @invitation.email
  end
end
