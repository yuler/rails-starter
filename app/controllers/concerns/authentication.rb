# refs: https://twitter.com/dhh/status/1729645394454339613
module Authentication
  extend ActiveSupport::Concern

  included do
    before_action :require_authentication
    helper_method :signed_in?
  end

  class_methods do
    def allow_unauthenticated_access(**options)
      skip_before_action :require_authentication, **options
    end
  end

  private
    def signed_in?
      Current.user.present?
    end

    def require_authentication
      restore_authentication || request_authentication
    end

    def restore_authentication
      if user = User.find_by(id: cookies.signed[:user_id])
        authentication_as(user)
      end
    end

    def request_authentication
      session[:return_to_after_authenticating] = request.url
      redirect_to new_session_path
    end

    def authentication_as(user)
      Current.user = user
      cookies.signed.permanent[:user_id] = { value: user.id, httponly: true, same_site: :lax }
    end

    def post_authenticating_url
      session.delete(:return_to_after_authenticating) || root_path
    end

    def reset_authentication
      cookies.delete(:user_id)
    end
end
