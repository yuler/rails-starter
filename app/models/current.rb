class Current < ActiveSupport::CurrentAttributes
  attribute :session, :user, :identity, :account, :personal_account
  attribute :http_method, :request_id, :user_agent, :ip_address, :referrer

  def account
    self.account || self.personal_account
  end

  def session=(value)
    super(value)

    if value.present?
      self.identity = session.identity
      self.personal_account = session.identity.personal_account
    end
  end

  def identity=(identity)
    super(identity)

    if identity.present?
      self.user = identity.users.find_by(account: account)
    end
  end

  def with_account(value, &)
    with(account: value, &)
  end

  def without_account(&)
    with(account: nil, &)
  end
end
