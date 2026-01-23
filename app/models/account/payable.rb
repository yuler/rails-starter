module Account::Payable
  extend ActiveSupport::Concern

  PROVIDERS = %w[stripe wechat creem].freeze

  included do
    has_many :subscriptions, class_name: "Account::Subscription", foreign_key: :account_id, dependent: :destroy
  end

  class << self
    def create_charge(provider: nil, plan_key:, **attributes)
      plan = Plan.find(plan_key)
      provider ||= plan.provider.to_sym

      provider_class(provider).new.create_one_time_payment(plan_key: plan_key, **attributes)
    end

    def create_subscription(provider:, plan_key:)
      Account::Subscription.create!(provider: provider, plan_key: plan_key)
    end

    def find_checkout(provider:, id:)
      provider_class(provider).new.find_checkout(id: id)
    end

    private
      def provider_class(provider)
        case provider.to_sym
        when :creem
          Creem
        when :stripe
          Stripe
        when :wechat
          Wechat
        else
          raise ArgumentError, "Unknown provider: #{provider}. Supported providers: #{PROVIDERS.join(', ')}"
        end
      end
  end
end
