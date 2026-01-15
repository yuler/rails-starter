class Account < ApplicationRecord
  has_many :users, dependent: :destroy
  has_many :invitations, class_name: "Account::Invitation", dependent: :destroy
  has_one :owner_identity, class_name: "Identity", foreign_key: :personal_account_id
  has_one_attached :logo

  validates :name, presence: true

  scope :personal, -> { where(personal: true) }
  scope :team, -> { where(personal: false) }

  before_create :generate_slug

  # Check if this is a personal (solo) account
  def personal?
    personal
  end

  # Check if this is a team account
  def team?
    !personal?
  end

  class << self
    def create_with_owner(account:, owner:)
      transaction do
        new_account = create(**account)
        unless new_account.persisted?
          return new_account
        end

        new_account.tap do |account|
          account.users.create!(role: :system, name: "System")
          account.users.create!(**owner.with_defaults(role: :owner, verified_at: Time.current))
        end
      end
    end
  end

  def slug_path
    "/#{AccountSlug.encode(slug)}"
  end

  def system_user
    users.find_by!(role: :system)
  end

  private
    def generate_slug
      loop do
        self.slug = Base32.generate(AccountSlug::LENGTH)
        break slug unless self.class.exists?(slug: slug)
      end
    end
end
