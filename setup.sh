#!/bin/bash

# Setup US keyboard
kbf=/etc/default/keyboard
sudo mv $kbf "$kbf.bkp"
sudo touch $kbf
sudo cat >> $kbf << EOF
XKBLAYOUT="us"
XKBVARIANT=""
BACKSPACE="guess"
XKBMODEL="pc105"
XKBOPTIONS="grp:alt_shift_toggle,grp_led:scroll"
EOF
setupcon

sudo apt-get update

# Clone and install ur/web
msf=/home/membooadmin/workspace/memboo-setup
mkdir -p $msf
cd $msf
git clone https://github.com/urweb/urweb.git
cd urweb
sudo apt-get install build-essential git mlton autoconf libssl-dev
sudo apt-get install libpq-dev libmysqlclient-dev libsqlite3-dev
sudo apt-get install automake
sudo apt-get install libtool
libtoolize --force
aclocal
autoheader
automake --force-missing --add-missing
autoconf
sh ./configure
sudo make
sudo make install

# Clone and install ur/web mail
cd $msf
git clone https://github.com/urweb/email.git
cd email
sh ./autogen.sh
sh ./configure
sudo make
sudo make install

# install and setup nginx
nxf=/etc/nginx/sites-available/default
sudo apt-get install nginx
sudo mv $nxf "$nxf.bkp"
cd $msf
git clone https://github.com/vladpo/memboo.git
sudo cp ./memboo/default $nxf
sudo systemctl restart nginx

# install and setup postfix

# Clone and setup memboo
cd $msf/memboo
sudo mkdir -p /var/www/memboo/static
sudo cp static/* /var/www/memboo/static
urweb @MLton fixed-heap 1.5g -- memboo
sudo cp memboo /etc/init.d/
sudo chmod +x /etc/init.d/memboo
sudo update-rc.d memboo defaults
sudo service memboo start
