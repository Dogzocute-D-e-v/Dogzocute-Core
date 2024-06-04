# Useful Scripts
Pterodactyl Update Script Update.sh
etc

# Update Script
Usage:
Download and execute the script. Answer the questions asked by the script and it will take care of the rest.

```bash
cd /var/www/pterodactyl && wget https://src.dogzocute.space/update.sh && bash update.sh
```

what's inside of update.sh

```bash
php artisan down
curl -L https://github.com/pterodactyl/panel/releases/latest/download/panel.tar.gz | tar -xzv
chmod -R 755 storage/* bootstrap/cache
composer install --no-dev --optimize-autoloader
php artisan view:clear
php artisan config:clear
php artisan migrate --seed --force
chown -R www-data:www-data /var/www/pterodactyl/*
php artisan queue:restart
php artisan up
```
