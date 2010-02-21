#!/bin/bash

while true
   do
      if [ -d /sys/class/power_supply/BAT0 ]; then
         acpitool -b | sed 's/^.* : //;s/,/ ][/g'
      else
	 echo "no battery"
      fi
      
      sleep 10
   done
