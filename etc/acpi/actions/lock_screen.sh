#!/bin/bash

# get user running X display (needed when run by script)
XUSER=`ps -C xinit -o user h`

su ${XUSER} -c "/usr/bin/xlock" &
