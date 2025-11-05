# `rails generate controller api/v1/users --parent=Api::V1::BaseController`

class Api::V1::BaseController < ApplicationController
  include ApiJwt

  # Setup rate limit, refs: https://api.rubyonrails.org/classes/ActionController/RateLimiting/ClassMethods.html
  rate_limit to: 10, within: 1.minute, with: -> { render_json_too_many_requests }

  # Skip regular session-based authentication for API
  skip_authentication

  # Skip CSRF protection for API endpoints
  skip_before_action :verify_authenticity_token

  before_action :api_authentication

  private
    def api_authentication
      return if api_jwt_authenticated?
      render_json_unauthorized
    end

    def api_jwt_authenticated?
      bearer_token = request.headers["Authorization"]&.split(" ")&.last
      query_token = request.query_parameters["token"]
      token = query_token || bearer_token

      @current_user = authenticate_user_jwt_token!(token)
    rescue JWT::DecodeError => e
      render_json_unauthorized(e.message)
    end

    def render_json_unauthorized(message = "You need to authenticate to access this resource, please check the documentation for more details. https://example.com/docs")
      render json: { error: "unauthorized", message: message }, status: :unauthorized
    end

    def render_json_too_many_requests
      render json: { error: "too many requests", message: "You have exceeded the rate limit. Please try again later." }, status: :too_many_requests
    end
end
