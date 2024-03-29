local awful = require("awful")
local gears = require("gears")

-- Table of layouts to cover with awful.layout.inc, order matters.
awful.layout.layouts = {
    awful.layout.suit.spiral.dwindle,
    awful.layout.suit.floating,
    awful.layout.suit.max.fullscreen,
}

-- Rounded corners
--[[client.connect_signal("manage", function (c, startup)
    if not c.fullscreen and not c.maximized then
        c.shape = function(cr, width, height)
            gears.shape.rounded_rect(cr, width, height, beautiful.border_radius)
        end
    end
end)
-- Fullscreen clients should not have rounded corners
local function no_rounded_corners(c)
    if c.fullscreen or c.maximized then
        c.shape = function(cr, width, height)
            gears.shape.rectangle(cr, width, height)
        end
    else
        c.shape = function(cr, width, height)
            gears.shape.rounded_rect(cr, width, height, beautiful.border_radius)
        end
    end
end
client.connect_signal("property::fullscreen", no_rounded_corners)
client.connect_signal("property::maximized", function(c) 
    no_rounded_corners(c)    
end)
]]--