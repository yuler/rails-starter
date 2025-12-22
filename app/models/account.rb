class Account < ApplicationRecord
  belongs_to :user

  has_many :memberships, dependent: :delete_all
  has_many :users, through: :memberships
  has_many :account_invitations, dependent: :destroy

  has_one_attached :logo

  enum :kind, %i[ personal team ], default: :team

  before_create :generate_slug!

  class << self
    def create_with_owner(account:, owner:)
      create!(**account, kind: :team).tap do |account|
        account.memberships.create!(user: {}, role: :system)
        account.memberships.create!(user: owner, role: :owner)
      end
    end
  end

  # @return [String] the account's slug
  def slug_path
    "/#{AccountSlug.encode(slug)}"
  end

  def system_user
    users.find_by!(role: :system)
  end

  def create_membership!(user, role: :member)
    Membership.create!(user: user, account: self, role: role)
  end

  private
    def generate_slug!
      loop do
        self.slug = Base32.generate(AccountSlug::LENGTH)
        break slug unless self.class.exists?(slug: slug)
      end
    end
end
