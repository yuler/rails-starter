# PostgreSQL Setup Guide

- Update the database driver in [Gemfile](../Gemfile) to `pg`
- Modify [.env.example] to include PostgreSQL environment variables
- Use [config/database.postgres.yml](../config/database.postgres.yml) to overwrite `database.yml`
- Use [Dockerfile.postgres](../Dockerfile.postgres) to overwrite `Dockerfile`
- Regenerate the database schema for PostgreSQL

```bash
rails solid_cache:install
rails solid_queue:install
rails solid_cable:install
rails db:drop db:create db:migrate
```

- Use [compose.example.postgres.yml](../compose.example.postgres.yml) for Docker Compose deployment
