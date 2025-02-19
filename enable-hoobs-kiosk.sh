#!/bin/bash
# Enable Hoobs Kiosk Mode
sed -i 's/Exec=chromium-browser --noerrdialogs --disable-infobars --start-fullscreen/#Exec=chromium-browser --noerrdialogs --disable-infobars --start-fullscreen/' ~/.config/autostart/hoobs-ui.desktop
sed -i 's/#Exec=chromium-browser --noerrdialogs --disable-infobars --kiosk/Exec=chromium-browser --noerrdialogs --disable-infobars --kiosk/' ~/.config/autostart/hoobs-ui.desktop
sudo reboot
