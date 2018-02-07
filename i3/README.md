# i3 configuration

This is my work i3 configuration. It uses to screens; one WUXGA (that's 1920x1200), which is my main, and left of it my Laptop Screen in FullHD (1920x1080). The modifier is configured to be Mod4 (that's the winkey).

It expects some wallpapers to be contained in `~/.wallpaper`. Those will be set radomly as desktop background via feh and used for i3lock.

## The workspaces

- *1-3* are on the mainscreen and are primarily for work.
- *4* is used for mail (evolution in my case) and on screen 2. It's also reachable via Mod+M.
- *5* is my primary browser. It's on the mainscreen and also reachable via Mod+C.
- *6* is used for my secondary browser (for music usually). It's on the secondary screen and reachable via Mod+P.
- *7* is my IRC client (hexchat) on the secondary screen. It can be reached with Mod+I.
- *8,9* are unused and on the main and secondary monitor, respectively.

## Changed keybindings

- the cursor keys are hjkl instead of jkl;. I'm a vi user, yes.
- horizontal splitting is therefore on Mod+G.
- Mod+\ executes `/home/sebb/bin/lock`, which locks my screen (the script is contained in the repo).
- Mod+R works the same way as Mod+D does. I use awesome WM at home.
- that's why Mod+Shift+C also works for closing windows.
- The keycodes for controlling audio are bound with pulseaudio and the ones for screen brightness (on laptops) are bound via xbacklight.

## other things

- `nm-applet` will be executed at startup.
