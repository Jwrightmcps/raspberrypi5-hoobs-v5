#!/bin/bash
# Disable Disable Hoobs Fullscreen Mode

sed -i 's/#Exec=chromium-browser --wayland-text-input-version=3 --enable-wayland-ime --enable-virtual-keyboard/Exec=chromium-browser --wayland-text-input-version=3 --enable-wayland-ime --enable-virtual-keyboard/' ~/.config/autostart/hoobs-ui.desktop
sed -i 's/Exec=chromium-browser --noerrdialogs --disable-infobars --start-fullscreen/#Exec=chromium-browser --noerrdialogs --disable-infobars --start-fullscreen/' ~/.config/autostart/hoobs-ui.desktop
sudo reboot
