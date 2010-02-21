#!/bin/bash
. /etc/acpi/actions/print_info

stat_busy "Configuring VGA"


if xrandr -q | grep "VGA connected" > /dev/null ; then
	osd_print "VGA set to 1024x768"
	xrandr --output LVDS --mode "1024x768" --output VGA --mode "1024x768"
else
	osd_print "Auto configurate VGA"
	xrandr --output LVDS --auto --output VGA --auto
fi
