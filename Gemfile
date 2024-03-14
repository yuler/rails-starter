source "https://rubygems.org"
# Or use a mirror
# source "https://gems.ruby-china.com"

git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby file: ".ruby-version"

# Rails
gem "rails", github: "rails/rails", branch: "main"

# Drivers
gem "sqlite3", "~> 1.4"
gem "redis", ">= 4.0.1"

# Deployment
gem "puma", ">= 5.0"
gem "bootsnap", require: false

# Assets
gem "importmap-rails"
gem "propshaft"
gem "tailwindcss-rails"

# Hotwire
gem "stimulus-rails"
gem "turbo-rails", github: "hotwired/turbo-rails", branch: "main"

# Media handling
# gem "image_processing", "~> 1.2"

# OAuth2
gem "omniauth"
gem "omniauth-rails_csrf_protection"
gem "omniauth-github", "~> 2.0.0"

# Other
gem "bcrypt", "~> 3.1.7"
gem "jbuilder"
gem "tzinfo-data", platforms: %i[ windows jruby ]

group :development, :test do
  gem "dotenv"
  gem "debug", platforms: %i[ mri windows ]
  gem "letter_opener"
  gem "brakeman", require: false
  gem "rubocop-rails-omakase", require: false
end

group :development do
  gem "web-console"
  gem "hotwire-livereload"
  gem "ruby-lsp-rails"
end

group :test do
  gem "capybara"
  gem "selenium-webdriver"
end
