#!/bin/bash

cd
# Let the games begin!

# Handle !I/O/ERR
exec 3>&1 4>&2 1>/dev/null 2>&1

showmsg() {
  exec 1>&3; echo "$1"; exec 1>/dev/null;
  #echo "$1";
}

showmsg "Preparing virtual-machine"
echo "" | sudo tee --append /etc/hosts
echo "127.0.0.1 local local-uncle.mrgriever" | sudo tee --append /etc/hosts

showmsg "--- Reticulating splines"
sudo apt-get update --fix-missing
sudo DEBIAN_FRONTEND=noninteractive apt-get -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" upgrade -y
sudo apt-get autoremove -y
sudo apt-get install vim-nox git curl unzip apt-transport-https lsb-release ca-certificates -y

showmsg "--- Installing Nginx"
sudo apt-get install nginx-full -y
# disable sendfile, which causes file corruption in virtualbox vms
sudo sed -i "s/sendfile on/sendfile off/" /etc/nginx/nginx.conf
# remove the default site
sudo rm /etc/nginx/sites-enabled/default

showmsg "--- Installing PHP 7.1"
sudo wget -O /etc/apt/trusted.gpg.d/php.gpg https://packages.sury.org/php/apt.gpg
echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" | sudo tee /etc/apt/sources.list.d/php.list
sudo apt-get update
sudo apt-get install php7.1-fpm php7.1-curl php7.1-dev php7.1-gd php7.1-mbstring php7.1-mcrypt php7.1-mysql php7.1-xml php7.1-xmlrpc php7.1-zip php-xdebug -y
# set the timezone
sudo sed -i "s/;date.timezone =/date.timezone = America\/Denver/" /etc/php/7.1/cli/php.ini
sudo sed -i "s/;date.timezone =/date.timezone = America\/Denver/" /etc/php/7.1/fpm/php.ini
# configure xdebug
sudo cp /vagrant/setup/php-7.1-mods-available/xdebug.ini /etc/php/7.1/mods-available/xdebug.ini
sudo service php7.1-fpm reload

showmsg "--- Installing Phalcon"
curl -sSf "https://packagecloud.io/install/repositories/phalcon/stable/config_file.list?os=debian&dist=stretch&source=script" | sudo tee /etc/apt/sources.list.d/phalcon_stable.list
curl -L "https://packagecloud.io/phalcon/stable/gpgkey" 2> /dev/null | sudo apt-key add - &>/dev/null
sudo apt-get update
sudo apt-get install php7.1-phalcon

#showmsg "--- Installing PHPUnit"
#sudo wget -O /usr/bin/phpunit https://phar.phpunit.de/phpunit.phar
#sudo chmod +x /usr/bin/phpunit

showmsg "--- Installing Composer"
curl --silent https://getcomposer.org/installer | php >> /vagrant/composer_build.log
sudo mv composer.phar /usr/local/bin/composer

sudo service nginx restart
