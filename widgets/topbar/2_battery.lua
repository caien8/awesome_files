local awful = require("awful")
local wibox = require("wibox")

--* Initialize widget
local level_widget = {
    markup = "0%",
    widget = wibox.widget.textbox,
    font = "Roboto Medium 10"
}

local battery_widget = wibox.widget {
    level_widget,
    layout = wibox.layout.fixed.horizontal
}

--* Define path to battery and icon files
local battery_path = "/sys/class/power_supply/BATT"
local icon_path = "/home/caien/.config/awesome/themes/icons/battery_alert.png"

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

--* Function to update battery widget
local function update_battery_widget()
    local percentage = get_battery_percentage()
    local status = get_battery_status()

    local icon
    if status:match("Charging") then
        --icon = icon_path.. "/battery_charging.png"
        icon = ""
    elseif percentage > 80 then
        --icon = icon_path.. "/battery_full.png"
        icon = ""
    elseif percentage > 60 then
        --icon = icon_path.. "/battery_high.png"
        icon = ""
    elseif percentage > 40 then
        --icon = icon_path.. "/battery_medium.png"
        icon = ""
    elseif percentage > 20 then
        --icon = icon_path.. "/battery_low.png"
        icon = ""
    else
        --icon = icon_path.. "/battery_empty.png"
        icon = ""
    end

    --* Update battery widget
    awesome.emit_signal("battery::update", percentage, icon)
end

--* Connect battery widget update signal
awesome.connect_signal("battery::update", function(percentage, icon)
    level_widget.markup = percentage .. "%"
    battery_widget.icon:set_image(icon)
end)

--* Inital update
update_battery_widget()

return battery_widget