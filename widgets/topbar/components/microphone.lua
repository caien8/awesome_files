local gears = require("gears")
local awful = require("awful")
local wibox = require("wibox")

-- Create the microphone widget
local microphone_widget = wibox.widget {
    {
        id = "mic_icon",
        widget = wibox.widget.textbox,
        align = "center",
        font = "Roboto Medium 12",
    },
    layout = wibox.layout.fixed.horizontal,
}

-- Function to update the microphone widget
local function update_microphone_widget(widget, stdout)
    local mic_mute = string.match(stdout, "Mute: (%S+)") -- Extract mute state (yes/no)

    -- Update the mic icon based on mute state
    local mic_icon = ""
    if mic_mute == "yes" then
        mic_icon = ""  -- FontAwesome icon for muted microphone
    else
        mic_icon = ""  -- FontAwesome icon for unmuted microphone
    end

    widget.mic_icon.text = mic_icon
end

-- Function to check the microphone status
local function check_microphone_status()
    awful.spawn.easy_async_with_shell("pactl get-source-mute @DEFAULT_SOURCE@", function(stdout)
        update_microphone_widget(microphone_widget, stdout)
    end)
end

-- Connect signals to update the microphone widget
awesome.connect_signal("popup::microphone", check_microphone_status)

-- Click event to launch pavucontrol
microphone_widget:buttons(gears.table.join(
    awful.button({}, 1, function()
        awful.spawn("pavucontrol --tab=4")
    end)
))

-- Set up a timer to periodically check the microphone status
local microphone_check_timer = gears.timer {
    timeout   = 1, -- Check every seconds
    call_now  = true, -- Run immediately on startup
    autostart = true, -- Start the timer when AwesomeWM starts
    callback  = check_microphone_status -- Function to call
}

return microphone_widget