#!/usr/bin/env bash

SERVICE="sibus.core"

INSTALL_DIR=`pwd`
SERVICE_PATH="$INSTALL_DIR/sibus.core.py"
SYSTEMD_ORG="$INSTALL_DIR/systemd-config"
SYSTEMD_TMP="$INSTALL_DIR/$SERVICE.service"
SYSTEMD_DST="/etc/systemd/system/$SERVICE.service"

git pull

if [ ! -e $SERVICE_PATH ]; then
    echo " !!! ERROR: file $SERVICE_PATH not found !!!"
    echo " (script must be run from its own directory !)"
    exit 1
fi
sudo chmod +x $SERVICE_PATH

echo " # Checking service $SERVICE dependencies"
PKG_OK=$(dpkg-query -W --showformat='${Status}\n' python | grep "install ok installed")
if [ "" == "$PKG_OK" ]; then
  echo " + Installing python"
  sudo apt-get update
  sudo apt-get --force-yes --yes install python python-pip
fi

sudo pip install --upgrade sibus_lib

echo " # Patching service $SERVICE systemd config file..."
sed 's|<SCRIPT_PATH>|'$SERVICE_PATH'|g' $SYSTEMD_ORG > "/tmp/tmp.systemd"
sed 's|<USER>|'$USER'|g' "/tmp/tmp.systemd" > $SYSTEMD_TMP
echo " = systemd config: "
cat $SYSTEMD_TMP

echo " # Installing service $SERVICE"
sudo ln -sfv $SYSTEMD_TMP $SYSTEMD_DST
sudo systemctl daemon-reload

echo " # Enable & start service $SERVICE at boot"
sudo systemctl enable $SERVICE
sudo systemctl start $SERVICE

echo " # Service $SERVICE status"
sudo systemctl status $SERVICE
exit 0