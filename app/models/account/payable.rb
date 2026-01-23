module Account::Payable
  extend ActiveSupport::Concern

  attr_reader :provider
  # enum :provider, %w[ stripe wechat creem ].index_by(&:itself)

  included do
    has_many :subscriptions, class_name: "Account::Subscription", foreign_key: :account_id, dependent: :destroy
  end

  class << self
    def provider
      @provider ||= :stripe
    end

    def set_provider(provider)
      @provider = provider
    end

    def create_charge(plan_key:, **attributes)
      # TODO: insert the payment record to the database
      # creem
      if provider == :creem
        Account::Payable::Creem.new.create_one_time_payment(plan_key: plan_key)
      end
    end

    def create_subscription(provider:, plan_key:)
      Account::Subscription.create!(provider: provider, plan_key: plan_key)
    end
  end
end
