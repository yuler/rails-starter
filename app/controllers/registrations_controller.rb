class RegistrationsController < ApplicationController
  disallow_account_scope
  allow_unauthenticated_access only: %i[ new create ]
  rate_limit to: 10, within: 3.minutes, only: :create, with: -> { redirect_to new_registration_path, alert: "Registration rate limit exceeded. Please try again later." }

  before_action :set_invite_code

  def new
  end

  def create
    @identity = Identity.new(identity_params)

    # TODO: invite_code optional from settings, Move to a sign up model
    ActiveRecord::Base.transaction do
      if @identity.invalid?
        render :new, status: :unprocessable_entity and return
      elsif !InviteCode.claim!(@invite_code)
        @identity.errors.add(:base, "Invalid invite code.")
        render :new, status: :unprocessable_entity and return
      elsif @identity.save
        start_new_session_for @identity
        redirect_to after_authentication_url and return
      else
        raise ActiveRecord::Rollback
      end
    end

    render :new, status: :unprocessable_entity
  end

  private
    def set_invite_code
      @invite_code = params[:invite_code]
    end

    def identity_params
      params.permit(:email, :password)
    end
end
