# nagios-ubuntu-install-script
Automated install of  Nagios 4.x.x and Nagios plugins 2.x.x onto a fresh Ubuntu 14.x.x

````
$ sudo apt-get install git
$ sudo git clone https://github.com/dyson/nagios/ /tmp/nagios && cd /tmp/nagios && sh nagios.sh
````

Or download the script first and modify the options:

````
$ git clone https://github.com/dyson/nagios/ /tmp/nagios && cd /tmp/nagios
$ vim nagios.sh
...
NAGIOS_VERSION="4.1.1"
NAGIOS_PLUGINGS="2.0.3"
NAGIOS_HOME="/usr/local/nagios"
NAGIOS_WEB_ADMINISTRATION_USERNAME="administrator"

TEMP_DOWNLOAD_DIR="/tmp/download"
...
$ sudo sh nagios.sh
```
