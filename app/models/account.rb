class Account < ApplicationRecord
  belongs_to :user

  has_many :memberships, dependent: :delete_all
  has_many :users, through: :memberships
  has_many :account_invitations, dependent: :destroy

  has_one_attached :logo

  enum :kind, %i[ personal team ], default: :personal

  before_create :generate_slug!

  # @return [String] the account's slug
  def slug_path
    "/#{AccountSlug.encode(slug)}"
  end

  def create_membership!(user)
    Membership.create!(user: user, account: self, role: :member)
  end

  private
    def generate_slug!
      loop do
        self.slug = Base32.generate(AccountSlug::LENGTH)
        break slug unless self.class.exists?(slug: slug)
      end
    end
end
