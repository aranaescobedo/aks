#!/bin/bash

#It displays the username of the current user when this command is invoked.
whoami

#Will show you a detailed list of all files and directories, including hidden ones, in the current directory.
ls -la

#Transform a plain text or password into a Base64-encoded format for various applications and data storage.
echo <PASSWORD> | base64

#Convert a Base64-encoded password back into its plain text form.
echo <PASSWORD> | base64 --decode
