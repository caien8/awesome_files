local awful = require("awful")
local wibox = require("wibox")
local battery_path = "/sys/class/power_supply/BATT/"
local update_interval = 1

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

--* Function to get the battery icon
local function get_battery_icon(status, capacity)
    if status == "Charging" then
        icon = ""
        color = "#00ff00"
    elseif capacity >= 80 then
        icon = ""
        color = "#00ff00"
    elseif capacity >= 60 then
        icon = ""
        color = "#ffff00"
    elseif capacity >= 40 then
        icon = ""
        color = "#ffa500"
    elseif capacity >= 20 then
        icon = ""
        color = "#ff4500"
    else
        icon = ""
        color = "#ff0000"
    end
    return icon, color
end

--* Create battery icon widget
local battery_icon_widget = wibox.widget {
    widget = wibox.widget.textbox,
    font = "Roboto Medium 20"
}

--* Create battery capacity widget
local battery_capacity_widget = wibox.widget {
    widget = wibox.widget.textbox,
    font = "Roboto Medium 10"
}

--* Function to update battery icon widget
local function update_battery_icon_widget()
    local status = get_battery_status()
    local capacity = get_battery_percentage()
    local battery_icon = get_battery_icon(status, capacity)
    battery_icon_widget.markup = '<span color = "' ..color.. '" >' .. battery_icon .. '</span>'
end

--* Function to update battery capacity widget
local function update_battery_capacity_widget()
    local capacity = get_battery_percentage()
    battery_capacity_widget.markup = '<span>' .. capacity .. '%</span>'
end

--* Update battery widgets initially
update_battery_icon_widget()
update_battery_capacity_widget()

--* Update battery widgets on regular interval
awful.widget.watch("bash -c 'cat ${battery_path}/capacity ${battery_path}/status'", update_interval,
    function()
        update_battery_icon_widget()
        update_battery_capacity_widget()
    end
)

--* Combine battery icon and capacity widgets into one battery widget
local battery_widget = wibox.widget {
    layout = wibox.layout.fixed.horizontal,
    battery_icon_widget,
    battery_capacity_widget
}

return battery_widget