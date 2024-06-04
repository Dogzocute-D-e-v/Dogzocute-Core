clear
echo "Updating panel ⚡"
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
clear
echo "             ✔️  Panel Updated ✔️      "
echo "         Thanks for using a script made by"
echo "                💖 Dogzocute 💖"
rm -f update.sh
