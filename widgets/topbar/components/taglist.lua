local gears = require("gears")
local awful = require("awful")
local wibox = require("wibox")

local taglist_buttons = gears.table.join(
                    awful.button({}, 1, function(t) 
                        t:view_only() 
                    end),
                    awful.button({}, 3, awful.tag.viewtoggle),
                    awful.button({ }, 4, function(t) 
                        awful.tag.viewnext(t.screen) 
                    end),
                    awful.button({ }, 5, function(t) 
                        awful.tag.viewprev(t.screen) 
                    end)
                )


return function(s)
    return awful.widget.taglist {
      screen = s,
      filter = awful.widget.taglist.filter.all,
      buttons = taglist_buttons
    }

end