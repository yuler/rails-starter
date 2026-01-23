# https://docs.creem.io/api-reference/introduction
class Account::Payable::Creem
  BASE_URL = ENV.fetch("CREEM_TEST_MODE").present? ? "https://test-api.creem.io" : "https://api.creem.io"

  def create_one_time_payment(plan_key:, **attributes)
    plan = Account::Payable::Plan.find(plan_key)

    payload = {
      product_id: plan.provider_product_id,
      customer: find_or_create_customer,
      units: 1,
      metadata: {
        account_id: Current.account.id,
        plan_key: plan_key
      }
    }
    payload[:request_id] = Current.request_id
    payload.merge!(attributes)

    # refs: https://docs.creem.io/api-reference/endpoint/create-checkout
    response = connection.post("/v1/checkouts", payload.compact_blank.to_json)

    Rails.logger.debug("[Creem] create_one_time_payment payload: #{payload.to_json}")
    Rails.logger.debug("[Creem] create_one_time_payment response: #{response.body}")

    if response.success?
      JSON.parse(response.body)
    else
      raise Account::Payable::CreemError.new(
        response_body: response.body,
        status_code: response.status
      )
    end
  rescue => e
    Rails.logger.error("[Creem] create_one_time_payment error: #{e.message}")
    raise Account::Payable::CreemError.new(
      "Error while creating payment: #{e.message}",
      response_body: nil,
      status_code: nil
    )
  end

  def create_subscription(body)
    response = connection.post("/v1/subscriptions") do |req|
      req.body = body.to_json
    end
    response.body
  rescue Faraday::Error => e
    Rails.logger.error("[Creem] create_subscription: #{e.message}")
    nil
  end

  private
    def connection
      @connection ||= Faraday.new(
        url: BASE_URL,
        headers: {
          "x-api-key" => "#{ENV.fetch("CREEM_API_KEY")}",
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

    # refs: https://docs.creem.io/api-reference/endpoint/get-customer
    def find_customer
      response = connection.get("/v1/customers", { email: Current.identity.email })
      if response.success?
        parsed_body = JSON.parse(response.body)
        parsed_body.slice("id")
      end
    rescue Faraday::Error => e
      Rails.logger.error("[Creem] find_customer: #{e.message}")
      nil
    end

    # NOTE: Creem currently doesn't support creating customers
    def create_customer
      nil
    end
end

class Account::Payable::CreemError < StandardError
  attr_reader :response_body, :status_code

  def initialize(message = nil, response_body: nil, status_code: nil)
    @response_body = response_body
    @status_code = status_code
    error_message = message || "Failed to create payment: #{parse_error_message(response_body)}"
    super(error_message)
  end

  private
    def parse_error_message(response_body)
      return "Unknown error" if response_body.blank?

      parsed = JSON.parse(response_body)
      parsed["message"] || parsed.to_json
    rescue JSON::ParserError
      response_body.to_s
    end
end
