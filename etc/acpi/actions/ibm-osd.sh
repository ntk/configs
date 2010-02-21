#! /bin/sh

# displays text in arguments on X screen using osd_cat (in some nicely preconfigured style)

OSD_CAT=`which osd_cat`
XOSD="${OSD_CAT} -b slider -P 20  -A center -p bottom -c darkcyan -s 3 --font=-adobe-helvetica-bold-*-*-*-34-*-*-*-*-*-*-*"

# get user running X display (needed when run by script)
XUSER=`ps -C xinit -o user h`  
 
#if [ "${USER}" == "${XUSER}" ]; then
#    echo $@ | ${XOSD}
#else
    echo $@ | su ${XUSER} -c "DISPLAY=${DISPLAY:-:0.0} ${XOSD}"
#fi

echo -e "\033[00;34m::\033[01;33m Button F9 pressed - Info screen...                                                                                 \033[00;34m[\033[01;33mDONE\033[00;34m]" > /dev/tty1
