Bugfixes in 2.0.32.60
- Redesigned the 0-100 hz filter to produce better sound.
- Fixed "always on top" issues in windows.
- Removed "always on top" on linux since it wont work anyway.
- Included the fixed TSRemote.dll/libTSRemote.so.0.4 so the sdk works again.
- Fixed the windows installer so the windows celp codec is installed again.
- Did some speed improvements.

Whats new in version 2.0.31.55:
- Added a filter to remove 0 to +/- 100Hz sounds.
- Added an option for always-on-top.
Changes:
- Fixed the multi-monitor bug where ts would refuse to stay on the left monitor.

Whats new in version 2.0.31.53:
- nothing :P
Changes:
- The weblist now sorts disregarding starting prefixes like ### etc
Bugfixes:
- (windows) Fixed the windows client to correct buggy 8bit soundcards 
  recordings. This should fix the situation where 1 person starts to 
  speak, everyone becomes unintelligible.
- (windows) Worked around (or atleast made much less frequent) the 
  "static noise" issue. This is the situation where for no reason, 
  your microphone started making loud noises.
- Fixed a race bug that could cause a "Access Violation"
- Changed reconnect sequence.. Should fix some double logins.
- Connect window should show correctly now on systems using 
  larger fonts.
- (windows) Fixed a bad "missing dll" dialog message.
- Fixed the displaying of players in a channel that you are not in
  on public servers.
- Can't mute yourself any more
- Fixed handling of cr/lf in linux + windows. (so channel 
  descriptions and multi line textmessages show correctly)
- (windows) Can't set max channel users to -1 any more.
- People that are away cant talk to the channel anymore.
- Switch server keybind now also works after a failed connect.
- (windows) Can't resize the statusbar when maximized any more.
- (windows) Made some changes so the ts window stays visible.
- Manual ban should ban all (correct) ip's entered now.
- Fixed a few typeo's
- Fixed Connection Info window showing underlines on names with & in it.

Whats new in version 2.0.29.47:
- Speex support. New codecs ranging from 3.4 to 25.9 kbit
- Weblist has been designed. You can now request a filtered list.
- Commercial servers can specify banners that the clients should display (Check public teamspeak servers for example)
- lotsa minor fixes

Whats new in version 2.0.28.40:

- ability to mute players
- ability to ban / unban players (ip based)
- Bandwitdh enfocement
- New voice normalisation routine
- ability to record your session to a wav file.
- ability to force microphone input to 8 bit in windows
- server topic can be 256 chars now
- server description can be up to 4000 chars now
- enhanced protocol for higher speeds.
- totaly configurable permissions system
- last quick connect is always saved now
- ability to monitor bandwidth usage
- ability to move players to other channels (kinda like kick, but more friendly and more destinations)
- Version check

Bugfixes:
- fixed ts hanging on connect
- fixed ts hanging on close in linux
- fixed sound stopping after 1 hour or more
- fixed hyperlink underline length to large
- fixed ts crashing when using fast desktop switching in winxp
- potential bugfix on losing sound in directSound
- fixed a bug in keypress routines. (fixed gamebvoice puck hangs issue)
- and lots more


Whats new in version 2.0.26.27:

Compared to 2.0.25.25 we
- added Hyperlink-capabilities to the info and message areas
- Changed some sound code. Hopefully less problems with stuttering / white noise
- fixed weblist
- possibly fixed client sometimes hanging on connect
- added more debug info for disconnection problem
- fixed more bugs
