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
    read -p "write user if you want to protect the access: " user
    case $user in
        * ) username=$user; break;;
    esac
done
if [[ username !='' ]]; then
  while true; do
      read -p "write password for the user to protect the access: " pass
      case $pass in
          * ) password=$pass; break;;
      esac
  done
fi

if [ $name != "" ] && [ $route != "" ]; then
  sudo touch /etc/apache2/sites-available/$name.conf
  sudo chmod 777 /etc/apache2/sites-available/$name.conf
  sudo printf "<VirtualHost *:80>\n" >> /etc/apache2/sites-available/$name.conf
  sudo printf "     DocumentRoot $route\n" >> /etc/apache2/sites-available/$name.conf
  sudo printf "      ServerName www.$name\n" >> /etc/apache2/sites-available/$name.conf
  sudo printf "      ServerAlias $name\n" >> /etc/apache2/sites-available/$name.conf
  sudo printf "      <Directory $route>\n" >> /etc/apache2/sites-available/$name.conf
  sudo printf "         DirectoryIndex index.php\n" >> /etc/apache2/sites-available/$name.conf
  sudo printf "         Options Indexes FollowSymLinks MultiViews\n" >> /etc/apache2/sites-available/$name.conf
  sudo printf "         AllowOverride All\n" >> /etc/apache2/sites-available/$name.conf
  sudo printf "         Order allow,deny\n" >> /etc/apache2/sites-available/$name.conf
  sudo printf "         Allow from all\n" >> /etc/apache2/sites-available/$name.conf
  sudo printf "         Require all granted\n" >> /etc/apache2/sites-available/$name.conf
  sudo printf "      </Directory>\n" >> /etc/apache2/sites-available/$name.conf
  if [[ $username != ''] && [ $pasword != '']]; then
    sudo htpasswd -bc $route/.htpasswd $username $password
    sudo printf "      <Location />\n" >> /etc/apache2/sites-available/$name.conf
    sudo printf "         AuthType Basic\n" >> /etc/apache2/sites-available/$name.conf
    sudo printf "         AuthName \'Alto ahí...\'\n" >> /etc/apache2/sites-available/$name.conf
    sudo printf "         AuthUserFile $route/.htpasswd\n" >> /etc/apache2/sites-available/$name.conf
    sudo printf "         Require valid-user\n" >> /etc/apache2/sites-available/$name.conf
    sudo printf "      </Location>\n" >> /etc/apache2/sites-available/$name.conf
  fi
  sudo printf "      ErrorLog /var/www/$name/error.log\n" >> /etc/apache2/sites-available/$name.conf
  sudo printf "      CustomLog /var/www/$name/access.log combined\n" >> /etc/apache2/sites-available/$name.conf
  sudo printf "</VirtualHost>\n" >> /etc/apache2/sites-available/$name.conf
  sudo ln -s /etc/apache2/sites-available/$name.conf /etc/apache2/sites-enabled/$name.conf
  echo "Cheking configuration..."
  sudo cat /etc/apache2/sites-available/$name.conf
  sudo apachectl -S
  sudo apachectl restart
fi

echo "**************************************************************"
echo "End of script..."
echo "**************************************************************"
