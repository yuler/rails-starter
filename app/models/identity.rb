class Identity < ApplicationRecord
  has_secure_password

  has_many :sessions, dependent: :destroy
  has_many :users, dependent: :nullify
  has_many :accounts, through: :users

  # TODO:?
  has_one_attached :avatar

  before_destroy :deactivate_users, prepend: true

  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }
  normalizes :email, with: ->(value) { value.strip.downcase.presence }

  # def self.find_by_permissable_access_token(token, method:)
  #   if (access_token = AccessToken.find_by(token: token)) && access_token.allows?(method)
  #     access_token.identity
  #   end
  # end

  # def send_magic_link(**attributes)
  #   attributes[:purpose] = attributes.delete(:for) if attributes.key?(:for)

  #   magic_links.create!(attributes).tap do |magic_link|
  #     MagicLinkMailer.sign_in_instructions(magic_link).deliver_later
  #   end
  # end

  def full_name
    email.split("@").first
  end

  private
    def deactivate_users
      users.find_each(&:deactivate)
    end
end
