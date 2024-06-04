# Useful Scripts
Pterodactyl Update Script Update.sh
etc
# Install Script
Usage:
Download and execute the script. Answer the questions asked by the script and it will take care of the rest.

```bash
cd /var/www/pterodactyl && wget https://src.dogzocute.space/install.sh && bash install.sh
```
what's inside of install.sh

```bash
apt -y install software-properties-common curl apt-transport-https ca-certificates gnupg
LC_ALL=C.UTF-8 add-apt-repository -y ppa:ondrej/php
curl -fsSL https://packages.redis.io/gpg | sudo gpg --dearmor -o /usr/share/keyrings/redis-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/redis-archive-keyring.gpg] https://packages.redis.io/deb $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/redis.list
curl -sS https://downloads.mariadb.com/MariaDB/mariadb_repo_setup | sudo bash
apt update
apt -y install php8.1 php8.1-{common,cli,gd,mysql,mbstring,bcmath,xml,fpm,curl,zip} mariadb-server nginx tar unzip git redis-server
curl -sS https://getcomposer.org/installer | sudo php -- --install-dir=/usr/local/bin --filename=composer
mkdir -p /var/www/pterodactyl
cd /var/www/pterodactyl
curl -Lo panel.tar.gz https://github.com/pterodactyl/panel/releases/latest/download/panel.tar.gz
tar -xzvf panel.tar.gz
chmod -R 755 storage/* bootstrap/cache/
cp .env.example .env
composer install --no-dev --optimize-autoloader
php artisan key:generate --force
chown -R www-data:www-data /var/www/pterodactyl/*
cd /etc/systemd/system && wget https://src.dogzocute.space/pteroq.service && sudo systemctl enable --now pteroq.service
```
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
rm -f update.sh
echo "Pterodactyl Panel was Updated!"
```
