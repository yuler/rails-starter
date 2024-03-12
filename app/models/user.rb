class User < ApplicationRecord
  has_secure_password

  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }, presence: true, uniqueness: true

  normalizes :email, with: ->(email) { email.strip.downcase }

  after_commit :send_welcome_email, on: :create

  # Generates

  generates_token_for :confirmation, expires_in: 1.hour do
    confirmed_at&.to_s()
  end

  generates_token_for :password_reset, expires_in: 1.hour do
    password_salt&.last(10)
  end

  def confirmed?
    !!confirmed_at
  end

  # Mails

  def send_welcome_email
    UserMailer.with(user: self).welcome.deliver_later
  end

  def send_confirmation_email
    UserMailer.with(user: self).confirmation.deliver_later
  end

  def send_password_reset_email
    UserMailer.with(user: self).password_reset.deliver_later
  end
end
