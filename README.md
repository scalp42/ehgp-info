# eHGP Szene

## Installation

```bash
bundle install --deployment
bundle exec thin start -C config/thin.yml -p 13051
```

## Development

```bash
bundle install
shotgun -o 0.0.0.0 -p 4567 -u /ehgp-dev
```

## Apache Setup**

```apache
Alias /ehgp /path/to/ehgp-info/public
<Location /ehgp>
    RewriteEngine On
    RewriteCond %{REQUEST_FILENAME} !\.(css|js|woff2?|eot|ttf|svg)$
    RewriteRule . http://127.0.0.1:13051%{REQUEST_URI} [P,QSA,L]
</Location>
Alias /ehgp-dev /path/to/ehgp-info/public
<Location /ehgp-dev>
    RewriteEngine On
    RewriteCond %{REQUEST_FILENAME} !\.(css|js|woff2?|eot|ttf|svg)$
    RewriteRule . http://127.0.0.1:4567%{REQUEST_URI} [P,QSA,L]
</Location>
```
