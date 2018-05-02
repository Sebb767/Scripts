-- screen brightness helper
local open = io.open
local awful = require("awful")
local naughty = require("naughty")

local brightness = {}

-- read/write file helper

local function read_file(path)
    local file = open(path, "r") -- r read mode and b binary mode
    if not file then return nil end
    local content = file:read "*a" -- *a or *all reads the whole file
    file:close()
    return content
end

local function write_file(path, content)
  awful.util.spawn_with_shell("sudo /usr/local/bin/setbacklight " .. tonumber(content))
end

-- variables
local path = "/sys/class/backlight/intel_backlight/"
local max_br_path = path .. "max_brightness"
local cur_br_path = path .. "brightness"

brightness.refresh_widget = function () end

-- functions

brightness.max = function (  )
  return tonumber(read_file(max_br_path))
end

brightness.current = function (  )

  return tonumber(read_file(cur_br_path))
end
-- set max
brightness.currentPercent = function (  )
  max = brightness.max();
  cur = brightness.current()

  return math.ceil((cur * 100) / max)
end

brightness.screenOff = function (  )
  awful.util.spawn_with_shell("xset dpms force off")
end

brightness.set = function ( value )
  if value < 0 then
    brightness.screenOff()
  else
    write_file(cur_br_path, math.floor(value))
  end

end

brightness.up = function ( diff )
	if brightness.currentPercent() > 98 then
		brightness.set(brightness.max())
	else
    brightness.set(brightness.current() + (brightness.max() / 100) * diff)
	end

  brightness.refresh_widget()
end

brightness.down = function ( diff ) 

  if brightness.current() == 1 then
    brightness.set(-1) -- turn off screen
  else
    new = brightness.current() - (brightness.max() / 100) * diff

    if new < 1 then
      new = 1
    end

	  brightness.set(new)
  end

  brightness.refresh_widget()
end

brightness.inc = function (  )
  brightness.up(1)
end

brightness.inc5 = function (  )
  brightness.up(5)
end

brightness.dec = function (  )
  brightness.down(1)
end

brightness.dec5 = function (  )
  brightness.down(5)
end

return brightness