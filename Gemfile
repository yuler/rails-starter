source "https://rubygems.org"

git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby file: ".ruby-version"

# Rails
gem "rails", "~> 8.1.1"

# Rails solid database gems
gem "solid_cache"
gem "solid_queue"
gem "solid_cable"

# Drivers
gem "pg", "~> 1.1"
# gem "sqlite3", "~> 1.4"

# Deployment
gem "puma", ">= 5.0"
gem "bootsnap", require: false

# Assets
gem "propshaft"
gem "jsbundling-rails"
gem "cssbundling-rails"

# Hotwire
gem "turbo-rails"
gem "stimulus-rails"

# Media handling
gem "image_processing", "~> 1.2"

# API
gem "jwt"
gem "jbuilder"

# Others
gem "bcrypt", "~> 3.1.7"
gem "tzinfo-data", platforms: %i[ windows jruby ]

# Deploy
gem "kamal", require: false
gem "thruster", require: false

group :development, :test do
  gem "dotenv"
  gem "debug", platforms: %i[ mri windows ], require: "debug/prelude"
  gem "letter_opener"
  gem "bundler-audit", require: false
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
