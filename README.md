# eHGP Szene

## Installation

    cp config/thin.example.yml config/thin.yml
    # edit config/thin.yml
    bundle install --deployment
    bundle exec thin start -C config/thin.yml

## Development

    bundle install
    shotgun -o 0.0.0.0 -p 4567 -u /ehgp-dev

