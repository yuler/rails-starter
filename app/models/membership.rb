class Membership < ApplicationRecord
  belongs_to :account
  belongs_to :user

  enum :role, %w[member admin].index_by(&:itself)
end
