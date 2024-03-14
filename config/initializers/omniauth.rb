# refs: https://github.com/omniauth/omniauth-github?tab=readme-ov-file#basic-usage-rails
Rails.application.config.middleware.use OmniAuth::Builder do
  provider :developer unless Rails.env.production?
  provider :github, ENV["GITHUB_CLIENT_ID"], ENV["GITHUB_CLIENT_SECRET"], scope: "user:email"

  on_failure do |env|
    error_strategy = env["omniauth.error.strategy"]
    error_type = env["omniauth.error.type"]
    error_message = env["omniauth.error.message"]

    Rails.logger.error "OAuth2 #{error_strategy} authentication error: #{error_type} - #{error_message}"

    Rack::Response.new([ "OAuth2 authentication failed." ], 401).finish
  end
end
