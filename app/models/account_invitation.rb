class AccountInvitation < ApplicationRecord
  after_create :send_invitation_email

  belongs_to :account
  belongs_to :invited_by, class_name: "User", optional: true

  has_secure_token

  validates :email, presence: true
  validates :email, uniqueness: { scope: :account_id, message: "has already been invited" }

  def accept_url
    Rails.application.routes.url_helpers.account_invitation_accept_url(
      token,
      Rails.application.config.action_mailer.default_url_options
    )
  end

  def accept!
    if email != Current.user.email
      raise <<~message
        Your email does not match the email of the invitation.
        Current logged in user email: #{Current.user.email},
        Invitation email: #{email}
        Please sign in or sign up with the correct email.
      message
    end
    account.create_membership!(Current.user)
  end

  private
    def send_invitation_email
      AccountMailer.with(invitation: self).invite.deliver_later
    end
end
