class Api::V1::TokensController < Api::V1::BaseController
  # allow_api_unauthenticated_access only: :create
  skip_api_authentication only: :create

  def create
    @user = User.authenticate_by(user_params)

    return render_json_created(json: { token: generate_user_jwt_token(@user) }) if @user
    render_json_unauthorized
  end

  private
    def user_params
      params.permit(:email, :password)
    end
end
