local wibox = require("wibox")
local awful = require("awful")

local clock = wibox.widget {
    widget = wibox.widget.textclock,
    format = '%d-%a %I:%M',
    font = 'Roboto Bold 10'
}

-- Create the tooltip
local clock_tooltip = awful.tooltip({
    objects = { clock },
    fg = "#ffffff",
    bg = "#0000000",
    mode = "outside",
    font = "Roboto Medium 10",
    timer_function = function()
        -- Return the full date string for the tooltip
        return os.date("%A, %B-%d/%Y [%H:%M:%S]")
    end,
    delay_show = 0 -- Time in seconds before showing the tooltip
})

return clock