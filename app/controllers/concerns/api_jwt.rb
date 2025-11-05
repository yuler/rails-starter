require "jwt"

module ApiJwt
  extend ActiveSupport::Concern

  SECRET_KEY = Rails.application.secret_key_base

  def generate_user_jwt_token(user)
    jwt_encode(user_id: user.id)
  end

  def authenticate_user_jwt_token!(token)
    decoded_token = jwt_decode(token)
    raise JWT::DecodeError, "Invalid token" unless decoded_token["user_id"].present?
    User.find(decoded_token["user_id"])
  end

  private
    def jwt_encode(payload, expires_in: 1.years.from_now)
      payload[:exp] = expires_in.to_i
      JWT.encode(payload, SECRET_KEY, "HS256")
    end

    def jwt_decode(token)
      JWT.decode(token, SECRET_KEY, true, { algorithm: "HS256" })[0]
    end
end
