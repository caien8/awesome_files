-- Import necessary libraries
local wibox = require("wibox")
local awful = require("awful")
local gears = require("gears")
local beautiful = require("themes.theme")
local interface = "wlan0"
local interval = 1

-- Create a network speed widget
local network_speed_widget = wibox.widget {
        -- Network icon
    {
        id = "icon",
        text = "󰤨", -- Default icon for disconnected state
        font = "Roboto Medium 13", -- Adjust the font size as needed
        widget = wibox.widget.textbox,
    },
    layout = wibox.layout.fixed.horizontal,
    -- Add a mouse click event to launch networkmanager_dmenu
    buttons = gears.table.join(
        awful.button({}, 1, function() -- 1 represents the left mouse button
     awful.spawn("networkmanager_dmenu")
        end)
    )
}

-- Create a tooltip for the network speed widget
local network_tooltip = awful.tooltip {
    objects = { network_speed_widget },
    fg = beautiful.fg,
    bg = beautiful.transparent,
    font = beautiful.font .. "10"

}

-- Function to update network speeds and icon
local function update_network_speed()
 -- Check network connection status using nmcli
 awful.spawn.easy_async_with_shell(
 "nmcli -t -f ACTIVE,DEVICE dev wifi | grep '^yes:" .. interface .. "'",
   function(stdout)
     local is_connected = stdout ~= ""
     if not is_connected then
      -- Disconnected state
      disconnect_icon = "󰤭"
      disconnected_color = beautiful.fg_urgent
      network_speed_widget:get_children_by_id("icon")[1].markup = '<span color = "' ..disconnected_color.. '" >' .. disconnect_icon .. '</span>' -- Use a different icon for disconnected state
      network_tooltip.text = "Disconnected"
     else
      -- Connected state, get signal strength using nmcli
      awful.spawn.easy_async_with_shell(
       "nmcli -t -f IN-USE,SIGNAL dev wifi | grep '^*' | cut -d ':' -f 2",
       function(stdout)
        local signal_strength = tonumber(stdout)
        local color = beautiful.fg_focus
        if signal_strength > 80 then  -- Strong signal
         network_speed_widget:get_children_by_id("icon")[1].markup = '<span color = "' ..color.. '" >' .."󰤨".. '</span>' 
        elseif signal_strength > 70 then  -- Medium signal
         network_speed_widget:get_children_by_id("icon")[1].markup = '<span color = "' ..color.. '" >' .."󰤥".. '</span>' 
        elseif signal_strength > 50 then
          network_speed_widget:get_children_by_id("icon")[1].markup = '<span color = "' ..color.. '" >' .."󰤢".. '</span>'
        elseif signal_strength > 30 then
          network_speed_widget:get_children_by_id("icon")[1].markup = '<span color = "' ..color.. '" >' .."󰤟".. '</span>'
        else
         -- Weak signal
         network_speed_widget:get_children_by_id("icon")[1].markup = '<span color = "' ..color.. '" >' .."󰤯".. '</span>'
        end
      end
     )
     
     -- Get network statistics
     awful.spawn.easy_async_with_shell(
      "ip -s link show " .. interface .. " | awk '/RX:/{getline; print $1} /TX:/{getline; print $1}'",
      function(stdout)
       -- Parse the output to get received (download) and transmitted (upload) bytes
       local rx_bytes, tx_bytes = stdout:match("(%d+)%s+(%d+)")
       -- Convert bytes to megabytes (you can adjust the conversion factor as needed)
       local rx_mbytes = tonumber(rx_bytes) / (1024 * 1024)
       local tx_mbytes = tonumber(tx_bytes) / (1024 * 1024)
       -- Format the speeds to two decimal places
       local download_speed = string.format("%.2f MB", rx_mbytes)
       local upload_speed = string.format("%.2f MB", tx_mbytes)
       -- Instead of updating the widget text, update the tooltip text
       network_tooltip.text = " ↑" .. upload_speed .. " ↓" .. download_speed
      end
     )
    end
   end
  )
end

-- Set up a timer to update the network speeds and icon every interval
local network_timer = gears.timer {
 timeout = interval,
 autostart = true,
 callback = update_network_speed,
}

-- Add the network speed widget to your wibox or screen
-- Example: mywibox.widget:add(network_speed_widget)

return network_speed_widget