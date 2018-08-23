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

# Install git
sudo apt-get update
sudo apt-get install git

# Clone and install ur/web
msf=/home/membooadmin/workspace/memboo-setup
mkdir -p $msf
cd $msf
git clone https://github.com/urweb/urweb.git
cd urweb
sh autogen.sh
sh configure
make
make install

# Clone and install ur/web mail
cd $msf
git clone https://github.com/urweb/email.git
cd email
sh autogen.sh
sh configure
make
make install

ldconfig

# install and setup nginx
nxf=/etc/nginx/sites-available/default
sudo apt-get install nginx
sudo mv $nxf "$nxf.bkp"
cd $msf
git clone https://github.com/vladpo/memboo.git
sudo cp memboo/setup/nginx/default $nxf
sudo systemctl restart nginx

# install and setup postfix

# Clone and setup memboo
cd $msf/memboo
sudo mkdir -p /var/www/memboo/static
sudo cp static/* /var/www/memboo/static
urweb @MLton fixed-heap 1.5g -- memboo
sudo cp memboo /etc/init.d/
sudo chmod +x /etc/init.d/memboo
service memboo start
update-rc.d memboo defaults
