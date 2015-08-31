#!/bin/bash
NAGIOS_VERSION="4.1.1"
NAGIOS_PLUGINGS="2.0.3"
NAGIOS_HOME="/usr/local/nagios"
NAGIOS_WEB_ADMINISTRATION_USERNAME="administrator"

TEMP_DOWNLOAD_DIR="/tmp/download"

# Download and install apache2 and tools required to compile nagios
sudo apt-get update
sudo apt-get install --yes apache2 php5 libapache2-mod-php5 php5-mcryp build-essential libgd2-xpm-dev openssl libssl-dev apache2-utils

# Create nagios users and groups
sudo useradd nagios
sudo groupadd nagcmd
sudo usermod -a -G nagcmd nagios
# http://stackoverflow.com/questions/26142420/nagios-could-not-open-command-file-usr-local-nagios-var-rw-nagios-cmd-for-up --error fix 
sudo usermod -a -G nagios www-data
sudo usermod -a -G nagcmd www-data

# Download and install nagios
mkdir -p $TEMP_DOWNLOAD_DIR

cd $TEMP_DOWNLOAD_DIR
if ! [ -e $TEMP_DOWNLOAD_DIR/nagios-$NAGIOS_VERSION.tar.gz ]; then 
  wget http://prdownloads.sourceforge.net/sourceforge/nagios/nagios-$NAGIOS_VERSION.tar.gz
fi

tar xvzf nagios-$NAGIOS_VERSION.tar.gz
cd nagios-$NAGIOS_VERSION
sudo ./configure --with-nagios-group=nagios --with-command-group=nagcmd
sudo make all
sudo make install
sudo make install-init
sudo make install-commandmode
sudo make install-config
sudo /usr/bin/install -c -m 644 sample-config/httpd.conf /etc/apache2/sites-available/nagios.conf
#make install-webconf -- option of above command

# Download and install plugins
cd $TEMP_DOWNLOAD_DIR
if ! [ -e $TEMP_DOWNLOAD_DIR/nagios-plugins-$NAGIOS_PLUGINGS.tar.gz ]; then
  wget http://nagios-plugins.org/download/nagios-plugins-$NAGIOS_PLUGINGS.tar.gz
fis

tar xzf $TEMP_DOWNLOAD_DIR/nagios-plugins-$NAGIOS_PLUGINGS.tar.gz -C $TEMP_DOWNLOAD_DIR
cd $TEMP_DOWNLOAD_DIR/nagios-plugins-$NAGIOS_PLUGINGS
sudo ./configure --with-nagios-user=nagios --with-nagios-group=nagios --with-openssl
sudo make
sudo make install

# Create and configure patsh and permissions
sudo mkdir -p /usr/local/nagios/etc/{servers,printers,switches,routers}

sudo sh -c 'echo 'cfg_dir=/usr/local/nagios/etc/servers' >> /usr/local/nagios/etc/nagios.cfg'
sudo sh -c 'echo 'cfg_dir=/usr/local/nagios/etc/printers' >> /usr/local/nagios/etc/nagios.cfg'
sudo sh -c 'echo 'cfg_dir=/usr/local/nagios/etc/switches' >> /usr/local/nagios/etc/nagios.cfg'
sudo sh -c 'echo 'cfg_dir=/usr/local/nagios/etc/routers' >> /usr/local/nagios/etc/nagios.cfg'

sudo mkdir - /usr/local/nagios/var/spool/checkresults
sudo chown -R nagios.nagios /usr/local/nagios
sudo chown -R nagios.nagcmd /usr/local/nagios/var/rw

# Configure Nagios contacts

if grep --quiet  nagios@localhost  /usr/local/nagios/etc/objects/contacts.cfg; then
        echo exists
else
        sudo echo 'define contact{
        contact_name                    nagiosadmin             ; Short name of user
        use                             generic-contact         ; Inherit default values from generic-contact template (defined above)
        alias                           Nagios Admin            ; Full name of user

        email                           nagios@localhost        ; <<***** CHANGE THIS TO YOUR EMAIL ADDRESS ******
        }' >>/usr/local/nagios/etc/objects/contacts.cfg

fi
#-----------------------------------Configure Apache-----------------------------------#

sudo a2enmod rewrite
sudo a2enmod cgi

# Use htpasswd to create an admin user, called "nagiosadmin", that can access the Nagios web interface
printf "%s%s\n" "Please enter a password for the Nagios web administration user: " $NAGIOS_WEB_ADMINISTRATION_USERNAME
sudo htpasswd -c /usr/local/nagios/etc/htpasswd.users $NAGIOS_WEB_ADMINISTRATION_USERNAME

# Create a symbolic link of nagios.conf to the sites-enabled directory
sudo ln -s /etc/apache2/sites-available/nagios.conf /etc/apache2/sites-enabled/

# Enable Nagios to start on server boot
sudo ln -s /etc/init.d/nagios /etc/rcS.d/S99nagios

# Start Nagios
sudo service nagios start

# Restart apache
sudo service apache2 restart

# Finish
printf "%s\n" "Script Finished Successful :-D"
printf "\n"
printf "%s\n" "now use any browser and type http://nagios_server_public_ip/nagios"
printf "%s\n" "--------------------------"
printf "%s\n" "USERNAME : nagiosadmin"
printf "%s\n" "PASSWORD : THAT U HAVE ENTER AT TIME OF RUNNING SCRIPT"
printf "%s\n" "--------------------------"
printf "%s\n" "now use any browser and type http://nagios_server_public_ip/nagios"
printf "\n"
printf "%s\n" "if u get error processing php5 (--configure):"
printf "%s\n" "USE BELOW COMMAND & RE-EXECUTIVE THE SCRIPT AND REBOOT SYSTEM"
printf "%s\n" "sudo apt-get remove --purge php5-common php5-cli"
printf "\n"
printf "%s\n" "T: @ackbote"
printf "%s\n" "E:hel.venket@gmail.com"
printf "%s\n" "M:+918866442277"
printf "\n"
printf "%s\n" "Always share what you learn, in easy and confortable way --"
printf "\n"
printf "\n"
