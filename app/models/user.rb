class User < ApplicationRecord
  has_secure_password
  has_many :sessions, dependent: :destroy
  has_one :personal_account, class_name: "Account", dependent: :destroy
  has_many :accounts, dependent: :destroy

  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }

  normalizes :email, with: ->(e) { e.strip.downcase }

  after_create :create_personal_account!

  private
    def create_personal_account!
      account_name = "#{email}'s personal account"
      account_description = "This is your personal account. Automatically created by the system."
      account = Account.create!(name: account_name, description: account_description, kind: :personal, user: self)
      self.personal_account = account
      self.save!
    end
end
