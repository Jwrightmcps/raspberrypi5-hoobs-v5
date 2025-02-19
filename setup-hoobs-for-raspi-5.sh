#!/bin/bash
# Custom setup for RaspberryPi 5 Hoobs Server with Desktop support
# wget https://raw.githubusercontent.com/Jwrightmcps/raspberrypi5-hoobs-v5/refs/heads/main/setup-hoobs-for-raspi-5.sh && chmod +x setup-hoobs-for-raspi-5.sh && ./setup-hoobs-for-raspi-5.sh

sudo apt update && sudo apt upgrade -y
sudo rpi-eeprom-update

# Get the Raspberry Pi Board Type (4 = pi4, 5 = pi5, etc.)
sudo raspi-config nonint get_pi_type 
# Set Boot to GUI and Autologon
sudo raspi-config nonint do_boot_behaviour B4
# Set hostname to hoobs
sudo raspi-config nonint do_hostname hoobs
# Set SSH to enabled
sudo raspi-config nonint do_ssh 0
# Set sceen blanking to enabled
sudo raspi-config nonint do_blanking 0
# Set On-screen keyboard to always show
sudo raspi-config nonint do_squeekboard S1
# Set PCIe 3 to enabled
sudo raspi-config nonint do_pci 0
# Set Wayland
sudo raspi-config nonint do_wayland W2
# Set to use latest boot loader
sudo raspi-config nonint do_boot_rom E1
# Update the keyboard
sudo raspi-config nonint update_wayfire_keyboard

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

wget -qO- https://dl.hoobs.org/stable | sudo bash -
sudo apt install hoobsd hoobs-cli -y
sudo hbs install -p 80

if [ ! -d ~/.config/autostart ]; then
mkdir ~/.config/autostart
fi

if [ ! -d ~/.config/pcmanfm ]; then
mkdir ~/.config/pcmanfm
fi

if [ ! -d ~/.config/pcmanfm/LXDE-pi ]; then
mkdir ~/.config/pcmanfm/LXDE-pi
fi

wget https://raw.githubusercontent.com/Jwrightmcps/raspberrypi5-hoobs-v5/refs/heads/main/hoobs-ui.desktop -O ~/.config/autostart/hoobs-ui.desktop
wget https://raw.githubusercontent.com/Jwrightmcps/raspberrypi5-hoobs-v5/refs/heads/main/wf-panel-pi.ini -O ~/.config/wf-panel-pi.ini
wget https://raw.githubusercontent.com/Jwrightmcps/raspberrypi5-hoobs-v5/refs/heads/main/desktop-items-HDMI-A-1.conf -O ~/.config/pcmanfm/LXDE-pi/desktop-items-HDMI-A-1.conf
wget https://github.com/Jwrightmcps/raspberrypi5-hoobs-v5/raw/refs/heads/main/on-screen-keyboard-ext.tar.gz
wget https://raw.githubusercontent.com/Jwrightmcps/raspberrypi5-hoobs-v5/refs/heads/main/disable-hoobs-kiosk.sh
wget https://raw.githubusercontent.com/Jwrightmcps/raspberrypi5-hoobs-v5/refs/heads/main/enable-hoobs-kiosk.sh
wget https://raw.githubusercontent.com/Jwrightmcps/raspberrypi5-hoobs-v5/refs/heads/main/launch-chrome-on-screen-keyboard.sh
chmod +x disable-hoobs-kiosk.sh
chmod +x enable-hoobs-kiosk.sh
chmod +x launch-chrome-on-screen-keyboard.sh
tar -xf on-screen-keyboard-ext.tar.gz

if grep -Fxq "[idle]" ~/.config/wayfire.ini; then
  sed -i 's/dpms_timeout=600/dpms_timeout=180/' ~/.config/wayfire.ini
  sed  '/\[idle\]/a disable_on_fullscreen = false' ~/.config/wayfire.ini
else
printf "%s\n" "[idle]" >> ~/.config/wayfire.ini
printf "%s\n" "disable_on_fullscreen = false" >> ~/.config/wayfire.ini
printf "%s\n" "dpms_timeout=180" >> ~/.config/wayfire.ini
fi

rm config.yaml
rm setup-hoobs-for-raspi-5.sh
rm on-screen-keyboard-ext.tar.gz
rm -rf ~/hideaway/

# Apply settings
sudo raspi-config nonint do_finish
printf "%s\n" "Please reboot system for all changes to take effect"
