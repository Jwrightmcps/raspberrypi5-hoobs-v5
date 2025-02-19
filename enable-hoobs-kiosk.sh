#!/bin/bash
# Enable Hoobs Kiosk Mode

# -i 's/Exec=chromium-browser --wayland-text-input-version=3 --enable-wayland-ime --enable-virtual-keyboard/#Exec=chromium-browser --wayland-text-input-version=3 --enable-wayland-ime --enable-virtual-keyboard/' ~/.config/autostart/hoobs-ui.desktop
sed -i 's/Exec=chromium-browser --noerrdialogs --disable-infobars --kiosk/#Exec=chromium-browser --noerrdialogs --disable-infobars --start-fullscreen/' ~/.config/autostart/hoobs-ui.desktop
sed -i 's/#Exec=chromium-browser --noerrdialogs --disable-infobars --kiosk/Exec=chromium-browser --noerrdialogs --disable-infobars --kiosk/' ~/.config/autostart/hoobs-ui.desktop
sudo reboot
