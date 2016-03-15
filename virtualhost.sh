#!/bin/bash
# EasyPoint script to setting add virtualhost

echo "**************************************************************"
echo "Add virtualhost script..."
echo "**************************************************************"

while true; do
    read -p "write the name of the new virtual host: " name
    case $name in
        * ) host=$name; break;;
    esac
done
while true; do
    read -p "write index absolute path: " path
    case $path in
        * ) route=$path; break;;
    esac
done
while true; do
    read -p "Do you wish to add password protecction (y/n) " yn
    case $yn in
        [y]* ) option=0;break;;
        [n]* ) option=1; break;;
        * ) echo "Please answer y or n.";;
    esac
done
if [ $option = 0 ]; then
  while true; do
      read -p "write the name of a USER to protect the access: " user
      case $user in
          * ) username=$user; break;;
      esac
  done
  if [ $username != '' ]; then
    while true; do
        read -p "write the PASSWORD for the $user to protect the access: " pass
        case $pass in
            * ) password=$pass; break;;
        esac
    done
  fi
fi
while true; do
    read -p "Enter an app_env value: " x
    case $x in
        * ) app_env=$x; break;;
    esac
done
if [ "$host" != "" ] && [ "$route" != "" ]; then
  if [ -d /etc/apache2/sites-available/$host.conf ]; then
    sudo rm /etc/apache2/sites-available/$host.conf
  fi
  if [ -d sudo rm /etc/apache2/sites-enabled/$host.conf ]; then
    sudo rm /etc/apache2/sites-enabled/$host.conf
  fi
  sudo touch /etc/apache2/sites-available/$host.conf
  sudo chmod 777 /etc/apache2/sites-available/$host.conf
  sudo printf "<VirtualHost *:80>\n" >> /etc/apache2/sites-available/$host.conf
  sudo printf "      DocumentRoot $route\n" >> /etc/apache2/sites-available/$host.conf
  sudo printf "      ServerName $host\n" >> /etc/apache2/sites-available/$host.conf
  sudo printf "      ServerAlias www.$host\n" >> /etc/apache2/sites-available/$host.conf
  sudo printf "      ServerAdmin victorhugo.avila@easypoint.co\n" >> /etc/apache2/sites-available/$host.conf
  if [ "$app_env" != "" ]; then
  sudo printf "      SetEnv APP_ENV $app_env\n" >> /etc/apache2/sites-available/$host.conf
  fi
  sudo printf "      <Directory $route>\n" >> /etc/apache2/sites-available/$host.conf
  sudo printf "         DirectoryIndex index.php\n" >> /etc/apache2/sites-available/$host.conf
  sudo printf "         Options Indexes FollowSymLinks MultiViews\n" >> /etc/apache2/sites-available/$host.conf
  sudo printf "         AllowOverride All\n" >> /etc/apache2/sites-available/$host.conf
  sudo printf "         Order allow,deny\n" >> /etc/apache2/sites-available/$host.conf
  sudo printf "         Allow from all\n" >> /etc/apache2/sites-available/$host.conf
  sudo printf "         Require all granted\n" >> /etc/apache2/sites-available/$host.conf
  sudo printf "      </Directory>\n" >> /etc/apache2/sites-available/$host.conf
  echo "adding password protection"
  echo $username
  echo $password
  if [ "$username" != "" ] && [ "$password" != "" ]; then
    sudo htpasswd -bc $route/.htpasswd $username $password
    sudo printf "      <Location />\n" >> /etc/apache2/sites-available/$host.conf
    sudo printf "         AuthType Basic\n" >> /etc/apache2/sites-available/$host.conf
    sudo printf "         AuthName 'Alto!'\n" >> /etc/apache2/sites-available/$host.conf
    sudo printf "         AuthUserFile $route.htpasswd\n" >> /etc/apache2/sites-available/$host.conf
    sudo printf "         Require valid-user\n" >> /etc/apache2/sites-available/$host.conf
    sudo printf "      </Location>\n" >> /etc/apache2/sites-available/$host.conf
  fi
  sudo printf "</VirtualHost>\n" >> /etc/apache2/sites-available/$host.conf
  sudo ln -s /etc/apache2/sites-available/$host.conf /etc/apache2/sites-enabled/$host.conf
  echo "Cheking configuration..."
  sudo cat /etc/apache2/sites-available/$host.conf
  echo "Cheking if the root directory exist..."
  if [ -d $route ]; then
    echo "The root directory exist."
  else
    sudo mkdir $route
    echo "The root directory was created."
  fi
  sudo apachectl -S
  sudo a2enmod rewrite
  sudo apachectl restart
fi

echo "**************************************************************"
echo "End of script..."
echo "**************************************************************"
