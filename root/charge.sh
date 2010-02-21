#!/bin/bash
if [ "${1}" > /dev/null ]; then
	echo $1 > /sys/devices/platform/smapi/BAT0/start_charge_thresh    
	echo $1 > /sys/devices/platform/smapi/BAT0/stop_charge_thresh    
else
	echo "Please enter a value"
fi

