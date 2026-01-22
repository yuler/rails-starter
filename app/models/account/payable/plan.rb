class Account::Payable::Plan
  PLANS = {
    free_v1: { name: "Free", price: 0, provider: :creem, provider_product_id: "prod_1234567890" },
    starter_v1: { name: "Starter", price: 9900, provider: :creem, provider_product_id: "prod_1234567890" },
    pro_v1: { name: "Professional", price: 19900, provider: :creem, provider_product_id: "prod_1234567890" }
  }

  attr_reader :key, :name, :price, :provider, :provider_product_id

  class << self
    def all
      @all ||= PLANS.map { |key, properties| new(key: key, **properties) }
    end

    def free
      @free ||= find(:free_v1)
    end

    def paid
      @paid ||= find(:starter_v1)
    end

    def find(key)
      @all_by_key ||= all.index_by(&:key).with_indifferent_access
      @all_by_key[key]
    end

    def find_by_provider_product_id(provider_product_id)
      all.find { |plan| plan.provider_product_id == provider_product_id }
    end

    alias [] find
  end

  def initialize(key:, name:, price:, provider:, provider_product_id:)
    @key = key
    @name = name
    @price = price
    @provider = provider
    @provider_product_id = provider_product_id
  end

  def free?
    price.zero?
  end

  def paid?
    !free?
  end
end
