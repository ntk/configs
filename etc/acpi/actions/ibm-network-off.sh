#! /bin/sh

# Turn off all network connections and print information

. /etc/acpi/actions/print_info

stat_busy "Turning off all network connections"

(iwconfig eth1 txpower off && /usr/bin/netcfg -a && stat_done && osd_print "network connections: OFF") || (stat_fail && osd_print "error while turning off network")

# TODO
# ermoegliche auch das einschalten!
    #    if [ $? -gt 0 ]; then
    #       stat_fail
    #    else

