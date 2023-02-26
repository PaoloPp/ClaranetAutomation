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
sudo systemctl start httpd
sudo systemctl enable httpd
sudo mount -t nfs -o nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2,noresvport ${terraform output -raw efs_mount}:/  /var/www/html
echo ${terraform output -raw efs_mount}:/ /var/www/html nfs4 defaults,_netdev 0 0  | sudo cat >> /etc/fstab
sudo systemctl restart apache2
