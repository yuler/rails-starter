class Account < ApplicationRecord
  belongs_to :user

  has_one_attached :logo

  enum :kind, %i[ personal team ], default: :personal
end
