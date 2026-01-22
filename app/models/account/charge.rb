class Account::Charge < ApplicationRecord
  belongs_to :account
  belongs_to :subscription, optional: true

  enum :status, %w[ pending succeeded failed refunded expired ].index_by(&:itself)
end
