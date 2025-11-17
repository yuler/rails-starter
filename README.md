# rails-starter

An opinionated template for rapidly starting new Rails project

## ✨ Features

- Uses PostgreSQL instead of the default SQLite database
- Uses `jsbundling-rails`, `cssbundling-rails`, and Bun for frontend asset bundling
- Includes authentication system via `rails generate authentication`
- Includes api controllers with JWT authentication
- Includes [Faraday](https://github.com/lostisland/faraday) for making third-party service requests; see an example in [github_client.rb](./lib/github_client.rb)
- Add [script/icon_download](./script/icon_download.rb) quick download from [lucide](https://lucide.dev)

## 🛠️ Getting Started

```bash
gh repo create <your_project_name> --template yuler/rails-starter --private --clone
# or
git clone git@github.com:yuler/rails-starter.git <your_project_name>
cd <your_project_name>
bin/setup
bin/dev
```

## 🚂 Other rails templates

- https://github.com/yshmarov/moneygun
- https://github.com/bullet-train-co/bullet_train
- https://github.com/ryanckulp/speedrail
- https://github.com/rootstrap/rails_api_base
- https://jumpstartrails.com/

## 💎 Other rails open source

- https://github.com/campsite/campsite
- https://github.com/maybe-finance/maybe