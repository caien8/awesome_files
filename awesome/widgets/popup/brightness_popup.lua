-- Import the necessary libraries
local wibox = require("wibox")
local gears = require("gears")
local awful = require("awful")
local beautiful = require("beautiful")

-- Define the border radius for the rounded rectangle
local border_radius = 5
local bar_height = 10 -- Set the desired height of the progress bar here

-- Create the floating wibox for the progress bar
local floating_brightness_bar = wibox {
    visible = false,
    ontop = true,
    type = "dock",
  height = 50, -- Set the height of the container
  width = 200,
    bg = beautiful.bg_normal,
  shape = function(cr, width, height)
    gears.shape.rounded_rect(cr, width, height, border_radius)
            end
}

-- Position the floating wibox at the center of the screen
awful.placement.centered(floating_brightness_bar)

-- Create the progress bar widget with adjustable height
local brightness_bar = wibox.widget {
  {
    {
        max_value = 100,
        value = 0,
        forced_height = bar_height, -- Force the height of the progress bar
        shape = gears.shape.rounded_rect,
        bar_shape = gears.shape.rounded_rect,
        color = '#ffcc00',
        background_color = '#000000',
        border_width = 1,
      border_color = '#ffffff',
      widget = wibox.widget.progressbar,
  },
    top = (floating_brightness_bar.height - bar_height) / 2, -- Calculate top margin
    bottom = (floating_brightness_bar.height - bar_height) / 2, -- Calculate bottom margin
    widget = wibox.container.margin
  },
  left = 5, -- Add left margin
  right = 5, -- Add right margin
  widget = wibox.container.margin
}

-- Create a text widget to display the brightness percentage
local brightness_text = wibox.widget {
    text = "0%",
    align = "center",
    valign = "center",
    widget = wibox.widget.textbox
}

-- Create an image widget to display the brightness icon
local brightness_icon = wibox.widget {
    text = "🌣", -- Set the desired text here
    align = "center",
    valign = "center",
    font = "Roboto Medium 14",
    widget = wibox.widget.textbox
}

-- Set the progress bar and additional widgets as the children of the floating wibox
floating_brightness_bar:setup {
    {
        brightness_icon,
        brightness_text,
        brightness_bar,
        layout = wibox.layout.fixed.horizontal
    },
    layout = wibox.layout.align.horizontal
}

-- Function to update the progress bar with the current brightness
local function update_brightness_bar()
    -- Get the current and max brightness values using brightnessctl
    awful.spawn.easy_async_with_shell("brightnessctl g", function(stdout)
        local current_brightness = tonumber(stdout)
        awful.spawn.easy_async_with_shell("brightnessctl m", function(max_stdout)
            local max_brightness = tonumber(max_stdout)
            if current_brightness and max_brightness then
                -- Calculate the brightness percentage
                local brightness_percentage = (current_brightness / max_brightness) * 100
                -- Update the progress bar value
                brightness_bar.children[1].children[1]:set_value(brightness_percentage) -- Access the progress bar through the margin containers
                -- Update the brightness text
                brightness_text:set_text(math.floor(brightness_percentage) .. "%")
                -- Show the floating wibox for a short duration
                floating_brightness_bar.visible = true
                gears.timer.start_new(3, function() -- Hide after 3 seconds
                    floating_brightness_bar.visible = false
end)
            end
        end)
    end)
end

-- Connect to the signal emitted when the brightness key is pressed
awesome.connect_signal("popup::brightness", function()
    update_brightness_bar()
end)