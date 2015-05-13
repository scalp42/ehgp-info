# eHGP Szene

## Installation

    bundle install --without development:test
    MOUNT_PATH=/ehgp rackup -o 0.0.0.0 -p 13051 -E production

## Development

    bundle install
    shotgun -o 0.0.0.0 -p 4567 -u /ehgp-dev

