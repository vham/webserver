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

if [ $name != "" ] && [ $route != "" ]; then
  sudo touch /etc/apache2/sites-available/$name.conf
  sudo chmod 777 /etc/apache2/sites-available/$name.conf
  sudo printf "<VirtualHost *:80>\n" >> /etc/apache2/sites-available/$name.conf
  sudo printf "      DocumentRoot $route\n" >> /etc/apache2/sites-available/$name.conf
  sudo printf "      ServerName www.$name\n" >> /etc/apache2/sites-available/$name.conf
  sudo printf "      ServerAlias $name\n" >> /etc/apache2/sites-available/$name.conf
  sudo printf "      #ErrorLog /var/www/$name/error.log\n" >> /etc/apache2/sites-available/$name.conf
  sudo printf "      #CustomLog /var/www/$name/access.log combined\n" >> /etc/apache2/sites-available/$name.conf
  sudo printf "</VirtualHost>\n" >> /etc/apache2/sites-available/$name.conf
  sudo ln -s /etc/apache2/sites-available/$name.conf /etc/apache2/sites-enabled/$name.conf
  echo "Cheking configuration..."
  apachectl -S
fi

echo "**************************************************************"
echo "End of script..."
echo "**************************************************************"
