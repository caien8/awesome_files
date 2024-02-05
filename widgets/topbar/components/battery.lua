local awful = require("awful")
local wibox = require("wibox")

local battery_path = "/sys/class/power_supply/BATT/"
local update_interval = 2

--* Function to read battery percentage
local function get_battery_percentage()
    local f = io.open(battery_path .. "capacity", "r")
    if f then
        local capacity = tonumber(f:read("*all"))
        f:close()
        return capacity
    end
    return 0
end

--* Function to read battery status
local function get_battery_status()
    local f = io.open(battery_path.. "status", "r")
    if f then
        local status = f:read("*all")
        f:close()
        return status
    end
    return "Unknown"
end

-- Function to update battery widget
local function update_battery_widget(widget)
    local capacity = get_battery_percentage()
    local status = get_battery_status()

    local battery_icon
    if status == "Charging" then
        battery_icon = "" -- You can replace this with your charging icon
    elseif capacity >= 80 then
        battery_icon = "" -- Battery full icon
    elseif capacity >= 60 then
        battery_icon = "" -- Battery 3/4 icon
    elseif capacity >= 40 then
        battery_icon = "" -- Battery 1/2 icon
    elseif capacity >= 20 then
        battery_icon = "" -- Battery 1/4 icon
    else
        battery_icon = "" -- Battery empty icon
    end

    widget.markup = '<span font="Roboto Medium 12">' .. battery_icon .. ' ' .. capacity .. '%</span>'
end

-- Create battery widget
local battery_widget = wibox.widget {
    widget = wibox.widget.textbox
}

-- Update battery widget initially
update_battery_widget(battery_widget)

-- Update battery widget every 60 seconds
awful.widget.watch("bash -c 'cat /sys/class/power_supply/BATT/capacity /sys/class/power_supply/BATT/status'", update_interval, 
    function(widget, stdout)
        update_battery_widget(widget)
    end,
    battery_widget
)

return battery_widget