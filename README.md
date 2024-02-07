# rails-starter

> Rails app starter template

```bash
rails new --main rails-starter -a propshaft -c tailwindcss --database sqlite3
```

## Development

```bash
# start redis server
docker run -d --name redis -p 6379:6379 redis
# dev mode
./bin/dev
```

## Features

- 🔐 Simple authentication w/ email & password
- 🔄 Automatically reload Hotwire Turbo power by [hotwire-livereload](https://github.com/kirillplatonov/hotwire-livereload)

## TODO

- [ ] [web-push](https://github.com/pushpad/web-push)
- <https://github.com/hotwired/turbo/pull/1019>
- <https://github.com/hotwired/turbo-rails/pull/499>
