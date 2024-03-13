# GitHub OAuth
# refs: https://docs.github.com/en/apps/oauth-apps/building-oauth-apps/authorizing-oauth-apps
class AuthorizationsController < ApplicationController
  allow_unauthenticated_access only: [ :create ]

  def create
    redirect_to github_oauth_url(scope: "user:email"), allow_other_host: true
  end

  private
    def github_oauth_url(**params)
      redirect_uri = "http://localhost:3000/callback"
      scope = params[:scope]
      "https://github.com/login/oauth/authorize?client_id=#{ENV["GITHUB_CLIENT_ID"]}&redirect_uri=#{redirect_uri}&scope=#{scope}&state=#{params[:state]}"
    end
end
