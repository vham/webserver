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
    case $name in
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
if [ "$name" != "" ] && [ "$route" != "" ]; then
  sudo rm /etc/apache2/sites-available/$name.conf
  sudo rm /etc/apache2/sites-enabled/$name.conf
  sudo touch /etc/apache2/sites-available/$name.conf
  sudo chmod 777 /etc/apache2/sites-available/$name.conf
  sudo printf "<VirtualHost *:80>\n" >> /etc/apache2/sites-available/$name.conf
  sudo printf "     DocumentRoot $route\n" >> /etc/apache2/sites-available/$name.conf
  sudo printf "      ServerName $name\n" >> /etc/apache2/sites-available/$name.conf
  sudo printf "      ServerAlias www.$name\n" >> /etc/apache2/sites-available/$name.conf
  sudo printf "      <Directory $route>\n" >> /etc/apache2/sites-available/$name.conf
  sudo printf "         DirectoryIndex index.php\n" >> /etc/apache2/sites-available/$name.conf
  sudo printf "         Options Indexes FollowSymLinks MultiViews\n" >> /etc/apache2/sites-available/$name.conf
  sudo printf "         AllowOverride All\n" >> /etc/apache2/sites-available/$name.conf
  sudo printf "         Order allow,deny\n" >> /etc/apache2/sites-available/$name.conf
  sudo printf "         Allow from all\n" >> /etc/apache2/sites-available/$name.conf
  sudo printf "         Require all granted\n" >> /etc/apache2/sites-available/$name.conf
  sudo printf "      </Directory>\n" >> /etc/apache2/sites-available/$name.conf
  echo "adding password protection"
  echo $username
  echo $password
  if [ "$username" != "" ] && [ "$password" != "" ]; then
    sudo htpasswd -bc $route/.htpasswd $username $password
    sudo printf "      <Location />\n" >> /etc/apache2/sites-available/$name.conf
    sudo printf "         AuthType Basic\n" >> /etc/apache2/sites-available/$name.conf
    sudo printf "         AuthName 'Alto!'\n" >> /etc/apache2/sites-available/$name.conf
    sudo printf "         AuthUserFile $route.htpasswd\n" >> /etc/apache2/sites-available/$name.conf
    sudo printf "         Require valid-user\n" >> /etc/apache2/sites-available/$name.conf
    sudo printf "      </Location>\n" >> /etc/apache2/sites-available/$name.conf
  fi
  sudo printf "</VirtualHost>\n" >> /etc/apache2/sites-available/$name.conf
  sudo ln -s /etc/apache2/sites-available/$name.conf /etc/apache2/sites-enabled/$name.conf
  echo "Cheking configuration..."
  sudo cat /etc/apache2/sites-available/$name.conf
  echo "Cheking if the root directory exist..."
  if [ -d $route ]; then
    echo "The root directory exist."
  else
    sudo mkdir $route
    echo "The root directory was created."
  fi
  sudo apachectl -S
  sudo apachectl restart
fi

echo "**************************************************************"
echo "End of script..."
echo "**************************************************************"
