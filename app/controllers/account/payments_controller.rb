class Account::PaymentsController < ApplicationController
  before_action :ensure_admin
  # before_action :set_stripe_session, only: :show

  def new
  end

  def create
    # @payment = Current.account.create_payment(payment_params)

    # if @payment.save
    #   redirect_to account_payment_path, notice: "Payment created."
    # else
    #   render :new, status: :unprocessable_entity
    # end
    #
    Account::Payable.set_provider(:creem)
    response = Account::Payable.create_charge(plan_key: plan_param.key)
    p response

    # session = Stripe::Checkout::Session.create \
    #   customer: find_or_create_stripe_customer,
    #   mode: "subscription",
    #   line_items: [ { price: plan_param.stripe_price_id, quantity: 1 } ],
    #   success_url: account_subscription_url + "?session_id={CHECKOUT_SESSION_ID}",
    #   cancel_url: account_subscription_url,
    #   metadata: { account_id: Current.account.id, plan_key: plan_param.key },
    #   automatic_tax: { enabled: true },
    #   tax_id_collection: { enabled: true },
    #   billing_address_collection: "required",
    #   customer_update: { address: "auto", name: "auto" }

    # redirect_to session.url, allow_other_host: true
  end

  private
    def plan_param
      @plan_param ||= Account::Payable::Plan.find(params[:plan_key]) || Account::Payable::Plan.paid
    end

    def set_stripe_session
      # @stripe_session = Stripe::Checkout::Session.retrieve(params[:session_id])
    end

    def payment_params
      params.require(:payment).permit(:amount, :currency, :description)
    end

    def set_payment
      @payment = Current.account.payments.find(params[:id])
    end
end
