class Account < ApplicationRecord
  belongs_to :user

  has_many :memberships, dependent: :delete_all
  has_many :users, through: :memberships
  has_many :account_invitations, dependent: :destroy

  has_one_attached :logo

  enum :kind, %i[ personal team ], default: :personal

  def create_membership!(user)
    Membership.create!(user: user, account: self, role: :member)
  end
end
