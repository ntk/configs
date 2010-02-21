#!/bin/sh
# $Xorg: xinitrc.cpp,v 1.3 2000/08/17 19:54:30 cpqbld Exp $

userresources=$HOME/.Xresources
usermodmap=$HOME/.Xmodmap
sysresources=/etc/X11/xinit/.Xresources
sysmodmap=/etc/X11/xinit/.Xmodmap

# merge in defaults and keymaps

if [ -f $sysresources ]; then
    xrdb -merge $sysresources
fi

if [ -f $sysmodmap ]; then
    xmodmap $sysmodmap
fi

if [ -f "$userresources" ]; then
    xrdb -merge "$userresources"
fi

if [ -f "$usermodmap" ]; then
    xmodmap "$usermodmap"
fi


# start some nice programs

#twm &
#exec awesome
#xclock -geometry 50x50-1+1 &
#xterm -geometry 80x50+494+51 &
#xterm -geometry 80x20+494-0 &
#fluxbox &
 #awesome &
sudo tpb -d				# ThinkPad ButtonTool - enables e.g. OSD info
xset -b					# disable Systembell
#DISPLAY=:0.0 fbsetbg -l			# set background to last active
#xterm -geometry 120x41+25+20 -T xTerm -e /usr/bin/screen -c .screenrc_x -dR
urxvtd &
#exec xterm -geometry 120x41+25+20 -T xTerm -e /usr/bin/screen
 #exec urxvt -geometry 140x50 -e /usr/bin/screen

 
# The following variable defines the session which is started if the user doesn't explicitly select a session

DEFAULT_SESSION=awesome

case $1 in
fluxbox)
   exec fluxbox
#  exec exec xterm -geometry 120x41+25+20 -T xTerm -e /usr/bin/screen
   ;;
*)
   exec $DEFAULT_SESSION
#  awesome &
#  exec urxvtc -geometry 144x49 -e /usr/bin/screen -Rd
   ;;
esac

