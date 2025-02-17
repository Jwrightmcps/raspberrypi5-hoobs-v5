#!/bin/bash
# Custom setup for RaspberryPi 5 Hoobs Server with Desktop support

sudo apt update && sudo apt upgrade -y
sudo rpi-eeprom-update
sudo raspi-config
sudo apt update && sudo apt upgrade -y

echo # change 1 System Options>S5 Boot / Auto Login Select boot into desktop or to command line>B4 Desktop Autologon Desktop GUI, automatically logged in as 'hoobs' user
echo # change 1 System Options>S6 Splash Screen>No
echo # change 2 Display Options>D6 Onscreen Keyboard Enable on-screen keyboard>S1 Always On On-screen keyboard always enabled
echo # change 6 Advanced Options> A4 Boot Order> B2 NVMe/USB boot
echo # change 6 Advanced Options> A5 bootloader Version> Latest>Yes
echo # change 6 Advanced Options> A6 Wayland>W2 Wayfire window manager with Wayland backend
echo # change 6 Advanced Options> A8 PCIe Speed>Yes

echo # Appearance Settings>Defaults>For large screens>Set Defaults
echo # Appearance Settings>System>Theme>Dark
echo # Appearance Settings>Desktop>Layout>No Image
echo # Appearance Settings>Desktop>Layout>Colour>Black
echo # Appearance Settings>Desktop>Layout>Colour>Black
echo # Appearance Settings>Desktop>Layout>Documents>Disable
echo # Appearance Settings>Desktop>Layout>Wastebasket>Disable
echo # Appearance Settings>Desktop>Layout>External Disks>Disable

echo # Configure clock (%I%M%p)

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
sudo nano /etc/interception/udevmon.d/config.yaml
sudo systemctl restart udevmon

wget -qO- https://dl.hoobs.org/stable | sudo bash -
sudo apt install hoobsd hoobs-cli -y
sudo hbs install

wget https://raw.githubusercontent.com/Jwrightmcps/raspberrypi5-hoobs-v5/refs/heads/main/hoobs-ui.desktop
wget https://raw.githubusercontent.com/Jwrightmcps/raspberrypi5-hoobs-v5/refs/heads/main/disable-hoobs.kiosk.sh
wget https://raw.githubusercontent.com/Jwrightmcps/raspberrypi5-hoobs-v5/refs/heads/main/enable-hoobs-kiosk.sh
mkdir ~/.config/autostart
cp ~/hoobs-ui.desktop ~/.config/autostart/hoobs-ui.desktop

