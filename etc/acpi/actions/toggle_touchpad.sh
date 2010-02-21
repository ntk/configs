
#! /bin/sh

# Turn off all network connections and print information

. /etc/acpi/actions/print_info

#stat_busy "Toggle touchpad" 

if [ "${TOUCHPAD_OFF}"=="0" ]; then 
	TOUCHPAD_OFF='1'
	export TOUCHPAD_OFF
	/usr/bin/synclient -s TouchpadOff=1
else
	export TOUCHPAD_OFF=$'0'
	/usr/bin/synclient -s TouchpadOff=0
fi
