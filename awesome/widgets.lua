-- Widget file
--
-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
require("awful.autofocus")
-- Widget and layout library
local wibox = require("wibox")
-- Notification library
local naughty = require("naughty")
local menubar = require("menubar")
local vicious = require("vicious")

-- {{{ Widget icons
themes = os.getenv("HOME") .. "/.config/awesome/theme"
theme = {}
theme.widget_cpu = themes .. "/icons/sunjack/cpu.png"
theme.widget_bat = themes .. "/icons/zenburn/bat.png"
theme.widget_mem = themes .. "/icons/sunjack/mem.png"
theme.widget_fs = themes .. "/icons/zenburn/disk.png"
theme.widget_net = themes .. "/icons/zenburn/down.png"
theme.widget_netup = themes .. "/icons/zenburn/up.png"
theme.widget_wifi = themes .. "/icons/zenburn/wifi.png"
theme.widget_mail = themes .. "/icons/sunjack/mail.png"
theme.widget_vol = themes .. "/icons/zenburn/vol.png"
theme.widget_org = themes .. "/icons/sunjack/cal.png"
theme.widget_date = themes .. "/icons/sunjack/time.png"
theme.widget_brightness = themes .. "/icons/sunjack/half.png"
theme.widget_crypto = themes .. "/icons/zenburn/crypto.png"
theme.widget_sep = themes .. "/icons/zenburn/separator.png"
-- }}}

local widgets = {}

-- helper function
-- return a color on a gradient based on a value
function gradient(color, to_color, min, max, value)
	local function color2dec(c)
		return tonumber(c:sub(2, 3), 16), tonumber(c:sub(4, 5), 16), tonumber(c:sub(6, 7), 16)
	end

	local factor = 0
	if (value >= max) then
		factor = 1
	elseif (value > min) then
		factor = (value - min) / (max - min)
	end

	local red, green, blue = color2dec(color)
	local to_red, to_green, to_blue = color2dec(to_color)

	red = red + math.floor(0.5 + (factor * (to_red - red)))
	green = green + math.floor(0.5 + (factor * (to_green - green)))
	blue = blue + math.floor(0.5 + (factor * (to_blue - blue)))

	-- dec2color
	return string.format("#%02x%02x%02x", red, green, blue)
end

--- Pads str to length len with char from right
lpad = function(str, len, char)
	if char == nil then
		char = " "
	end
	return string.rep(char, len - #str) .. str
end

rpad = function(str, len, char)
	if char == nil then
		char = " "
	end
	return str .. string.rep(char, len - #str)
end

-- reads a file
local function read_file(path)
    local file = open(path, "r") -- r read mode and b binary mode
    if not file then return nil end
    local content = file:read "*a" -- *a or *all reads the whole file
    file:close()
    return content
end

open = io.open;


widgets.brightnessicon = wibox.widget.imagebox()
widgets.volicon = wibox.widget.imagebox()
widgets.mailic = wibox.widget.imagebox()
widgets.cpuic = wibox.widget.imagebox()
widgets.ramic = wibox.widget.imagebox()
widgets.clockic = wibox.widget.imagebox()
widgets.calic = wibox.widget.imagebox()

widgets.brightnessicon:set_image(theme.widget_brightness)
widgets.mailic:set_image(theme.widget_mail)
widgets.cpuic:set_image(theme.widget_cpu)
widgets.ramic:set_image(theme.widget_mem)
widgets.clockic:set_image(theme.widget_date)
widgets.calic:set_image(theme.widget_org)

widgets.mailic:buttons(
	awful.util.table.join(
		awful.button(
			{},
			1,
			function()
				awful.util.spawn("xdg-open 'https://webmail.cetus.uberspace.de'")
			end
		)
	)
)

widgets.brightnesswidget = function(brightness)
	brightnesswidget = wibox.widget.textbox()
	brightnesswidget:set_text(brightness.currentPercent() .. "% ")

	brightness.rfr_fn = function()
		brightnesswidget:set_text(brightness.currentPercent() .. "% ")
	end

	return brightnesswidget
end

widgets.mailwidget = function()
	mailwidget = wibox.widget.textbox()
	mailwidget:set_text("-")

	mailtimer = timer({timeout = 31})
	mailtimer:connect_signal(
		"timeout",
		function()
			awful.util.spawn_with_shell('echo "mailwidget:set_text("$(/home/sebb/mailcheck.py)")" | awesome-client')
		end
	)
	mailtimer:start()

	return mailwidget
end

widgets.batterywidget = function()
	batterymon = wibox.widget.imagebox()
	batterymon_t = wibox.widget.textbox()

	-- battery widget function
	function update_bat_widget()
		img_base = "/home/sebb/.awesome/themes/icons/batterymon/battery_"

		-- get the values
		charging = read_file("/sys/class/power_supply/BAT0/status")
		precentage = tonumber(read_file("/sys/class/power_supply/BAT0/capacity"))
		precentage_normalized = math.floor((precentage + 5) / 20 + 1)

		-- check if charging
		charging_midfix = ""
		charging_prefix = "v"
		if charging == "Charging\n" then
			charging_midfix = "charging_"
			charging_prefix = "^"
		end
		if charging == "Unknown\n" then
			charging_midfix = "charging_"
			charging_prefix = "~ "
		end

		-- determine the image
		suffix = ""
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

	batterytimer = timer({timeout = 27})
	batterytimer:connect_signal("timeout", update_bat_widget)
	batterytimer:start()

	return batterymon, batterymon_t
end

widgets.memwidget = function()
	memwidget = wibox.widget.textbox()
	-- Register widget
	vicious.register(
		memwidget,
		vicious.widgets.mem,
		function(widget, args)
			local color = gradient("#3c763d", "#FF5656", 60, 100, args[1])
			local text = string.format("<span color='%s'>%s</span>", color, args[1] .. "% ")
			text = text .. "(" .. string.format("<span color='%s'>%s</span>", color, args[2]) .. "MB/" .. args[3] .. "MB) w/ "

			local swcolor = gradient("#3c763d", "#FF5656", 10, 100, args[5])
			text = text .. string.format("<span color='%s'>%s</span>", swcolor, args[5] .. "%") .. " Swap "

			return text
		end,
		7
	)
	-- "Mem $1% ($2MB/$3MB) w/ $5% Swap", 17)

	return memwidget
end

widgets.cpuwidget = function()
	cpuwidget = wibox.widget.textbox()
	-- Register widget
	vicious.register(
		cpuwidget,
		vicious.widgets.cpu,
		function(widget, args)
			local text
			-- list only real cpu cores
			for i = 1, #args do
				local value = args[i]

				if value == 100 then
					value = "1.00"
				elseif value < 10 then
					value = "0.0" .. value
				else
					value = "0." .. value
				end

				-- alerts, if system is stressed
				if args[i] > 50 then
					-- from light green to light red
					local color = gradient("#AECF96", "#FF5656", 50, 100, args[i])

					args[i] = string.format("<span color='%s'>%s</span>", color, value)
				else
					args[i] = value
				end

				-- append to list
				if i > 2 then
					text = text .. "/ " .. args[i] .. " "
				else
					text = args[i] .. " "
				end
			end

			return text
		end
	)

	return cpuwidget
end

return widgets
