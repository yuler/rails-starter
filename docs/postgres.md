# PostgreSQL Setup Guide

- Update the database driver in [Gemfile](../Gemfile) to `pg`
- Modify [.env.example] to include PostgreSQL environment variables
- Use [config/database.postgres.yml](../config/database.postgres.yml) to overwrite `database.yml`
- Use [compose.example.postgres.yml](../compose.example.postgres.yml) for Docker Compose deployment
