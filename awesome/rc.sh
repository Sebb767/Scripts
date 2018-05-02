#!/bin/bash

#
# basic system configuration
#
start-pulseaudio-x11 &
setxkbmap de
if [ -s ~/.Xmodmap ]; then
    xmodmap ~/.Xmodmap
fi

#
# demons & applets
#
pgrep redshift || redshift -l 49.75:11.07 &
mate-screensaver & # auto singleton
# lock screen after some time
pgrep xautolock || xautolock -time 5 -notifier "echo 'lock_screen_timeout()' | awesome-client" -notify 10 -locker "/home/sebb/bin/lock" &
pgrep nm-applet || $HOME/bin/nm-applet-loop.sh & #

#
# applications
#
pgrep chromium || (chrome; sleep 1; chrome --app-id=clhhggbfdinjmjhajaheehoeibfljjno)

