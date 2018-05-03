#!/bin/bash
# if you want to use the laptop mode, set $1 to something

#
# basic system configuration
#
pulseaudio --check || start-pulseaudio-x11 &
if [ -s ~/.Xmodmap ]; then
    xmodmap ~/.Xmodmap
fi

#
# demons & applets
#
pgrep redshift || redshift -l 49.75:11.07 &
mate-screensaver & # auto singleton
# lock screen after some time
[ -z "$1" ] && grep xautolock || xautolock -time 5 -notifier "echo 'lock_screen_timeout()' | awesome-client" -notify 10 -locker "/home/sebb/bin/lock" &
[ -z "$1" ] && pgrep nm-applet || $HOME/bin/nm-applet-loop.sh & #

#
# applications
#
pgrep chromium || (chrome; sleep 2; chrome --app-id=clhhggbfdinjmjhajaheehoeibfljjno)

