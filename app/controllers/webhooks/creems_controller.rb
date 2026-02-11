class Webhooks::CreemsController < ApplicationController
  allow_unauthenticated_access
  skip_forgery_protection

  def create
    body = verify_signature
    save_webhook_event(body)

    checkout_id = body.dig("object", "id")
    # https://docs.creem.io/code/webhooks#event-types
    event_type = body["eventType"]
    case event_type
    when "checkout.completed"
      charge = Account::Payable.find_charge(provider: :creem, checkout_id: checkout_id)
      charge&.update!(status: "succeeded")
    else
      Rails.logger.warn "Unhandled event type: #{event_type}"
    end
    head :ok
  end

  private
    # refs: https://docs.creem.io/code/webhooks#webhook-signatures
    # Returns request body on success; raises on verification failure.
    def verify_signature
      payload = request.body.read
      request.body.rewind

      signature = request.headers["Creem-Signature"]
      secret = ENV["CREEM_WEBHOOK_SECRET"]

      raise ArgumentError, "Missing Creem-Signature or CREEM_WEBHOOK_SECRET" if signature.blank? || secret.blank?

      expected = OpenSSL::HMAC.hexdigest("SHA256", secret, payload)
      raise ActiveSupport::MessageVerifier::InvalidSignature, "Creem webhook signature mismatch" unless ActiveSupport::SecurityUtils.secure_compare(expected, signature)

      JSON.parse(payload)
    rescue OpenSSL::HMAC::Error => e
      Rails.logger.error "Creem webhook signature verification failed: #{e.message}"
      raise
    end

    # save to database
    def save_webhook_event(body)
      event_type = body["eventType"]
      account_id = body.dig("object", "metadata", "account_id")

      if account_id.blank?
        Rails.logger.error "Missing account_id in metadata"
        return
      end

      Account::PaymentWebhook.create!(
        account: Account.find(account_id),
        provider: :creem,
        event_type: event_type,
        raw: body.to_json
      )
    end
end
