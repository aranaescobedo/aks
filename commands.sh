#!/bin/bash

#It displays the username of the current user when this command is invoked.
whoami

#Displays the user's unique identification number.
echo $UID

#Will show you a detailed list of all files and directories, including hidden ones, in the current directory.
ls -la

#Transform a plain text or password into a Base64-encoded format for various applications and data storage.
echo <PASSWORD> | base64

#Convert a Base64-encoded password back into its plain text form.
echo <PASSWORD> | base64 --decode

#GOOD TO KNOW.
#If you are using bash (the default), your prompt will tell you if you are acting as root.
#If it ends in a '$' you are running as a normal user. If it ends in a '#' you are running as root.

#Switch to the specified user and open a new Bash shell session.
sudo -u az-<USER_NAME> /bin/bash

#Perform a traceroute to the specified hostname to trace the network path using ICMP or UDP packets
traceroute <HOSTNAME_WTIHOUT_HTTPS/HTTP> <PORT>

#Perform a TCP traceroute to the specified hostname and port to trace the network path using TCP packets.
tcptraceroute <HOSTNAME_WTIHOUT_HTTPS/HTTP> <PORT>

#Use netcat to establish a connection to the specified hostname and port.
nc <HOSTNAME_WTIHOUT_HTTPS/HTTP> <PORT>
