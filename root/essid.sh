#!/bin/bash

echo -e "ESSID\t\t|\tQuality\n-------------------------------"

iwlist wlan0 scan | sed -E '/(^ *ESSID:.*$)|(^ *Quality=.*$)/!d;s/^ *//g;s/^ESSID:"(.*)"/\1/g;s/^Quality=([[:digit:]]{1,3}).*/\1%/g' | sed 'N;s/\n/\t\t\t/'
