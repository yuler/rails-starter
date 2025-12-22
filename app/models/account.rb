class Account < ApplicationRecord
  has_many :users, dependent: :destroy
  has_many :account_invitations, dependent: :destroy
  has_one_attached :logo

  before_create :generate_slug!

  validates :name, presence: true

  class << self
    def create_with_owner(account:, owner:)
      create!(**account).tap do |account|
        account.users.create!(role: :system, name: "System")
        account.users.create!(**owner.with_defaults(role: :owner, verified_at: Time.current))
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

  private
    def generate_slug!
      loop do
        self.slug = Base32.generate(AccountSlug::LENGTH)
        break slug unless self.class.exists?(slug: slug)
      end
    end
end
