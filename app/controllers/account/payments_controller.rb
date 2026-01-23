class Account::PaymentsController < ApplicationController
  before_action :ensure_admin
  before_action :set_checkout, only: :show

  def show
    redirect_to home_index_path(anchor: "pricing") if @checkout.blank?
  end

  def create
    checkout = Account::Payable.create_charge(plan_key: plan_param.key, success_url: account_payment_url)
    redirect_to checkout.fetch("checkout_url"), allow_other_host: true
  rescue Account::Payable::CreemError => e
    Rails.logger.error("[PaymentsController] Payment creation failed: #{e.message}")
    flash[:alert] = "Failed to create payment: #{e.message}"
    # redirect back to previous page, or to home page if no referer
    redirect_back_or_to root_path
  end

  private
    def plan_param
      @plan_param ||= Account::Payable::Plan.find(params[:plan_key]) || Account::Payable::Plan.paid
    end

    def set_checkout
      @checkout = Account::Payable.find_checkout(id: params[:checkout_id]) if params[:checkout_id].present?
    end

    def payment_params
      params.require(:payment).permit(:amount, :currency, :description)
    end

    def set_payment
      @payment = Current.account.payments.find(params[:id])
    end
end
