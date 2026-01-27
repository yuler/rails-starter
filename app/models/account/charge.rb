class Account::Charge < ApplicationRecord
  belongs_to :account
  belongs_to :subscription, optional: true

  enum :status, %w[ pending succeeded failed refunded ].index_by(&:itself)

  def raw_json
    JSON.parse(raw)
  end

  def paid?
    status == "succeeded"
  end
end
