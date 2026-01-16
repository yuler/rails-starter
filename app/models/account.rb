class Account < ApplicationRecord
  DEFAULT_SLUG_LENGTH = 8

  has_many :users, dependent: :destroy
  has_many :invitations, class_name: "Account::Invitation", dependent: :destroy
  has_one_attached :logo

  validates :name, presence: true

  before_create :generate_slug

  scope :personal, -> { where(personal: true) }
  scope :team, -> { where(personal: false) }

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

  def team?
    !personal?
  end

  def slug_path
    AccountSlug.encode(slug)
  end

  def system_user
    users.find_by!(role: :system)
  end

  private
    def generate_slug
      loop do
        self.slug = Base32.generate(DEFAULT_SLUG_LENGTH)
        break slug unless self.class.exists?(slug: slug)
      end
    end
end
