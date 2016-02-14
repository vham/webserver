#!/bin/bash
# EasyPoint script to setting up Debian Web Server with LAMP5.6

echo "**************************************************************"
echo "Initializing script..."
echo "**************************************************************"
echo "Setting Locale"
echo "mv Locale file"
sudo cp locale.gen /etc/locale.gen
sudo cp locale.conf /etc/locale.conf
sudo locale-gen
echo "The list of availables locale settings"
sudo locale -a
#locale | cat > /etc/locale.conf

echo "**************************************************************"
echo "Updating Linux..."
echo "**************************************************************"
sudo apt-get -y update
echo "Installing vim..."
sudo apt-get -y install vim
echo "Installing wget..."
sudo apt-get -y install wget
echo "Installing unzip..."
sudo apt-get -y install unzip
echo "Installing rpm..."
sudo apt-get -y install rpm
echo "Installing debconf..."
sudo apt-get install debconf
echo "Installing GIT..."
sudo apt-get install git

#Since using gcloud ssh ftp VSFTP is deprecated
#echo "Installing vsftpd"
#sudo apt-get install vsftpd
#sudo systemctl enable vsftpd.service
#sudo systemctl start vsftpd.service
#sudo mv -r vsftpd.conf /etc/vsftpd.conf

echo "**************************************************************"
echo "Installing Web Server"
echo "**************************************************************"
echo "Installing Apache2..."
sudo apt-get -y install apache2
sudo systemctl enable apache2.service
sudo printf "export PATH=\"$PATH:/usr/sbin/\"" >> ~/.profile
export PATH="$PATH:/usr/sbin/"

while true; do
    read -p "Do you wish to deploy DEV or PROD enviroment? (dev/prod) " yn
    case $yn in
        [dev]* ) option=0;break;;
        [prod]* ) option=1; break;;
        * ) echo "Please answer yes or no.";;
    esac
done
if [ $option = 1 ]; then
  echo "Deploying productive enviroment..."
  sudo cp apache2.conf /etc/apache2/
  sudo cp security.conf /etc/apache2/conf-enabled/
  sudo a2dissite default
  sudo rm -r /var/www/html/index.*
  sudo a2dismod autoindex -f
  sudo apachectl restart
else
  echo "Deploying development enviroment..."
fi

echo "Preparing folders authorization"
sudo chmod 555 /var/www/
sudo chmod 777 /var/www/html

#echo "Preparing some test"
#if [ $option = 0 ]; then
#  sudo touch /var/www/html/index.html
#fi
#sudo touch /var/www/html/index.html
#sudo printf '%s\n' '<html><body><h1>I&#39m Running!</h1><br><h4>Test provided by: victorhugo.avila@easy-point.com</h4></body></html>' >> /var/www/html/index.html

while true; do
    read -p "Do you wish to install MySQL?" yn
    case $yn in
        [y]* ) option=0;break;;
        [n]* ) option=1; break;;
        * ) echo "Please answer yes or no.";;
    esac
done
if [ $option = 1 ]; then
  echo "**************************************************************"
  echo "Installing MySQL..."
  echo "**************************************************************"
  sudo apt-get install -y mysql-server php5-mysql
  sudo mysql_secure_installation
  sudo systemctl enable mysql.service
  sudo systemctl restart mysql.service
fi

echo "**************************************************************"
echo "Installing phpMyAdmin..."
echo "**************************************************************"
sudo apt-get -y install phpmyadmin

echo "**************************************************************"
echo "Installing PHP..."
echo "**************************************************************"
sudo apt-get -y install php5 php5-common libapache2-mod-php5 php5-cli php5-json php5-mcrypt php5-curl php5-gd

sudo service apache2 restart
sudo touch /var/www/html/info.php
sudo chmod 777 /var/www/html/info.php
#if [ $option = 0 ]; then
sudo printf '%s\n' '<?php phpinfo(); ?>' >> /var/www/html/info.php
#fi

echo "**************************************************************"
echo "Installing composer..."
echo "**************************************************************"
sudo curl -sS https://getcomposer.org/installer | php
sudo mv composer.phar /usr/local/bin/composer
composer self-update

echo "**************************************************************"
echo "Installing Laravel..."
echo "**************************************************************"
composer global require "laravel/installer=~1.1"
sudo printf "export PATH=\"$PATH:~/.composer/vendor/bin\"" >> ~/.profile
export PATH="$PATH:~/.composer/vendor/bin"
#export PATH="$PATH:~/.composer/vendor/bin"
echo $PATH

#printf '%s\n    %s\n' 'Host localhost' 'ForwardAgent yes' >> file.txt
#echo "Installing docker..."
#sudo apt-get -y install docker.io

echo "**************************************************************"
echo "End of script..."
echo "**************************************************************"
