-- Load necessary libraries
local wibox = require("wibox")
local awful = require("awful")
local gears = require("gears")
local beautiful = require("themes.theme")

local icon_color = beautiful.fg_focus
local percentage_color = beautiful.fg_focus

-- Create the volume widget
local volume_widget = wibox.widget {
    {
        id = "icon",
        widget = wibox.widget.textbox,
        align = "center",
        font = beautiful.font .. "14",
    },
    {
        id = "text",
        widget = wibox.widget.textbox,
        align = "center",
        font = beautiful.font .. "10",
    },
    layout = wibox.layout.fixed.horizontal,
}

-- Function to update the volume widget
local function update_volume_widget(widget)
    -- Use pactl to get the current volume and mute status
    awful.spawn.easy_async_with_shell("pactl get-sink-volume @DEFAULT_SINK@ && pactl get-sink-mute @DEFAULT_SINK@", function(stdout, stderr, exitreason, exitcode)
        if exitcode == 0 then
            local volume = tonumber(string.match(stdout, "Volume:.- (%d+)%%")) -- Extract the volume percentage
            local mute = string.match(stdout, "Mute: (%a+)") -- Extract the mute status

            local icon = ""
            if mute == "yes" then
                icon = "󰝟"  -- Icon for muted
            elseif volume == 0 then
                icon = "󰕿"  -- Icon for no volume
            elseif volume <= 30 then
                icon = "󰖀"  -- Icon for low volume
            elseif volume <= 70 then
                icon = "󰕾"  -- Icon for medium volume
            else
                icon = "󰕾"  -- Icon for high volume
            end
            
            widget.icon.markup = '<span color = "' ..icon_color.. '">' .. icon .. '</span>'
            widget.text.markup = '<span color = "' ..percentage_color.. '"> ' .. volume .. '%</span>'
        else
            widget.icon.text = "󰕿"  -- Default icon when volume is not available
            widget.text.text = " N/A"
        end
    end)
end

-- Timer to periodically update the volume widget
local volume_timer = gears.timer {
    timeout   = 1, -- Update every seconds
    call_now  = true, -- Call the callback function immediately
    autostart = true,
    callback  = function()
update_volume_widget(volume_widget)
    end
}
-- Connect signals to update the volume widget
awesome.connect_signal("popup::volume", function(args)
    update_volume_widget(volume_widget)
end)

awesome.connect_signal("popup::mute", function()
    update_volume_widget(volume_widget)
end)

-- Click event to launch pavucontrol
volume_widget:buttons(gears.table.join(
    awful.button({}, 1, function()
        awful.spawn("pavucontrol")
    end)
))

-- Initial update of the volume widget
update_volume_widget(volume_widget)
-- Return the volume widget
return volume_widget
