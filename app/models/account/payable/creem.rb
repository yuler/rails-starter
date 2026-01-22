# https://docs.creem.io/api-reference/introduction
class Account::Payable::Creem
  BASE_URL = ENV.fetch("CREEM_TEST_MODE", false) ? "https://test-api.creem.io" : "https://api.creem.io"

  def create_one_time_payment(plan_key:, **attributes)
    plan = Account::Payable::Plan.find(plan_key)

    return_url = "#{ENV.fetch("SITE_DOMAIN")}/webhooks/creem"

    # refs: https://docs.creem.io/api-reference/endpoint/create-checkout
    response = connection.post("/v1/checkout/sessions") do |req|
      # Create payload
      payload = {
        product_id: plan.provider_product_id,
        customer: find_or_create_customer,
        units: 1,
        return_url: return_url,
        metadata: {
          account_id: Current.account.id,
          plan_key: plan_key
        }
      }

      payload[:request_id] = Current.request_id
      payload.merge!(attributes)

      req.body = payload.compact_blank.to_json
    end
    response.body
  end

  def create_subscription(body)
    response = connection.post("/v1/subscriptions") do |req|
      req.body = body.to_json
    end
    response.body
  end

  private
    def connection
      @connection ||= Faraday.new(
        url: BASE_URL,
        headers: {
          "Authorization" => "Bearer #{ENV.fetch("CREEM_API_KEY")}",
          "Content-Type" => "application/json",
          "Accept" => "application/json"
        }.compact,
        request: {
          open_timeout: 5,
          timeout: 10
        }
      )
    end

    def find_or_create_customer
      find_customer || create_customer
    end

    def find_customer
      customer = connection.get("/v1/customers") do |req|
        req.body = {
          email: Current.identity.email
        }.to_json
      end
      customer.body
    end

    def create_customer
      # connection.post("/v1/customers") do |req|
      #   req.body = {
      #     email: Current.account.email
      #   }.to_json
      # end
      # customer.body
      nil
    end
end
