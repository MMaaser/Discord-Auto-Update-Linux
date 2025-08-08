# Discord-Auto-Update-Linux
This script changes your discord.desktop file to one pointing towards the script. Whenever the application is accessed via the desktop file, it will check if the device version of Discord matches the one Discord is pushing people to download. If they don't match, the system will update.

Compatibility that I'm too lazy to change:
It's written for KDE Wayland, so those environment issues are at the top of the script.
It checks if the script is running in a Konsole window, but if you don't have that, you'll need to change it to your terminal emulator. 
It updates the system with pacman. Change it to apt, yum, or whatever you use. 
