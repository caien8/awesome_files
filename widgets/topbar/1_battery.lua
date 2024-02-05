local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")

-- Provides:
-- squeal::battery
--      percentage (integer)

local update_interval = 30

local bat_script = [[sh -c '
  echo "$(cat /sys/class/power_supply/BATT/capacity)"
']]

awful.widget.watch(bat_script, update_interval, function(_, stdout)
  local capacity = string.sub(stdout, 1, 2)
  awesome.emit_signal("squeal::battery", 
    value = tonumber(capacity)
  )
end)

local battery_widget = {}

local level_widget = {
    markup = "0%",
    font = "Roboto Medium 10",
    widget = wibox.widget.textbox
}

battery_widget = wibox.widget{
    level_widget,
    layout = wibox.layout.fixed.horizontal
}

awesome.connect_signal("squeal::battery", function(battery)
    level_widget.markup = battery.value
end)

return battery_widget

