class JoinsController < ApplicationController
  include Authentication::Skip
  skip_forgery_protection

  allow_unauthenticated_access
  allow_unauthorized_access

  before_action :set_join_code

  def show
    @account = @join_code.account
  end

  def create
    @join_code.redeem_if do |account|
      if Current.identity
        user = account.users.find_or_initialize_by(identity: Current.identity)
        if user.new_record?
          user.name = Current.identity.full_name
          user.role = :member
          user.verified_at = Time.current
          user.save!
          true
        else
          @already_member = true
          false
        end
      else
        session[:pending_join_code] = @join_code.code
        redirect_to new_session_path and return
      end
    end

    if @already_member
      redirect_to root_path(script_name: @join_code.account.slug_path), notice: "You are already a member of this account."
    else
      redirect_to root_path(script_name: @join_code.account.slug_path), notice: "You have successfully joined #{@join_code.account.name}!"
    end
  end

  private
    def set_join_code
      @join_code = Account::JoinCode.find_by!(code: params[:code])
    rescue ActiveRecord::RecordNotFound
      redirect_to root_path, alert: "Invalid or expired join code."
    end
end
