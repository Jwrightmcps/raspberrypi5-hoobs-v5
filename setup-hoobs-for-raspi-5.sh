#!/bin/bash
# Custom setup for RaspberryPi 5 Hoobs Server with Desktop support
 #wget https://raw.githubusercontent.com/Jwrightmcps/raspberrypi5-hoobs-v5/refs/heads/main/setup-hoobs-for-raspi-5.sh && chmod +x setup-hoobs-for-raspi-5.sh && ./setup-hoobs-for-raspi-5.sh 2>&1 | tee setup-hoobs-for-raspi-5.log
# Start in user's home directory
cd ~
# Set the locale to en-US if not already set
if [ "$(grep LANG=en_US /etc/default/locale)" = "LANG=en_US" ];then
	exit 0
    else
	sudo sh -c 'echo "LANG=en_US.UTF-8\nLANGUAGE=en_US.UTF-8\nLC_ALL=en_US.UTF-8" > /etc/default/locale'
fi
# Update the OS
sudo apt update && sudo apt upgrade -y
# Update the firmware
sudo rpi-eeprom-update
# Get the Raspberry Pi Board Type (4 = pi4, 5 = pi5, etc.)
sudo raspi-config nonint get_pi_type 
# Enable splash on boot
sudo raspi-config nonint do_boot_splash 0
# Set locale to en-US
sudo raspi-config nonint do_change_locale en_US.UTF-8
# Set keyboard to en-US
sudo raspi-config nonint do_configure_keyboard
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
# Install interception tools
sudo apt install -y interception-tools interception-tools-compat cmake
# Change into home directory
cd ~
# Clone the hideaway repo and build
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
# Set the repo for Hoobs
wget -qO- https://dl.hoobs.org/stable | sudo bash -
# Install hoobs server and command line tools
sudo apt install hoobsd hoobs-cli -y
# Install Hoobs Hub
sudo hbs install -p 80
# Create autostart directory
if [ ! -d ~/.config/autostart ]; then
mkdir ~/.config/autostart
fi
# Create pcmanfm directory
if [ ! -d ~/.config/pcmanfm ]; then
mkdir ~/.config/pcmanfm
fi
# Create pcmanfm/LXDE-pi directory
if [ ! -d ~/.config/pcmanfm/LXDE-pi ]; then
mkdir ~/.config/pcmanfm/LXDE-pi
fi
# Get supporting files
wget https://github.com/Jwrightmcps/raspberrypi5-hoobs-v5/raw/refs/heads/main/hoobs-theme.tar.gz
wget https://github.com/Jwrightmcps/raspberrypi5-hoobs-v5/raw/refs/heads/main/on-screen-keyboard-ext.tar.gz
wget https://raw.githubusercontent.com/Jwrightmcps/raspberrypi5-hoobs-v5/refs/heads/main/hoobs-ui.desktop -O ~/.config/autostart/hoobs-ui.desktop
wget https://raw.githubusercontent.com/Jwrightmcps/raspberrypi5-hoobs-v5/refs/heads/main/wf-panel-pi.ini -O ~/.config/wf-panel-pi.ini
wget https://raw.githubusercontent.com/Jwrightmcps/raspberrypi5-hoobs-v5/refs/heads/main/desktop-items-HDMI-A-1.conf -O ~/.config/pcmanfm/LXDE-pi/desktop-items-HDMI-A-1.conf
sudo wget https://raw.githubusercontent.com/Jwrightmcps/raspberrypi5-hoobs-v5/refs/heads/main/wayland-browser -O /usr/bin/wayland-browser
sudo wget https://raw.githubusercontent.com/Jwrightmcps/raspberrypi5-hoobs-v5/refs/heads/main/enable-hoobs-kiosk -O /usr/bin/enable-hoobs-kiosk
sudo wget https://raw.githubusercontent.com/Jwrightmcps/raspberrypi5-hoobs-v5/refs/heads/main/disable-hoobs-kiosk -O /usr/bin/disable-hoobs-kiosk
sudo chmod +x /usr/bin/wayland-browser
sudo chmod +x /usr/bin/enable-hoobs-kiosk
sudo chmod +x /usr/bin/disable-hoobs-kiosk
tar -xf hoobs-theme.tar.gz
tar -xf on-screen-keyboard-ext.tar.gz
sudo mv /usr/share/plymouth/themes/pix/splash.png /usr/share/plymouth/themes/pix/splash.png.default
sudo mv splash.png /usr/share/plymouth/themes/pix/splash.png
sudo mv hoobs.png /usr/share/rpd-wallpaper/hoobs.png
sudo plymouth-set-default-theme -R pix
mv gkiknnlmdgcmhmncldcmmnhhdiakielc .gkiknnlmdgcmhmncldcmmnhhdiakielc
# Fix-up for screen blanking
if grep -Fxq "[idle]" ~/.config/wayfire.ini; then
  sed -i 's/dpms_timeout=600/dpms_timeout=180/' ~/.config/wayfire.ini
  sed  '/\[idle\]/a disable_on_fullscreen = false' ~/.config/wayfire.ini
else
printf "%s\n" "[idle]" >> ~/.config/wayfire.ini
printf "%s\n" "disable_on_fullscreen = false" >> ~/.config/wayfire.ini
printf "%s\n" "dpms_timeout=180" >> ~/.config/wayfire.ini
fi
# Clean-up
rm config.yaml
rm setup-hoobs-for-raspi-5.sh
rm on-screen-keyboard-ext.tar.gz
rm hoobs-theme.tar.gz
rm -rf ~/hideaway/
# Apply raspi settings
sudo raspi-config nonint do_finish
printf "%s\n" "Rebooting system for all changes to take effect"
# Reboot system
sudo reboot
