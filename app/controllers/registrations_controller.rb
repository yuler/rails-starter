class RegistrationsController < ApplicationController
  allow_unauthenticated_access only: %i[ new create ]
  rate_limit to: 10, within: 3.minutes, only: :create, with: -> { redirect_to new_registration_path, alert: "Registration rate limit exceeded. Please try again later." }

  before_action :set_invite_code, only: %i[ new create ]

  def new
  end

  def create
    @user = User.new(user_params)

    ActiveRecord::Base.transaction do
      unless InviteCode.claim!(@invite_code)
        @user.errors.add(:base, "Invalid invite code.")
        render :new, status: :unprocessable_entity and return
      end

      if @user.save
        start_new_session_for @user
        redirect_to after_authentication_url and return
      end

      raise ActiveRecord::Rollback
    end

    render :new, status: :unprocessable_entity
  end

  private
    def set_invite_code
      @invite_code = params[:invite_code]
    end

    def user_params
      params.permit(:email, :password)
    end
end
