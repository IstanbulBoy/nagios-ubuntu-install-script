# nagios-ubuntu-install-script
Automated install of  Nagios 4.x.x and Nagios plugins 2.x.x onto a fresh Ubuntu 14.x.x.

This script should work with newer versions of Ubuntu as well - let me know if you have success so I can add it here.

````
$ sudo apt-get install git
$ sudo git clone https://github.com/dyson/nagios-ubuntu-install-script/ /tmp/nagios-ubuntu-install-script && cd /tmp/nagios-ubuntu-install-script && sh nagios-ubuntu-install-script.sh
````

Or download the script first and modify the options:

````
$ git clone https://github.com/dyson/nagios-ubuntu-install-script/ /tmp/nagios-ubuntu-install-script && cd /tmp/nagios-ubuntu-install-script
$ vim nagios-ubuntu-install-script.sh
...
NAGIOS_VERSION="4.1.1"
NAGIOS_PLUGINGS="2.0.3"
NAGIOS_HOME="/usr/local/nagios"
NAGIOS_WEB_ADMINISTRATION_USERNAME="administrator"

TEMP_DOWNLOAD_DIR="/tmp/download"
...
$ sudo sh nagios-ubuntu-install-script.sh
```
