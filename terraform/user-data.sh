#!/bin/bash 
DEBIAN_FRONTEND=noninteractive
sudo apt update
sudo apt-get install -y -q apache2 \
                 ghostscript \
                 libapache2-mod-php \
                 mysql-server \
                 php \
                 php-bcmath \
                 php-curl \
                 php-imagick \
                 php-intl \
                 php-json \
                 php-mbstring \
                 php-mysql \
                 php-xml \
                 php-zip \
                 nfs-common \
                 wget
#
sudo useradd test-user
echo "test-user:password" | chpasswd
sudo usermod -aG sudo test-user
#
sudo systemctl start apache2
sudo systemctl enable apache2
sudo mount -t nfs -o nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2,noresvport ${efs_mount}:/  /var/www/html
echo ${efs_mount}:/ /var/www/html nfs4 defaults,_netdev 0 0  | sudo cat >> /etc/fstab
if [ ! -d "/var/www/html/wordpress/" ]; then
    cd /tmp
    wget https://wordpress.org/latest.tar.gz
    tar -xvzf latest.tar.gz
    sudo mv wordpress /var/www/html/
    sudo chown -R www-data:www-data /var/www/html/wordpress/
    sudo chmod -R 755 /var/www/html/wordpress/
    mysql -h "${db_host}" -u "${db_user}" --password="${db_pass}" <<MYSQL_SCRIPT
    CREATE DATABASE ${db_name};
    GRANT ALL PRIVILEGES ON ${db_name}.* TO '${db_user}'@'localhost' IDENTIFIED BY '${db_pass}';
    FLUSH PRIVILEGES;
MYSQL_SCRIPT

    cd /var/www/html/wordpress/
    cp wp-config-sample.php wp-config.php
    sed -i "s/database_name_here/${db_name}/g" wp-config.php
    sed -i "s/username_here/${db_user}/g" wp-config.php
    sed -i "s/password_here/${db_pass}/g" wp-config.php
    sed -i "s/localhost/${db_host}/g" wp-config.php
    sudo sed -i 's#^\(\s*DocumentRoot\s*\)/var/www/html$#\1/var/www/html/wordpress#' /etc/apache2/sites-available/000-default.conf
    sudo systemctl restart apache2
    rm /tmp/latest.tar.gz
fi

sudo systemctl restart apache2

