clear
echo "                 ⚠️  Warning ⚠️                        "
echo "    this is not a full install of Pterodactyl       "
echo "you will still need to do a few commands you're self"
echo "please read the description under the script command"
echo "      this script will continue in 45 seconds       "
sleep 45
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
cd /etc/systemd/system && wget https://src.dogzocute.space/scripts/extras/pteroq.service && sudo systemctl enable --now pteroq.service
rm /etc/nginx/sites-enabled/default
clear
echo "⚡ Finished installing the Packages & Configuring ⚡"
echo "   ⚠️  please refer to the script description ⚠️    "
echo "         Thanks for using a script made by"
echo "                💖 Dogzocute 💖"
sleep 5
clear
rm -f install.sh
