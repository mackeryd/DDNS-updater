#!/bin/sh
# This script is set up as a cron job on my home server as a dynamic DNS work around. It compares a file containing my last known ip address to the ip address captured by the curl command, and if they are different it replaces the ip in the text file, updates my dns records at epik and sends me an email containing the new ipaddress.

# Epik DDNS signature you need to get this from epik to interact with the api.
# Sig="XXXX-XXXX-XXXX-XXXX"

# text file storing last known ip
Text="/home/mack/.local/share/cip.txt"

# Get outside ip address using curl
WanIp=`curl -s https://api.ipify.org | cut -b 1-13`

# File that stores currently associated ip address..im guessing this is sloppy...but oh well
Cip=`cat "$Text"`

# compare outside ip with current dns records ip, if different update text file, dns records and email me. I have msmtp set up on my server, what ever mail tool you use may be different.
if [ "$WanIp" != "$Cip" -a "$WanIp" != "" ]; then
         echo "$WanIp" > "$Text" && curl -s -X POST "https://usersapiv2.epik.com/v2/ddns/set-ddns?SIGNATURE=XXXX-XXXX-XXXX-XXXX" -H  "accept: application/json" -H  "Content-Type: application/json" -d "{  \"hostname\": \"home\",  \"value\": \"$WanIp\"}" >> /dev/null && msmtp -t < "$Text" you@youremail.com
fi
