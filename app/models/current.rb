class Current < ActiveSupport::CurrentAttributes
  attribute :session
  attribute :account
  delegate :user, to: :session, allow_nil: true

  # Request attributes
  attribute :http_method, :request_id, :user_agent, :ip_address, :referrer


  def with_account(value, &)
    with(account: value, &)
  end

  def without_account(&)
    with(account: nil, &)
  end
end
