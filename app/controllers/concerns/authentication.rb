module Authentication
  extend ActiveSupport::Concern

  included do
    before_action :require_authentication
    # before_action: set_sentry_context, TODO:
    helper_method :authenticated?
  end

  class_methods do
    def allow_unauthenticated_access(**options)
      skip_before_action :require_authentication, **options
    end

    alias_method :skip_authentication, :allow_unauthenticated_access
  end

  private
    def authenticated?
      resume_session
    end

    def require_authentication
      resume_session || request_authentication
    end

    def resume_session
      Current.session ||= find_session_by_cookie
    end

    def find_session_by_cookie
      Session.find_by(id: cookies.signed[:session_id]) if cookies.signed[:session_id]
    end

    # def resume_account
    #   Current.account ||= find_account_by_cookie
    # end

    # def find_account_by_cookie
    #   Current.user.accounts.find_by(id: cookies.signed[:account_id]) if cookies.signed[:account_id]
    # end

    # def switch_to_account(account_id)
    #   Current.account = Account.find(account_id)
    #   cookies.signed.permanent[:account_id] = { value: account_id, httponly: true, same_site: :lax }
    # end

    def request_authentication
      session[:return_to_after_authenticating] = request.url
      redirect_to new_session_path
    end

    def after_authentication_url
      session.delete(:return_to_after_authenticating) || root_url
    end

    def start_new_session_for(user)
      user.sessions.create!(user_agent: request.user_agent, ip_address: request.remote_ip).tap do |session|
        Current.session = session
        cookies.signed.permanent[:session_id] = { value: session.id, httponly: true, same_site: :lax }

        # Current.account = user.personal_account
        # cookies.signed.permanent[:account_id] = { value: user.personal_account.id, httponly: true, same_site: :lax }
      end
    end

    def terminate_session
      Current.session.destroy
      cookies.delete(:session_id)
      # cookies.delete(:account_id)
    end
end
