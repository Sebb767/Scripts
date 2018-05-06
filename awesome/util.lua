local awful = require("awful")
local naughty = require("naughty")

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

local volume = {up = vup, down = vdown, mute = vmute}

-- screen lock
function lock_screen()
  awful.util.spawn_with_shell("mate-screensaver-command -l")
end

function notify_not_locked()
  notification =
    naughty.notify(
    {
      title = "Prevented locking",
      text = "The lock was prevent due to a no-lock file being in place.",
      timeout = 5,
      position = "top_right",
      run = function()
        lock_timeout:stop()
      end
    }
  )
end

function lock_screen_timeout()
  lock_timeout = timer({timeout = 1})

  notification = 0
  seconds = 10

  notification =
    naughty.notify(
    {
      title = "You're Idle",
      text = "Locking screen in 10 seconds",
      timeout = 1,
      position = "top_right",
      run = function()
        lock_timeout:stop()
      end
    }
  )

  lock_timeout:connect_signal(
    "timeout",
    function()
      seconds = seconds - 1

      if seconds <= 0 then
        --lock_screen()
        lock_timeout:stop()
      else
        naughty.notify(
          {
            title = "You're Idle",
            text = "Locking screen in " .. seconds .. " seconds",
            timeout = 1,
            position = "top_right",
            run = function()
              lock_timeout:stop()
            end,
            replareplaces_id = notification
          }
        )
      end
    end
  )
  lock_timeout:start()
end
