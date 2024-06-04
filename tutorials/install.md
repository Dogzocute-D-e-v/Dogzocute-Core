# Database Configuration

You will need a database setup and a user with the correct permissions created for that database before continuing any further. See below to create a user and database for your Pterodactyl panel quickly.

```sql
mysql -u root -p

# Remember to change 'yourPassword' below to be a unique password
CREATE USER 'pterodactyl'@'127.0.0.1' IDENTIFIED BY 'yourPassword';
CREATE DATABASE panel;
GRANT ALL PRIVILEGES ON panel.* TO 'pterodactyl'@'127.0.0.1' WITH GRANT OPTION;
exit
```
recommended things to do for you mysql db

# Allowing external database access
Chances are you'll need to allow external access to this MySQL instance in order to allow servers to connect to it. To do this, open ``my.cnf``, which varies in location depending on your OS and how MySQL was installed. You can type ``find /etc -iname my.cnf`` to locate it.

Open ``my.cnf``, add text below to the bottom of the file and save it:
```cnf
[mysqld]
bind-address=0.0.0.0
```

# Environment Configuration

Pterodactyl's core environment is easily configured using a few different CLI commands built into the app. This step will cover setting up things such as sessions, caching, database credentials, and email sending.

```bash
php artisan p:environment:setup
php artisan p:environment:database

# To use PHP's internal mail sending (not recommended), select "mail". To use a
# custom SMTP server, select "smtp".
php artisan p:environment:mail
```

#Database Setup

Now we need to setup all of the base data for the Panel in the database you created earlier. The command below may take some time to run depending on your machine. Please DO NOT exit the process until it is completed! This command will setup the database tables and then add all of the Nests & Eggs that power Pterodactyl.

```bash
php artisan migrate --seed --force
```

# Add The First User

You'll then need to create an administrative user so that you can log into the panel. To do so, run the command below. At this time passwords must meet the following requirements: 8 characters, mixed case, at least one number.

```bash
php artisan p:user:make
```
# Crontab Configuration

The first thing we need to do is create a new cronjob that runs every minute to process specific Pterodactyl tasks, such as session cleanup and sending scheduled tasks to daemons. You'll want to open your crontab using ``sudo crontab -e`` and then paste the line below.

```bash
* * * * * php /var/www/pterodactyl/artisan schedule:run >> /dev/null 2>&1
```

If you are using redis for your system, you will want to make sure to enable that it will start on boot. You can do that by running the following command:
```bash
sudo systemctl enable --now redis-server
```

# Webserver Configuration
we are going to use Nginx with ssl

do:
```bash
nano /etc/nginx/sites-available/pterodactyl.conf
```
Now, you should paste the contents of the file below, replacing ``<domain>`` with your domain name
```bash
server_tokens off;

server {
    listen 80;
    server_name <domain>;
    return 301 https://$server_name$request_uri;
}

server {
    listen 443 ssl http2;
    server_name <domain>;

    root /var/www/pterodactyl/public;
    index index.php;

    access_log /var/log/nginx/pterodactyl.app-access.log;
    error_log  /var/log/nginx/pterodactyl.app-error.log error;

    # allow larger file uploads and longer script runtimes
    client_max_body_size 100m;
    client_body_timeout 120s;

    sendfile off;

    # SSL Configuration - Replace the example <domain> with your domain
    ssl_certificate /etc/letsencrypt/live/<domain>/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/<domain>/privkey.pem;
    ssl_session_cache shared:SSL:10m;
    ssl_protocols TLSv1.2 TLSv1.3;
    ssl_ciphers "ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-CHACHA20-POLY1305:ECDHE-RSA-CHACHA20-POLY1305:DHE-RSA-AES128-GCM-SHA256:DHE-RSA-AES256-GCM-SHA384";
    ssl_prefer_server_ciphers on;

    # See https://hstspreload.org/ before uncommenting the line below.
    # add_header Strict-Transport-Security "max-age=15768000; preload;";
    add_header X-Content-Type-Options nosniff;
    add_header X-XSS-Protection "1; mode=block";
    add_header X-Robots-Tag none;
    add_header Content-Security-Policy "frame-ancestors 'self'";
    add_header X-Frame-Options DENY;
    add_header Referrer-Policy same-origin;

    location / {
        try_files $uri $uri/ /index.php?$query_string;
    }

    location ~ \.php$ {
        fastcgi_split_path_info ^(.+\.php)(/.+)$;
        fastcgi_pass unix:/run/php/php8.1-fpm.sock;
        fastcgi_index index.php;
        include fastcgi_params;
        fastcgi_param PHP_VALUE "upload_max_filesize = 100M \n post_max_size=100M";
        fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
        fastcgi_param HTTP_PROXY "";
        fastcgi_intercept_errors off;
        fastcgi_buffer_size 16k;
        fastcgi_buffers 4 16k;
        fastcgi_connect_timeout 300;
        fastcgi_send_timeout 300;
        fastcgi_read_timeout 300;
        include /etc/nginx/fastcgi_params;
    }

    location ~ /\.ht {
        deny all;
    }
}
```
after do:
```bash
sudo ln -s /etc/nginx/sites-available/pterodactyl.conf /etc/nginx/sites-enabled/pterodactyl.conf && sudo systemctl restart nginx
```
bam and you are done :D

# Extras
This section covers creating a MySQL user that has permission to create and modify users. This allows the Panel to create per-server databases on the given host.

do:
```bash
mysql -u root -p
```
Creating a user
``You should change the username and password below to something unique.``
```sql
CREATE USER 'pterodactyluser'@'%' IDENTIFIED BY 'somepassword';
GRANT ALL PRIVILEGES ON *.* TO 'pterodactyluser'@'%' WITH GRANT OPTION;
```

Give my repo a ⭐ if you enjoyed using my scripts :D


