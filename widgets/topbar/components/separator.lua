local wibox = require("wibox")

-- Create a separator widget
local separator = wibox.widget {
    orientation = "vertical", -- or "horizontal"
    forced_width = 10,        -- or forced_height for horizontal
    thickness = 1,            -- thickness of the line
    color = "#0000000",        -- color of the separator
    widget = wibox.widget.separator
}

return separator