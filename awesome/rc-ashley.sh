#!/bin/bash
# Startup Script
once="run_once.sh"
home="/home/sebb"

# Startup programs
xmodmap ~/.Xmodmap # remap caps to mod4
pulseaudio --start
#$once $home/.dropbox-dist/dropboxd # start dropbox
LANG="de_DE.UTF-8" $once insync start # start insync (google drive client)
$once nemo --no-desktop -n # start fm service
$once redshift -l 49.7913:9.9534

