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
# create the release file
#sudo mkdir /etc/younique
#sudo cp /vagrant/setup/younique/default.ini /etc/younique/release.ini
#sudo cp /vagrant/setup/younique/default.ini /etc/younique/config.ini
# Setup the dotdeb apt repos
wget https://www.dotdeb.org/dotdeb.gpg
sudo apt-key add dotdeb.gpg
rm dotdeb.gpg
echo "" | sudo tee --append /etc/apt/sources.list
echo "deb http://packages.dotdeb.org jessie all" | sudo tee --append /etc/apt/sources.list
echo "deb-src http://packages.dotdeb.org jessie all" | sudo tee --append /etc/apt/sources.list

showmsg "--- Reticulating splines"
sudo apt-get update --fix-missing
sudo DEBIAN_FRONTEND=noninteractive apt-get -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" upgrade -y
sudo apt-get autoremove -y
sudo apt-get install vim-nox git curl unzip -y

showmsg "--- Installing Nginx"
sudo apt-get install nginx-full -y
# disable sendfile, which causes file corruption in virtualbox vms
sudo sed -i "s/sendfile on/sendfile off/" /etc/nginx/nginx.conf

showmsg "--- Installing PHP7.0-fpm"
sudo apt-get install php7.0-fpm php7.0-curl php7.0-mbstring php7.0-mcrypt php7.0-mysql php7.0-xdebug php7.0-xml php7.0-xmlrpc php7.0-zip -y
# disable the pathinfo fix, to conform with nginx socket connections
sudo sed -i "s/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/" /etc/php/7.0/fpm/php.ini
# set the timezone
sudo sed -i "s/;date.timezone =/date.timezone = America\/Denver/" /etc/php/7.0/cli/php.ini
sudo sed -i "s/;date.timezone =/date.timezone = America\/Denver/" /etc/php/7.0/fpm/php.ini
# configure xdebug
sudo cp /vagrant/setup/php-7.0-mods-available/xdebug.ini /etc/php/7.0/mods-available/xdebug.ini
sudo service php7.0-fpm reload

#showmsg "--- Installing PHPUnit"
#sudo wget -O /usr/bin/phpunit https://phar.phpunit.de/phpunit.phar
#sudo chmod +x /usr/bin/phpunit

#showmsg "--- Installing AWS CLI"
#curl "https://s3.amazonaws.com/aws-cli/awscli-bundle.zip" -o "awscli-bundle.zip"
#unzip awscli-bundle.zip
#sudo ./awscli-bundle/install -i /usr/local/aws -b /usr/local/bin/aws
#rm -rf awscli-bundle
#rm awscli-bundle.zip
#sudo ln -s /vagrant/aws /var/www/.aws

showmsg "--- Installing Composer"
curl --silent https://getcomposer.org/installer | php >> /vagrant/vm_build.log
sudo mv composer.phar /usr/local/bin/composer

#showmsg "--- Installing nodejs 7.x"
#curl -sL https://deb.nodesource.com/setup_7.x | sudo -E bash -
#sudo apt-get install -y nodejs

#showmsg "--- Installing grunt"
#sudo apt-get install ruby ruby-compass
#cd /var/www/code
#npm install
#sudo npm install -g grunt grunt-cli
#grunt build
#cd

sudo service nginx restart
