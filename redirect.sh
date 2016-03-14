#!/bin/bash
# EasyPoint script to setting add virtualhost

echo "**************************************************************"
echo "Add Alias redirect to Apache..."
echo "**************************************************************"

sudo a2enmod alias


while true; do
    read -p "write the name of the new virtual host: " name
    case $name in
        * ) hostOrigin=$name; break;;
    esac
done
while true; do
    read -p "write the destination of the redirecction: (http://www) " redirect
    case $redirect in
        * ) hostDestination=$redirect; break;;
    esac
done
while true; do
    read -p "Wish code of redirecction do you want to set (301 Permanet, 302 Temporal, 303 Replaced, 402 Not available anymore) " c
    case $c in
        * ) code=$c; break;;
    esac
done
if [ "$hostOrigin" != "" ] && [ "$redirect" != "" ]; then
  if [ -d /etc/apache2/sites-available/$hostOrigin.conf ]; then
    sudo rm /etc/apache2/sites-available/$hostOrigin.conf
  fi
  if [ -d sudo rm /etc/apache2/sites-enabled/$hostOrigin.conf ]; then
    sudo rm /etc/apache2/sites-enabled/$hostOrigin.conf
  fi
  sudo touch /etc/apache2/sites-available/$hostOrigin.conf
  sudo chmod 777 /etc/apache2/sites-available/$hostOrigin.conf
  sudo printf "<VirtualHost *:80>\n" >> /etc/apache2/sites-available/$hostOrigin.conf
  sudo printf "      ServerName $hostOrigin\n" >> /etc/apache2/sites-available/$hostOrigin.conf
  sudo printf "      ServerAdmin victorhugo.avila@easypoint.co\n" >> /etc/apache2/sites-available/$hostOrigin.conf
  sudo printf "      Redirect $code / $hostDestination\n" >> /etc/apache2/sites-available/$hostOrigin.conf
  sudo printf "</VirtualHost>\n" >> /etc/apache2/sites-available/$hostOrigin.conf
  sudo ln -s /etc/apache2/sites-available/$hostOrigin.conf /etc/apache2/sites-enabled/$hostOrigin.conf
  echo "Cheking configuration..."
  sudo cat /etc/apache2/sites-available/$hostOrigin.conf
  sudo apachectl -S
  sudo a2ensite $hostOrigin
  sudo a2ensite $hostDestination
  sudo service apache2 reload
fi

echo "**************************************************************"
echo "End of script..."
echo "**************************************************************"
