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
    if (string.match(status,"Charging")) and (capacity > 90) then
        icon = "󰂄"
        color = "#00ff00"
    elseif (string.match(status, "Charging")) and (capacity <= 90) then
        icon = "󰂄"
        color = "#ffffff"
    elseif (string.match(status, "Discharging")) and (capacity <= 15) then
        icon = "󰂅"
        color = "#ff0000"
    elseif (string.match(status, "Discharging")) and (capacity <= 20) then  -- 0 - 20
        icon = "󰁻"
        color = "#ff4500"
    elseif (string.match(status, "Discharging")) and (capacity <= 30) then  -- 21 - 30
        icon = "󰁼"
        color = "#ff7f00"
    elseif (string.match(status, "Discharging")) and (capacity <= 40) then  -- 31 - 40
        icon = "󰁽"
        color = "#ffbf00"
    elseif (string.match(status, "Discharging")) and (capacity <= 50) then  -- 41 - 50
        icon = "󰁾"
        color = "#ffffff"
    elseif (string.match(status, "Discharging")) and (capacity <= 60) then  -- 51 - 60
        icon = "󰁿"
        color = "#ffffff"
    elseif (string.match(status, "Discharging")) and (capacity <= 70) then  -- 61 - 70
        icon = "󰂀"
        color = "#ffffff"
    elseif (string.match(status, "Discharging")) and (capacity <= 80) then  -- 71 - 80
        icon = "󰂁"
        color = "#ffffff"
    elseif (string.match(status, "Discharging")) and (capacity <= 90) then  -- 81 - 90
        icon = "󰂂"
        color = "#ffffff"
    elseif (string.match(status, "Discharging")) and (capacity < 100) then  -- 91 - 99
        icon = "󰁹"
        color = "#00ff00"
    else                                                         -- 100
        icon = "󰁹"
        color = "#00ff00"
    end
    return icon, color
end

--* Create battery icon widget
local battery_icon_widget = wibox.widget {
    widget = wibox.widget.textbox,
    font = "Roboto Medium 12"
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
    battery_capacity_widget.markup = '<span>' .. capacity .. '%</span>  '
end

--* Function to get the battery duration (remaining time)
local function get_battery_duration()
    local handle = io.popen("acpi -b")
    if handle then
        local result = handle:read("*a")
        handle:close()
        
        -- Extract the remaining time from the acpi output
        local time_remaining = result:match("([%d]+:[%d]+:[%d]+)")
        if time_remaining then
            return time_remaining
        end
    end
    return "N/A"
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

--* Create a tooltip for the battery_widget
local battery_tooltip = awful.tooltip({
    objects = { battery_widget },
    fg = "#ffffff",
    bg = "#0000000",
    opacity = 0.5,
    font = "Roboto Medium 10",
    timer_function = function()
        -- Call the function that gets the battery duration
        local duration = get_battery_duration()
        local status = get_battery_status()
        if string.match(status, "Charging") then
            return "Charging duration: " .. duration
        end
        return "Battery duration: " .. duration
    end,
})


return battery_widget