#!/bin/bash
# Custom setup for RaspberryPi 5 Hoobs Server with Desktop support

sudo apt update && sudo apt upgrade -y
sudo rpi-eeprom-update
sudo apt update && sudo apt upgrade -y

sudo apt install -y interception-tools interception-tools-compat cmake
cd ~
git clone https://gitlab.com/interception/linux/plugins/hideaway.git
cd hideaway
cmake -B build -DCMAKE_BUILD_TYPE=Release
cmake --build build
sudo cp ~/hideaway/build/hideaway /usr/bin
sudo chmod +x /usr/bin/hideaway
cd ~
wget https://raw.githubusercontent.com/ugotapi/wayland-pagepi/main/config.yaml
sed -i 's/hideaway 4/hideaway 5/' ~/config.yaml
sudo cp ~/config.yaml /etc/interception/udevmon.d/config.yaml
sudo systemctl restart udevmon

wget -qO- https://dl.hoobs.org/stable | sudo bash -
sudo apt install hoobsd hoobs-cli -y
sudo hbs install

if [ ! -d ~/.config/autostart ]; then
mkdir ~/.config/autostart
fi
wget https://raw.githubusercontent.com/Jwrightmcps/raspberrypi5-hoobs-v5/refs/heads/main/hoobs-ui.desktop -O ~/.config/autostart
wget https://raw.githubusercontent.com/Jwrightmcps/raspberrypi5-hoobs-v5/refs/heads/main/disable-hoobs-kiosk.sh
wget https://raw.githubusercontent.com/Jwrightmcps/raspberrypi5-hoobs-v5/refs/heads/main/enable-hoobs-kiosk.sh
wget https://raw.githubusercontent.com/Jwrightmcps/raspberrypi5-hoobs-v5/refs/heads/main/tools.txt
chmod +x disable-hoobs-kiosk.sh
chmod +x enable-hoobs-kiosk.sh

rm config.yaml
rm setup-hoobs-for-raspi-5.sh
sudo raspi-config
