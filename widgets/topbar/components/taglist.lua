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


local markup = function(tag) return "<span foreground='#aaaaff'>  "..tag.name.."  </span>" end
local markup_hover = function(tag) return "<span foreground='#ff0000'>  "..tag.name.."  </span>" end

local update_tag = function(item, tag, index)
    item.visible = #tag:clients() > 0 or tag.selected

    local textbox = item:get_children_by_id('text_tag')[1]

    if tag.selected then
        textbox.markup = markup_hover(tag)
    else
        textbox.markup = markup(tag)
    end
end

return function(s)
    return awful.widget.taglist {
      screen = s,
      filter = awful.widget.taglist.filter.all,
      buttons = taglist_buttons,
      widget_template = {
        {
            nil,
            { 
                font = "Roboto Medium 10",
                id = "text_tag",
                widget = wibox.widget.textbox,
            },
            
            layout = wibox.layout.align.vertical
        },
        id     = 'background_role',
        widget = wibox.container.background,
        create_callback = function(item, tag, index, _)
            update_tag(item, tag, index)

            local old_cursor, old_wibox
            item:connect_signal("mouse::enter", function() 
                -- change cursor
                local wb = mouse.current_wibox
                old_cursor, old_wibox = wb.cursor, wb
                wb.cursor = "hand2" 
            end)
            item:connect_signal("mouse::leave", function() 
                -- reset cursor
                if old_wibox then
                    old_wibox.cursor = old_cursor
                    old_wibox = nil
                end
            end)
        end,
        update_callback = update_tag
      },

    }

end
