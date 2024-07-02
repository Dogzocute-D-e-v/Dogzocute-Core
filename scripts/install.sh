#!/bin/bash

# Clear the screen and display the warning message
clear
echo "                 ⚠️  Warning ⚠️                        "
echo "    this is not a full install of Pterodactyl       "
echo "you will still need to do a few commands yourself"
echo "please read the description under the script command"
echo "      this script will continue in 10 seconds       "
sleep 10

# Update and install necessary packages
apt update
apt -y install software-properties-common curl apt-transport-https ca-certificates gnupg wget

# Add PHP repository
LC_ALL=C.UTF-8 add-apt-repository -y ppa:ondrej/php

# Add Redis repository and key
curl -fsSL https://packages.redis.io/gpg | gpg --dearmor -o /usr/share/keyrings/redis-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/redis-archive-keyring.gpg] https://packages.redis.io/deb $(lsb_release -cs) main" | tee /etc/apt/sources.list.d/redis.list

# Add MariaDB repository and key
curl -sS https://downloads.mariadb.com/MariaDB/mariadb_repo_setup | bash

# Update package lists after adding new repositories
apt update

# Install necessary packages including PHP extensions, MariaDB, Nginx, and Redis
apt -y install php8.1 php8.1-{common,cli,gd,mysql,mbstring,bcmath,xml,fpm,curl,zip} mariadb-server nginx tar unzip git redis-server

# Install Composer globally
curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Set up Pterodactyl Panel
mkdir -p /var/www/pterodactyl
cd /var/www/pterodactyl
curl -Lo panel.tar.gz https://github.com/pterodactyl/panel/releases/latest/download/panel.tar.gz
tar -xzvf panel.tar.gz
chmod -R 755 storage/* bootstrap/cache/
cp .env.example .env
composer install --no-dev --optimize-autoloader
php artisan key:generate --force
chown -R www-data:www-data /var/www/pterodactyl/*

# Enable and start Pterodactyl Queue Worker
cd /etc/systemd/system
wget https://src.dogzocute.space/scripts/extras/pteroq.service
systemctl enable --now pteroq.service

# Remove the default Nginx site configuration
rm /etc/nginx/sites-enabled/default

# Restart Nginx to apply changes
systemctl restart nginx

# Clear the screen and display the completion message
clear
echo "⚡ Finished installing the Packages & Configuring ⚡"
echo "   ⚠️  please refer to the script description ⚠️    "
echo "         Thanks for using a script made by"
echo "                💖 Dogzocute 💖"
sleep 3
clear

# Remove the script itself
rm -f install.sh
