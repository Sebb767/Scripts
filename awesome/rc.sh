#!/bin/bash
# if you want to use the laptop mode, set $1 to something

#
# basic system configuration
#
#pulseaudio --check || start-pulseaudio-x11 &
pulseaudio --check || pulseaudio --daemonize --start &
if [ -s ~/.Xmodmap ]; then
    xmodmap ~/.Xmodmap
fi
killall compton; compton -cCf -I 1 -O 0.04 &

#
# demons & applets
#
killall redshift; redshift -l 49.75:11.07 &
killall mate-screensaver; mate-screensaver & # auto singleton, but crashes on x restart
# lock screen after some time
[ -z "$1" ] && grep xautolock || xautolock -time 5 -notifier "echo 'util.lock_screen_timeout()' | awesome-client" -notify 10 -locker "/home/sebb/bin/lock" &
[ -z "$1" ] && ( pgrep nm-applet || $HOME/bin/nm-applet-loop.sh & ) #

#
# applications
#

#
# chrome
#
chrome=/usr/local/bin/chrome
function launch_chrome {
    $chrome &
    sleep 2
    $chrome --app-id=clhhggbfdinjmjhajaheehoeibfljjno &
}
pgrep chromium || launch_chrome

