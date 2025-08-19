#! /bin/bash

export DISPLAY=:0
export XDG_CURRENT_DESKTOP=KDE
export DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/1000/bus

# save file descriptor for this terminal
exec 3>&1 4>&2

# make it shut up
exec > /dev/null 2>&1

#url information
download_html=$(/usr/bin/curl https://discord.com/api/download?platform=linux&format=tar.gz)
html_length=$(echo $download_html | wc -c)
numbers=0123456789
startNum=e
endNum=e
startLink=e

#locates the beginning of the link to download discord through the html of the download site
for (( i=0; i<$html_length ; i++ )); do
	samplestr="${download_html:i:8}"
	if [ "$startLink" = e ] && [ "$samplestr" = "cordapp." ]; then
	      startLink=$i
	fi
done	

#locates the beginning of the version number
for (( i=$startLink ; i<$html_length ; i++ )); do
char=${download_html:i:1}
if [ $startNum = e ] && [[ 0123456789 = *$char* ]]; then
	startNum=$i	
fi
done

#locates the end of the version number
for (( i=$startNum ; i < $html_length ; i++ )); do
	char=${download_html:$i:1}
	if [ $endNum = e ] &&  [[ 0123456789. != *$char* ]]; then
	endNum=$i
	fi
done

#contrast latest stable discord version with device version
version=${download_html:$startNum:$((endNum - startNum))}
deviceVersion=$(pacman -Q discord)

#remove these lines if you've already changed these settings through a system editor, like application editor on KDE
sed 's/Exec=/Exec="$(readlink -f "${BASH_SOURCE}")"/' /home/"$USER"/.local/share/applications/discord.desktop #changes the script discord.desktop runs to this one
sed 's/Terminal=/Terminal=true/' /home/"$USER"/.local/share/applications/discord.desktop

# let it speak
exec > /dev/tty 2>/dev/tty

#check if latest version = device version, then downloads the latest version if they don't match up 
if [[ $deviceVersion != *$version* ]]; then
	rm -rf /home/max/Downloads/Discord
	sudo pacman -Syu
	sed 's/Name=/Name=Discord(Autoupdate)/' /home/"$USER"/.local/share/applications/discord.desktop
	sed 's/Exec=/Exec=/home/max/Documents/bashScripts/discordUpdate.sh' /home/"$USER"/.local/share/applications/discord.desktop
		if [[ $deviceVersion != $(pacman -Q discord) ]]; then
			notify-send "Discord updated."
			discord
		else
			notify-send "Discord failed to update."

		fi
else
	notify-send "Discord is already up to date."
	discord
fi
