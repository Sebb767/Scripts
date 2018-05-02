-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
awful.rules = require("awful.rules")
require("awful.autofocus")
-- Widget and layout library
local wibox = require("wibox")
-- Theme handling library
local beautiful = require("beautiful")
-- Notification library
local naughty = require("naughty")
local menubar = require("menubar")
local vicious = require("vicious")
local open = io.open
local brightness = require('brightness')

-- Load Debian menu entries
--require("debian.menu")

-- {{ naughty styling
naughty.config.defaults.title            = "Notification"
naughty.config.defaults.timeout          = 5
naughty.config.defaults.screen           = 1
naughty.config.defaults.position         = "bottom_right"
naughty.config.defaults.margin           = 10
naughty.config.defaults.margin_bottom    = 30
naughty.config.defaults.height           = nil
naughty.config.defaults.width            = nil
naughty.config.defaults.gap              = 1
naughty.config.defaults.ontop            = true
--naughty.config.defaults.font             = beautiful.font or "Verdana 14"
naughty.config.defaults.icon             = "/home/sebb/.awesome/archlinux-icon.svg"
naughty.config.defaults.icon_size        = 120
naughty.config.defaults.fg               = '#000000'
naughty.config.defaults.bg               = '#ffffff'
--naughty.config.defaults.fg               = '#000000'
--naughty.config.defaults.bg               = '#ffffff'
naughty.config.defaults.border_width     = 1
naughty.config.defaults.hover_timeout    = nil
  
-- }}

-- {{{ Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
    naughty.notify({ preset = naughty.config.presets.critical,
                     title = "Oops, there were errors during startup!",
                     text = awesome.startup_errors })
end

-- Handle runtime errors after startup
do
    local in_error = false
    awesome.connect_signal("debug::error", function (err)
        -- Make sure we don't go into an endless error loop
        if in_error then return end
        in_error = true

        naughty.notify({ preset = naughty.config.presets.critical,
                         title = "Oops, an error happened!",
                         text = err })
        in_error = false
    end)
end
-- }}}

-- {{{ Variable definitions
-- Themes define colours, icons, font and wallpapers.
--beautiful.init("/home/sebb/.config/awesome/themes/matrix/theme.lua")
beautiful.init("/home/sebb/.config/awesome/themes/glass/theme.lua")

-- This is used later as the default terminal and editor to run.
terminal = "mate-terminal"
editor = os.getenv("EDITOR") or "vi"
editor_cmd = terminal .. " -e " .. editor

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
modkey = "Mod4"

-- Table of layouts to cover with awful.layout.inc, order matters.
local layouts =
{
--    awful.layout.suit.floating,
    awful.layout.suit.tile.top,
    awful.layout.suit.tile,
    awful.layout.suit.tile.left,
    awful.layout.suit.tile.bottom,
--    awful.layout.suit.fair,
--    awful.layout.suit.fair.horizontal,
--    awful.layout.suit.spiral,
--    awful.layout.suit.spiral.dwindle,
--    awful.layout.suit.magnifier
    awful.layout.suit.max,
    awful.layout.suit.max.fullscreen,
}
-- }}}

-- {{{ Wallpaper
if beautiful.wallpaper then
    for s = 1, screen.count() do
        gears.wallpaper.maximized(beautiful.wallpaper, s, true)
    end
end
-- }}}

-- {{{ Tags
-- Define a tag table which hold all screen tags.
tags = {}
for s = 1, screen.count() do
    -- Each screen has its own tag table.<
    tags[s] = awful.tag({ 1, 2, 3, "telegram", "chrome", "mpd", "srv", "bg", "kp" }, s, layouts[1])
end
-- }}}


-- sets the desktop background
function setbg()
    for s = 1, screen.count() do

    local f = io.popen("sh -c \"find ~/.awesome/backgrounds -name '*.png' -o -name '*.jpg' | shuf -n 1 | xargs echo -n\"")
    local wallpaper = f:read("*all")

    -- set wallpaper to current index
    gears.wallpaper.maximized( wallpaper, s, true)

  end
end



-- volume
function vup()
  awful.util.spawn_with_shell("/home/sebb/bin/pa-vol-ctl incv")
  update_vol()
end

function vdown()
  awful.util.spawn_with_shell("/home/sebb/bin/pa-vol-ctl decv")
  update_vol()
end

function vmute()
  awful.util.spawn_with_shell("/home/sebb/bin/pa-vol-ctl mute")
  update_vol()
end

-- screen lock
function lock_screen()
  awful.util.spawn_with_shell("mate-screensaver-command -l")
end

function notify_not_locked()
  notification = naughty.notify({ title = "Prevented locking", text = "The lock was prevent due to a no-lock file being in place.", timeout = 5, position="top_right", run= function ()
    lock_timeout:stop()
  end })
end

function lock_screen_timeout()
  lock_timeout = timer({ timeout = 1 })

  notification = 0
  seconds = 10

  notification = naughty.notify({ title = "You're Idle", text = "Locking screen in 10 seconds", timeout = 1, position="top_right", run= function ()
    lock_timeout:stop()
  end })
  

  lock_timeout:connect_signal("timeout", function() 
  seconds = seconds - 1

  if seconds <= 0 then

    lock_timeout:stop()
    --lock_screen()

  else

    naughty.notify({ title = "You're Idle", text = "Locking screen in " .. seconds .. " seconds", timeout = 1, position="top_right", run= function ()
      lock_timeout:stop()
    end, replareplaces_id= notification })
    
  end

end)
lock_timeout:start()


end

-- shutdown dialog
function sd_dialog()
  awful.util.spawn_with_shell("shutdown-dialog")
end

-- gradients
function gradient(color, to_color, min, max, value)
    local function color2dec(c)
        return tonumber(c:sub(2,3),16), tonumber(c:sub(4,5),16), tonumber(c:sub(6,7),16)
    end

    local factor = 0
    if (value >= max ) then 
        factor = 1  
    elseif (value > min ) then 
        factor = (value - min) / (max - min)
    end 

    local red, green, blue = color2dec(color) 
    local to_red, to_green, to_blue = color2dec(to_color) 

    red   = red   + math.floor(0.5 + (factor * (to_red   - red)))
    green = green + math.floor(0.5 + (factor * (to_green - green)))
    blue  = blue  + math.floor(0.5 + (factor * (to_blue  - blue)))

    -- dec2color
    return string.format("#%02x%02x%02x", red, green, blue)
end

--- Pads str to length len with char from right
lpad = function(str, len, char)
    if char == nil then char = ' ' end
    return string.rep(char, len - #str) .. str
end

-- read/write file helper

local function read_file(path)
    local file = open(path, "r") -- r read mode and b binary mode
    if not file then return nil end
    local content = file:read "*a" -- *a or *all reads the whole file
    file:close()
    return content
end

local function write_file(path, content)
  file = io.open(path, "w")
  file:write(content)
  file:close()
end

-- {{{ Menu
-- Create a laucher widget and a main menu
myawesomemenu = {
   { "manual", terminal .. " -e man awesome" },
   { "next bg", setbg },
   { "edit config", editor_cmd .. " " .. awesome.conffile },
   { "restart", awesome.restart },
   { "quit", awesome.quit }
}

mymainmenu = awful.menu({ items = { { "awesome", myawesomemenu, beautiful.awesome_icon },
--                                    { "Debian", debian.menu.Debian_menu.Debian },
                                    { "open terminal", terminal }
                                  }
                        })

mylauncher = awful.widget.launcher({ image = beautiful.awesome_icon,
                                     menu = mymainmenu })

-- Menubar configuration
menubar.utils.terminal = terminal -- Set the terminal for applications that require it
-- }}}





-- {{{ Wibox
-- icons
brightnessicon = wibox.widget.imagebox()
volicon = wibox.widget.imagebox()
unixtsicon = wibox.widget.imagebox()
mailic = wibox.widget.imagebox()
cpuic = wibox.widget.imagebox()
ramic = wibox.widget.imagebox()
clockic = wibox.widget.imagebox()

brightnessicon:set_image(theme.widget_brightness)
unixtsicon:set_image(theme.widget_date)
mailic:set_image(theme.widget_mail)
cpuic:set_image(theme.widget_cpu)
ramic:set_image(theme.widget_mem)
clockic:set_image(theme.widget_date)

-- brightnesswidget
brightnesswidget = wibox.widget.textbox()
brightnesswidget:set_text(brightness.currentPercent() .. "% ")
brightness.rfr_fn = function ()
  brightnesswidget:set_text(brightness.currentPercent() .. "% ")
end

-- mailwidget
mailwidget = wibox.widget.textbox()
mailwidget:set_text("-")

mailtimer = timer({ timeout = 31 })
mailtimer:connect_signal("timeout", function() awful.util.spawn_with_shell('echo "mailwidget:set_text(\"$(/home/sebb/mailcheck.py)\")" | awesome-client') end)
mailtimer:start()

mailic:buttons(awful.util.table.join(
   awful.button({ }, 1, function () awful.util.spawn("xdg-open 'https://webmail.cetus.uberspace.de'") end)
))

-- volume widget
volwidget = wibox.widget.textbox()
function update_vol ()
  awful.util.spawn_with_shell('/home/sebb/bin/pa-vol-ctl update')
end
update_vol()

-- timestamp widget
unixts = wibox.widget.textbox()
unixts:set_text(os.time())

unixtimer = timer({ timeout = 1 })
unixtimer:connect_signal("timeout", function() 
  unixts:set_text(os.time())
end)
--unixtimer:start()

-- battery widget
batterymon = wibox.widget.imagebox()
batterymon_t = wibox.widget.textbox()

-- battery widget function
function update_bat_widget() 
  img_base = "/home/sebb/.awesome/themes/icons/batterymon/battery_"

  -- get the values
  charging = read_file("/sys/class/power_supply/BAT0/status")
  precentage = tonumber(read_file("/sys/class/power_supply/BAT0/capacity"))
  precentage_normalized = math.floor((precentage + 5 ) / 20 + 1)

  -- check if charging
  charging_midfix = ""
  charging_prefix = "-"
  if charging == "Charging\n" then 
    charging_midfix = "charging_" 
    charging_prefix = "+"
  end
  if charging == "Unknown\n" then 
    charging_midfix = "charging_" 
    charging_prefix = "~~ "
  end

  -- determine the image
  suffix = "";
  if precentage < 7 then
    suffix = "empty"
  elseif precentage > 93 then
    suffix = "full"
  else
    suffix = precentage_normalized
  end

  file = img_base .. charging_midfix .. suffix .. ".png"


  batterymon:set_image(file)

  batterymon_t:set_text(" " .. charging_prefix .. precentage .. "%")

end

update_bat_widget()

batterytimer = timer({ timeout = 27 })
batterytimer:connect_signal("timeout", update_bat_widget)
batterytimer:start()


-- Create a textclock widget
mytextclock = awful.widget.textclock()

-- Initialize widget
cpuwidget = wibox.widget.textbox()
-- Register widget
vicious.register(cpuwidget, vicious.widgets.cpu,
function (widget, args)
  local text
  -- list only real cpu cores
  for i=1,#args do
    -- alerts, if system is stressed
    if args[i] > 50 then
      -- from light green to light red
      local color = gradient("#AECF96","#FF5656",50,100,args[i])
      args[i] = string.format("<span color='%s'>%s</span>", color, args[i])
    end

    -- append to list
    if i > 2 then text = text.."/"..lpad(args[i].."", 3).."% "
    else text = lpad(args[i].."", 2) .. "% " end
  end

  return text
end )


-- mem widget
-- Initialize widget
memwidget = wibox.widget.textbox()
-- Register widget
vicious.register(memwidget, vicious.widgets.mem, function (widget, args)
  local color = gradient("#3c763d","#FF5656",60,100,args[1])
  local text = string.format("<span color='%s'>%s</span>", color, args[1].."% ")
  text = text.."("..string.format("<span color='%s'>%s</span>", color, args[2]).."MB/"..args[3].."MB) w/ "

  local swcolor = gradient("#3c763d","#FF5656",10,100,args[5])
  text = text..string.format("<span color='%s'>%s</span>", swcolor, args[5].."%").." Swap "

  return text
end , 7)-- "Mem $1% ($2MB/$3MB) w/ $5% Swap", 17)

-- fs widget 
--fswidget = wibox.widget.textbox()
--vicious.register(fswidget, vicious.widgets.fs, " / is using ${/ used_gb}G = ${/ used_p}% of ${/ size_gb}G &lt;&gt; ", 30)


-- Create a wibox for each screen and add it
mywibox = {}
mypromptbox = {}
mylayoutbox = {}
mytaglist = {}
mytaglist.buttons = awful.util.table.join(
                    awful.button({ }, 1, awful.tag.viewonly),
                    awful.button({ modkey }, 1, awful.client.movetotag),
                    awful.button({ }, 3, awful.tag.viewtoggle),
                    awful.button({ modkey }, 3, awful.client.toggletag),
                    awful.button({ }, 4, function(t) awful.tag.viewnext(awful.tag.getscreen(t)) end),
                    awful.button({ }, 5, function(t) awful.tag.viewprev(awful.tag.getscreen(t)) end)
                    )
mytasklist = {}
mytasklist.buttons = awful.util.table.join(
                     awful.button({ }, 1, function (c)
                                              if c == client.focus then
                                                  c.minimized = true
                                              else
                                                  -- Without this, the following
                                                  -- :isvisible() makes no sense
                                                  c.minimized = false
                                                  if not c:isvisible() then
                                                      awful.tag.viewonly(c:tags()[1])
                                                  end
                                                  -- This will also un-minimize
                                                  -- the client, if needed
                                                  client.focus = c
                                                  c:raise()
                                              end
                                          end),
                     awful.button({ }, 3, function ()
                                              if instance then
                                                  instance:hide()
                                                  instance = nil
                                              else
                                                  instance = awful.menu.clients({
                                                      theme = { width = 250 }
                                                  })
                                              end
                                          end),
                     awful.button({ }, 4, function ()
                                              awful.client.focus.byidx(1)
                                              if client.focus then client.focus:raise() end
                                          end),
                     awful.button({ }, 5, function ()
                                              awful.client.focus.byidx(-1)
                                              if client.focus then client.focus:raise() end
                                          end))

for s = 1, screen.count() do
    -- Create a promptbox for each screen
    mypromptbox[s] = awful.widget.prompt()
    -- Create an imagebox widget which will contains an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    mylayoutbox[s] = awful.widget.layoutbox(s)
    mylayoutbox[s]:buttons(awful.util.table.join(
                           awful.button({ }, 1, function () awful.layout.inc(layouts, 1) end),
                           awful.button({ }, 3, function () awful.layout.inc(layouts, -1) end),
                           awful.button({ }, 4, function () awful.layout.inc(layouts, 1) end),
                           awful.button({ }, 5, function () awful.layout.inc(layouts, -1) end)))
    -- Create a taglist widget
    mytaglist[s] = awful.widget.taglist(s, awful.widget.taglist.filter.all, mytaglist.buttons)

    -- Create a tasklist widget
    mytasklist[s] = awful.widget.tasklist(s, awful.widget.tasklist.filter.currenttags, mytasklist.buttons)

    -- Create the wibox
    mywibox[s] = awful.wibox({ position = "top", height = "26",  screen = s })

    -- Widgets that are aligned to the left
    local left_layout = wibox.layout.fixed.horizontal()
    --left_layout:add(mylauncher)
    --left_layout:add(mytextclock)
    left_layout:add(mytaglist[s])
    --if s == 1 then left_layout:add(wibox.widget.systray()) end
    left_layout:add(mypromptbox[s])

    -- Widgets that are aligned to the right
    local right_layout = wibox.layout.fixed.horizontal()
    --right_layout:set_bg("#000000000")
    --if s == 1 then right_layout:add(wibox.widget.systray()) end
	
    --right_layout:add(fswidget)
    right_layout:add(volicon)
    right_layout:add(volwidget)
    right_layout:add(brightnessicon)
    right_layout:add(brightnesswidget)
    right_layout:add(batterymon)
    right_layout:add(batterymon_t)
    --right_layout:add(unixtsicon)
    --right_layout:add(unixts)
    right_layout:add(mailic)
    right_layout:add(mailwidget)
    right_layout:add(cpuic)
    right_layout:add(cpuwidget)
    right_layout:add(ramic)
    right_layout:add(memwidget)
    --right_layout:add(clockic)
    right_layout:add(mylayoutbox[s])

    -- Now bring it all together (with the tasklist in the middle)
    local layout = wibox.layout.align.horizontal()
    layout:set_left(left_layout)
    --layout:set_middle(mytasklist[s])
    layout:set_right(right_layout)

    mywibox[s]:set_widget(layout)
    mywibox[s]:set_bg("#0000000") -- due to bug
    --mywibox[s]:set_bg("#000000000")

    -- bottom wibox
    local bottom_wb = awful.wibox({ position = "bottom", height = "40",  screen = s })
    local blayout = wibox.layout.align.horizontal()

    local bottom_left_layout = wibox.layout.fixed.horizontal()

    bottom_left_layout:add(mylauncher)

    bottom_left_layout:add(batterymon)
    if s == 1 then bottom_left_layout:add(wibox.widget.systray()) end

    blayout:set_left(bottom_left_layout)

    blayout:set_middle(mytasklist[s])
    blayout:set_right(mytextclock)

    bottom_wb:set_widget(blayout)

    bottom_wb:set_bg("#101010") -- "#10101050" (due to bug)

end
-- }}}

-- {{{ Mouse bindings
root.buttons(awful.util.table.join(
    awful.button({ }, 3, function () mymainmenu:toggle() end),
    awful.button({ }, 4, awful.tag.viewnext),
    awful.button({ }, 5, awful.tag.viewprev)
))
-- }}}

-- {{{ Key bindings
globalkeys = awful.util.table.join(
    awful.key({ modkey,           }, "Left",   awful.tag.viewprev       ),
    awful.key({ modkey,           }, "Right",  awful.tag.viewnext       ),
    awful.key({ modkey,           }, "Escape", awful.tag.history.restore),

    awful.key({ modkey,           }, "F4",     setbg                    ),
    awful.key({ modkey,           }, "l",      lock_screen              ), 
    awful.key({ modkey, "Shift"   }, "l",      sd_dialog                ),

    awful.key({            }, "XF86MonBrightnessDown", brightness.dec5  ),
    awful.key({            }, "XF86MonBrightnessUp",   brightness.inc5  ),
    awful.key({ "Shift"    }, "XF86MonBrightnessDown", brightness.dec   ),
    awful.key({ "Shift"    }, "XF86MonBrightnessUp",   brightness.inc   ),
    awful.key({ modkey,    }, "b", function() 
        os.execute("sleep 0.2") -- wait for key release
        brightness.screenOff()
      end
    ),

    awful.key({            }, "XF86AudioMute",        vmute             ),
    awful.key({            }, "XF86AudioLowerVolume", vdown             ),
    awful.key({            }, "XF86AudioRaiseVolume", vup               ),


    awful.key({ modkey,           }, "j",
        function ()
            awful.client.focus.byidx( 1)
            if client.focus then client.focus:raise() end
        end),
    awful.key({ modkey,           }, "k",
        function ()
            awful.client.focus.byidx(-1)
            if client.focus then client.focus:raise() end
        end),
    awful.key({ modkey,           }, "w", function () mymainmenu:show() end),

    -- Layout manipulation
    awful.key({ modkey, "Shift"   }, "j", function () awful.client.swap.byidx(  1)    end),
    awful.key({ modkey, "Shift"   }, "k", function () awful.client.swap.byidx( -1)    end),
    awful.key({ modkey, "Control" }, "j", function () awful.screen.focus_relative( 1) end),
    awful.key({ modkey, "Control" }, "k", function () awful.screen.focus_relative(-1) end),
    awful.key({ modkey,           }, "u", awful.client.urgent.jumpto),
    awful.key({ modkey,           }, "Tab",
        function ()
            awful.client.focus.history.previous()
            if client.focus then
                client.focus:raise()
            end
        end),

    -- Standard program
    awful.key({ modkey,           }, "Return", function () awful.util.spawn(terminal) end),
    awful.key({ modkey, "Control" }, "r", awesome.restart),
    awful.key({ modkey, "Shift"   }, "q", awesome.quit),

    awful.key({ modkey,           }, "Up",     function () awful.tag.incmwfact( 0.05)    end),
    awful.key({ modkey,           }, "Down",     function () awful.tag.incmwfact(-0.05)    end),
    awful.key({ modkey, "Shift"   }, "Up",     function () awful.tag.incnmaster( 1)      end),
    awful.key({ modkey, "Shift"   }, "Down",     function () awful.tag.incnmaster(-1)      end),
    awful.key({ modkey, "Control" }, "Up",     function () awful.tag.incncol( 1)         end),
    awful.key({ modkey, "Control" }, "Down",     function () awful.tag.incncol(-1)         end),
    awful.key({ modkey,           }, "space", function () awful.layout.inc(layouts,  1) end),
    awful.key({ modkey, "Shift"   }, "space", function () awful.layout.inc(layouts, -1) end),

    awful.key({ modkey, "Control" }, "n", awful.client.restore),

    -- jump keys
    awful.key({ modkey,           }, "z", function () awful.tag.viewonly(tags[1][6]) end),
    awful.key({ modkey,           }, "c", function () awful.tag.viewonly(tags[1][5]) end),
    awful.key({ modkey,           }, "m", function () awful.tag.viewonly(tags[1][4]) end),

    -- Prompt
    awful.key({ modkey },            "r",     function () mypromptbox[1]:run() end,
              {description = "run prompt", group = "launcher"}),

    awful.key({ modkey }, "x",
              function ()
                  awful.prompt.run({ prompt = "Run Lua code: " },
                  mypromptbox[mouse.screen].widget,
                  awful.util.eval, nil,
                  awful.util.getdir("cache") .. "/history_eval")
              end),
    -- Menubar
    awful.key({ modkey }, "p", function() menubar.show() end),

    -- Screenshot
    awful.key({ modkey }, "s", function () awful.util.spawn("scrot '%Y-%m-%d_%H-%M-%S_$wx$h.png' -e 'mv $f ~/screenshots/ 2>/dev/null'") end)
)

clientkeys = awful.util.table.join(
    awful.key({ modkey,           }, "f",      function (c) c.fullscreen = not c.fullscreen  end),
    awful.key({ modkey, "Shift"   }, "c",      function (c) c:kill()                         end),
    awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle                     ),
    awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end),
    awful.key({ modkey,           }, "o",      awful.client.movetoscreen                        ),
    awful.key({ modkey,           }, "t",      function (c) c.ontop = not c.ontop            end),
    awful.key({ modkey,           }, "n",
        function (c)  
            -- The client currently has the input focus, so it cannot be
            -- minimized, since minimized clients can't have the focus.
            c.minimized = true
        end),
    awful.key({ modkey, "Shift"   }, "m",
        function (c)
            c.maximized_horizontal = not c.maximized_horizontal
            c.maximized_vertical   = not c.maximized_vertical
        end)
)

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it works on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 9 do
    globalkeys = awful.util.table.join(globalkeys,
        -- View tag only.
        awful.key({ modkey }, "#" .. i + 9,
                  function ()
                        local screen = mouse.screen
                        local tag = awful.tag.gettags(screen)[i]
                        if tag then
                           awful.tag.viewonly(tag)
                        end
                  end),
        -- Toggle tag.
        awful.key({ modkey, "Control" }, "#" .. i + 9,
                  function ()
                      local screen = mouse.screen
                      local tag = awful.tag.gettags(screen)[i]
                      if tag then
                         awful.tag.viewtoggle(tag)
                      end
                  end),
        -- Move client to tag.
        awful.key({ modkey, "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = awful.tag.gettags(client.focus.screen)[i]
                          if tag then
                              awful.client.movetotag(tag)
                          end
                     end
                  end),
        -- Toggle tag.
        awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = awful.tag.gettags(client.focus.screen)[i]
                          if tag then
                              awful.client.toggletag(tag)
                          end
                      end
                  end))
end

clientbuttons = awful.util.table.join(
    awful.button({ }, 1, function (c) client.focus = c; c:raise() end),
    awful.button({ modkey }, 1, awful.mouse.client.move),
    awful.button({ modkey }, 3, awful.mouse.client.resize))

-- Set keys
root.keys(globalkeys)
-- }}}

function custom_focus_filter(c) 
 -- awful.client.focus.filter,
  return nil 
end

-- {{{ Rules
-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = {
    -- All clients will match this rule.
    { rule = { },
      properties = { border_width = beautiful.border_width,
                     border_color = beautiful.border_normal,
                     focus = custom_focus_filter,
                     raise = true,
                     keys = clientkeys,
                     buttons = clientbuttons,
                     maximized_vertical = false, 
                     maximized_horizontal = false,
                     maximized = false,
                     screen = function (c) return awesome.startup and c.screen or awful.screen.focused() end } },
    { rule = { class = "MPlayer" },
      properties = { floating = true } },
    { rule = { class = "pinentry" },
      properties = { floating = true } },
    { rule = { class = "gimp" },
      properties = { floating = true } },

    -- Set chromium to always map on tags number 2 of screen 1.
     { rule = { class = "Chromium", role="browser" },
       properties = { tag = tags[1][5] } },
     { rule = { class = "Chromium", role = "app" }, 
        --{ class = "crx_clhhggbfdinjmjhajaheehoeibfljjno" },
       properties = { tag = tags[1][4] } },
     { rule = { class = "Evolution" }, 
       properties = { tag = tags[1][6] } },
       
     { rule = { class = "google-chrome", role="browser" },
       properties = { border_width = 10,
                     border_color = "FF6600" }  },
      -- InputOutputmaximi
      { rule = { name = "2D-Test" },
       properties = { border_width = 4, floating = true,
                     border_color = "FF6600" }  },

      { rule = { name = "Basic 2D Renderer" },
       properties = { border_width = 4, floating = true,
                     border_color = "FF6600" }  },
    -- vms
     { rule = { class = "qemu-system-x86_64" },
       properties = { border_width = 10, 
                     border_color = "FF6600" } },
       
--    { rule = { class = "Mono" },
--      properties = { border_width = 0, floating = true } },
    -- intellij fix
    { rule = { 
        class = "jetbrains-.*",
        instance = "sun-awt-X11-XWindowPeer",
        name = "win.*"
    },  
    properties = { 
        floating = true,
        focus = true,
        focusable = false,
        ontop = true,
        placement = awful.placement.restore,
        buttons = {}
    }   
},

}
-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c, startup)
    -- Enable sloppy focus
    c:connect_signal("mouse::enter", function(c)
        if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
            and awful.client.focus.filter(c) then
            client.focus = c
        end
    end)

    if not startup then
        -- Set the windows at the slave,
        -- i.e. put it at the end of others instead of setting it master.
        -- awful.client.setslave(c)

        -- Put windows in a smart way, only if they does not set an initial position.
        if not c.size_hints.user_position and not c.size_hints.program_position then
            awful.placement.no_overlap(c)
            awful.placement.no_offscreen(c)
        end
    end

    local titlebars_enabled = false
    if titlebars_enabled and (c.type == "normal" or c.type == "dialog") then
        -- buttons for the titlebar
        local buttons = awful.util.table.join(
                awful.button({ }, 1, function()
                    client.focus = c
                    c:raise()
                    awful.mouse.client.move(c)
                end),
                awful.button({ }, 3, function()
                    client.focus = c
                    c:raise()
                    awful.mouse.client.resize(c)
                end)
                )

        -- Widgets that are aligned to the left
        local left_layout = wibox.layout.fixed.horizontal()
        left_layout:add(awful.titlebar.widget.iconwidget(c))
        left_layout:buttons(buttons)

        -- Widgets that are aligned to the right
        local right_layout = wibox.layout.fixed.horizontal()
        right_layout:add(awful.titlebar.widget.floatingbutton(c))
        right_layout:add(awful.titlebar.widget.maximizedbutton(c))
        right_layout:add(awful.titlebar.widget.stickybutton(c))
        right_layout:add(awful.titlebar.widget.ontopbutton(c))
        right_layout:add(awful.titlebar.widget.closebutton(c))

        -- The title goes in the middle
        local middle_layout = wibox.layout.flex.horizontal()
        local title = awful.titlebar.widget.titlewidget(c)
        title:set_align("center")
        middle_layout:add(title)
        middle_layout:buttons(buttons)

        -- Now bring it all together
        local layout = wibox.layout.align.horizontal()
        layout:set_left(left_layout)
        layout:set_right(right_layout)
        layout:set_middle(middle_layout)

        awful.titlebar(c):set_widget(layout)
    end
end)

client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
-- }}}

-- background

wp_index = 1
wp_timeout  = 60*10 -- 10 min

-- setup the timer
wp_timer = timer { timeout = wp_timeout }
wp_timer:connect_signal("timeout", function()
  setbg()

  -- stop the timer (we don't need multiple instances running at the same time)
  wp_timer:stop()

  --restart the timer
  wp_timer.timeout = wp_timeout
  wp_timer:start()
end)

wp_timer:start()
setbg()

awful.util.spawn_with_shell("/home/sebb/.config/awesome/rc.sh")

