#!/usr/bin/env bash

pip install sibus_lib

SERVICE="sibus.core.service"

if [ ! -e $SERVICE ]; then
    echo "ERROR: file $SERVICE not found !"
    exit 1
fi

echo "Installing service $SERVICE"
chmod 0755 $SERVICE
if [ -e "/etc/init.d/$SERVICE" ]; then
    sudo unlink /etc/init.d/$SERVICE
fi
sudo ln -s $SERVICE /etc/init.d/$SERVICE

sudo update-rc.d $SERVICE defaults

exit 0