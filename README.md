# Coconut Shop Demo

Demo app for Flatfile

## Setup

1. Install [Nix](https://nixos.wiki/wiki/Nix_Installation_Guide) & [direnv](https://direnv.net/docs/installation.html)
2. Run `docker-compose up -d` in root directory to run containers
3. Run `mix setup` to configure database and create SSL certs

## Running

1. Use `make run` to start server and visit [`localhost:4000`](https://localhost:4000) from your browser.

## Tests

1. Run with `make test`

