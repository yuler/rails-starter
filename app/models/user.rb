class User < ApplicationRecord
  has_secure_password

  has_one :personal_account, class_name: "Account", dependent: :destroy

  has_many :memberships, dependent: :delete_all
  has_many :accounts, through: :memberships

  has_many :sessions, dependent: :destroy

  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }

  normalizes :email, with: ->(e) { e.strip.downcase }

  # TODO: Don't auto create, sometimes user can be invited to join an account
  # after_create :create_personal_account!

  def display_name
    email.split("@").first
  end

  def create_team_account(**account_params)
    transaction do
      Account.create!(**account_params, kind: :team, user: self).tap do |account|
        Membership.create!(account: account, user: self, role: :admin)
      end
    end
  end

  private
    def create_personal_account!
      account_name = "#{email}'s personal account"
      account_description = "This is your personal account. Automatically created by the system."
      account = Account.create!(name: account_name, description: account_description, kind: :personal, user: self)
      self.personal_account = account
      self.save!
    end
end
