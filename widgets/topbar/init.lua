local gears = require("gears")
local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")

local clock    = require("widgets.topbar.components.clock")
local tag_list = require("widgets.topbar.components.taglist")
local battery  = require("widgets.topbar.components.battery")
local sep = require("widgets.topbar.components.separator")

awful.screen.connect_for_each_screen(function(s)
    --* Create the topbar
    s.topbar = awful.wibar{ position = "top", 
                            screen = s,
                            height = 30,
                            bg = "#0000000",
                            }
    --* Adding widgets                            
    s.topbar:setup {
        layout = wibox.layout.align.horizontal,
        {   --* LEFT WIDGETS
            layout = wibox.layout.fixed.horizontal,
            tag_list(s)
        },
        {   --* MIDDLE WIDGETS
            layout = wibox.layout.fixed.horizontal,
        },
        {
            layout = wibox.layout.fixed.horizontal,
            battery,
            clock
        }
    }
end)