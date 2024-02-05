local wibox = require("wibox")

local clock = wibox.widget {
    widget = wibox.widget.textclock,
    format = '%d-%a   %I:%M',
    font = 'Roboto Bold 10'
}

return clock