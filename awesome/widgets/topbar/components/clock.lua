local wibox = require("wibox")
local awful = require("awful")
local beautiful = require("themes.theme")

local clock = wibox.widget {
    widget = wibox.widget.textclock,
    format = '<span foreground="' .. beautiful.fg_focus .. '">%d-%a %I:%M</span>',
    font = beautiful.font .. "10",
}

-- Create the tooltip
local clock_tooltip = awful.tooltip({
    objects = { clock },
    fg = beautiful.fg,
    bg = beautiful.transparent,
    mode = "outside",
    font = beautiful.font .. "10",
    timer_function = function()
        -- Return the full date string for the tooltip
        return os.date("%A, %B-%d/%Y [%H:%M:%S]")
    end,
    delay_show = 0 -- Time in seconds before showing the tooltip
})

return clock