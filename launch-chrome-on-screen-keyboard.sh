#!/bin/bash
# Launch chrome with wayland on-screen keyboard support
chromium-browser --wayland-text-input-version=3 --enable-wayland-ime --enable-virtual-keyboard http://www.google.com
