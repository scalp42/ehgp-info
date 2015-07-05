# eHGP Szene

## Setup

After a first-time checkout, run `script/setup` to install all dependencies and set up the entire application.

After a fresh pull, run `script/update` to make sure everything is up to date.

## Development

After setup, run `script/server` to run the server in dev mode (except for when `$RACK_ENV` is set to `production`)

## Production

Deploy with `script/deploy` or `script/deploy <stage>` (stage defaults to `production`.)

The deployment script should handle starting of the server itself. If not try `RACK_ENV=production script/server`.

## Apache Setup

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
