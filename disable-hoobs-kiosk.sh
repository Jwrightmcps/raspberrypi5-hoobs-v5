#!/bin/bash
# Disable Hoobs Kiosk Mode
sed -i 's/#Exec=chromium-browser --load-extension/Exec=chromium-browser --load-extension/' ~/.config/autostart/hoobs-ui.desktop
sed -i 's/Exec=chromium-browser --noerrdialogs --disable-infobars --kiosk/#Exec=chromium-browser --noerrdialogs --disable-infobars --kiosk/' ~/.config/autostart/hoobs-ui.desktop
sudo reboot
