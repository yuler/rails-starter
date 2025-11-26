class Account < ApplicationRecord
  belongs_to :user

  has_many :memberships, dependent: :delete_all
  has_many :users, through: :memberships

  has_one_attached :logo

  enum :kind, %i[ personal team ], default: :personal
end
