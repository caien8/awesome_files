local awful = require('awful')
local hotkeys_popup = require('awful.hotkeys_popup')
require('awful.hotkeys_popup.keys')

local apps = require('config.apps')
local mod = require('bindings.mod')

--* general keys
awful.keyboard.append_global_keybindings{
    awful.key{  --* SHORTCUTS
        modifiers = {mod.super},
        key = 's',
        description = 'show help',
        group = 'Awesome',
        on_press = hotkeys_popup.show_help,
    },
    awful.key{  --* TERMINAL
        modifiers = {mod.super},
        key = 'Return',
        description = 'launch terminal',
        group = 'Awesome',
        on_press = function() awful.spawn(apps.terminal) end,
        --[[
        on_press = function () awful.spawn(user.floating_terminal, {
            floating = true, 
            callback = function (c)
               -- centered if it is the only client on the focused screen 
               if #awful.screen.focused().clients < 2 then 
                  awful.placement.centered(c)
               end 
            end
         }) end
         ]]
    },
    awful.key{  --* DMNEU
        modifiers = {mod.super},
        key = 'd',
        description = 'run dmenu',
        group = 'Launcher',
        on_press = function() awful.util.spawn('dmenu_run -c -l 10') end,
    },
    awful.key{  --* BRAVE
        modifiers = {mod.super},
        key = 'w',
        description = 'run brave',
        group = 'Apps',
        on_press = function() awful.util.spawn(apps.browser) end,
    },
    awful.key{  --* THUNAR
        modifiers = {mod.super},
        key = 'f',
        description = 'run Thunar',
        group = 'Apps',
        on_press = function() awful.util.spawn(apps.file_explorer) end,
    },
    awful.key{  --* CODIUM
        modifiers = {mod.super},
        key = 'v',
        description = 'run codium',
        group = 'Apps',
        on_press = function() awful.util.spawn(apps.editor) end,
    }, 
    awful.key{  --* RELOAD AWESOME
        modifiers = {mod.super, mod.ctrl},
        key = 'r',
        description = 'reload awesome',
        group = 'Awesome',
        on_press = awesome.restart,
     },
     awful.key{  --* QUIT AWESOME
        modifiers = {mod.super, mod.shift},
        key = 'q',
        description = 'quit awesome',
        group = 'Awesome',
        on_press = awesome.quit,
     },
    awful.key{  --* MAIN MENU
        modifiers = {mod.super, mod.ctrl},
        key = 'w',
        description = 'show main menu',
        group = 'Awesome',
        on_press = function() widgets.mainmenu:show() end,
    },
    awful.key{  --* LUA PROMPT
        modifiers = {mod.super},
        key = 'x',
        description = 'lua execute prompt',
        group = 'Awesome',
        on_press = function()
           awful.prompt.run{
              prompt = 'Run Lua code: ',
              textbox = awful.screen.focused().promptbox.widget,
              exe_callback = awful.util.eval,
              history_path = awful.util.get_cache_dir() .. '/history_eval'
           }
        end,
    }, 
    awful.key{  --* LAUNCHER
        modifiers = {mod.super},
        key = 'r',
        description = 'run launcher',
        group = 'Launcher',
        --on_press = function() awful.spawn(apps.launcher, false) end,
        on_press = function() awesome.emit_signal("prompt::run") end,
    },
    awful.key {  --* LOWER VOLUME
        modifiers = {},
        key = "XF86AudioLowerVolume",
        description = "lower volume", 
        group = "Media",
        on_press = function ()
            awful.spawn.easy_async_with_shell("pactl set-sink-volume 0 -3%", function(stdout)
                awesome.emit_signal("popup::volume", {amount = -3})
            end)
        end
    },  
    --[[
    awful.key {  --* RAISE VOLUME
        modifiers = {},
        key = "XF86AudioRaiseVolume",
        description = "raise volume", 
        group = "Media",
        on_press = function ()
            awful.spawn.easy_async_with_shell("pactl set-sink-volume 0 +3%", function(stdout)
                awesome.emit_signal("popup::volume", {amount = 3})
            end)
        end
    },
    ]]
    awful.key {  --* RAISE VOLUME
         modifiers = {},
         key = "XF86AudioRaiseVolume",
         description = "raise volume", 
         group = "Media",
         on_press = function ()
             -- Get the current volume level
             awful.spawn.easy_async_with_shell("pactl get-sink-volume @DEFAULT_SINK@", function(stdout)
                 local current_volume = tonumber(string.match(stdout, "(%d+)%%")) -- Extract the volume percentage
                 if current_volume and current_volume < 100 then -- Check if volume is below 100%
                     local increase_amount = 3 -- Define the increase amount
                     local new_volume = math.min(current_volume + increase_amount, 100) -- Calculate the new volume, not exceeding 100%
                     -- Set the new volume
                     awful.spawn.easy_async_with_shell("pactl set-sink-volume @DEFAULT_SINK@ " .. new_volume .. "%", function()
                         awesome.emit_signal("popup::volume", {amount = new_volume - current_volume})
                     end)
                 end
             end)
         end
   },
    awful.key {  --* MUTE VOLUME
        modifiers = {},
        key = "XF86AudioMute",
        description = "mute", 
        group = "Media",
        on_press = function ()
            awful.spawn.easy_async_with_shell("pactl set-sink-mute 0 toggle", function(stdout)
              awesome.emit_signal("popup::mute")
            end)
         end   
        --[[
        on_press = function ()
            awful.spawn.easy_async_with_shell("pamixer -t", function(stdout)
                awesome.emit_signal("popup::volume")
            end)
        end
        ]]
    },
    awful.key {  --* MUTE/UNMUTE MICROPHONE
        modifiers = {mod.super},
        key = "XF86AudioMute",
        description = "mute/unmute microphone", 
        group = "Media",
        on_press = function ()
            -- Toggle microphone mute state using pactl
            awful.spawn.easy_async_with_shell("pactl set-source-mute @DEFAULT_SOURCE@ toggle", function()
                -- Emit signal to update microphone widget
                awesome.emit_signal("popup::microphone")
            end)
        end
    },
    awful.key {  --* LOWER BRIGHTNESS
         modifiers = {},
         key = "XF86MonBrightnessDown",
         description = "lower brightness", 
         group = "Media",
         on_press = function ()

            awful.spawn.easy_async_with_shell("brightnessctl info", function(stdout)
               local value = tonumber(string.match(string.match(stdout, "%d+%%"), "%d+"))

               local decrease = 3

               if value == 3 then
                  decrease = 2
               elseif value == 2 then
                  decrease = 1
               elseif value < 2 then
                  decrease = 0
               end

               awful.spawn.easy_async_with_shell("brightnessctl set "..decrease.."%- > /dev/null", function(stdout)
                  awesome.emit_signal("popup::brightness", {amount = -decrease})
               end)
            end)
        end
    },
    awful.key {  --* RAISE BRIGHTNESS
        modifiers = {},
        key = "XF86MonBrightnessUp",
        description = "raise brightness", 
        group = "Media",
        on_press = function ()
            awful.spawn.easy_async_with_shell("brightnessctl set 3%+ > /dev/null", function(stdout)
                awesome.emit_signal("popup::brightness", {amount = 3})
            end)
        end
    }
}

--* tags related keybindings
awful.keyboard.append_global_keybindings{
    awful.key{
       modifiers = {mod.super},
       key = 'Left',
       description = 'view previous',
       group = 'tag',
       on_press = awful.tag.viewprev,
    },
    awful.key{
       modifiers = {mod.super},
       key = 'Right',
       description = 'view next',
       group = 'tag',
       on_press = awful.tag.viewnext,
    },
    awful.key{
       modifiers = {mod.super},
       key = 'Escape',
       description = 'go back',
       group = 'tag',
       on_press = awful.tag.history.restore,
    },
 }
 
 
--* focus related keybindings
awful.keyboard.append_global_keybindings{
--[[    awful.key{
        modifiers = {mod.alt},
        key = 'Tab',
        description = 'open app switcher forward',
        group = 'client',
        on_press = function() 
            apps.switcher.switch(1, "Mod1", "Alt_L", "Shift", "Tab") 
        end,
    },
    awful.key{
        modifiers = {mod.alt, mod.shift},
        key = 'Tab',
        description = 'open app switcher backwards',
        group = 'client',
        on_press = function() 
            apps.switcher.switch(-1, "Mod1", "Alt_L", "Shift", "Tab") 
        end,
    }, ]]
   awful.key{ --* SWITCH WINDOW FOCUS
      modifiers = {mod.super},
      key = 'space',
      description = 'go back',
      group = 'client',
      on_press = function()
         awful.client.focus.history.previous()
         if client.focus then
            client.focus:raise()
         end
      end,
   },
   awful.key{  --* SWITCH SCREEN FOCUS
      modifiers = {mod.super, mod.ctrl},
      key = 'j',
      description = 'focus the next screen',
      group = 'screen',
      on_press = function() awful.screen.focus_relative(1) end,
   },
   awful.key{   --* RESTORE MINIMIZED
      modifiers = {mod.super, mod.ctrl},
      key = 'n',
      description = 'restore minimized',
      group = 'client',
      on_press = function()
         local c = awful.client.restore()
         if c then
            c:active{raise = true, context = 'key.unminimize'}
         end
      end,
   },
}


--* layout related keys
awful.keyboard.append_global_keybindings{
    awful.key{  --* SWITCH LAYOUT
        modifiers = {mod.super},
        key = 'Tab',
        description = 'select next',
        group = 'layout',
        on_press = function() awful.layout.inc(1) end,
    },
    awful.key{
        modifiers = {mod.super, mod.shift},
        key = 'space',
        description = 'select previous',
        group = 'layout',
        on_press = function() awful.layout.inc(-1) end,
    }
}

--* workspace
awful.keyboard.append_global_keybindings{
    awful.key{
        modifiers = {mod.super},
        keygroup    = 'numrow',
        description = 'only view tag',
        group = 'tag',
        on_press = function(index)
           local screen = awful.screen.focused()
           local tag = screen.tags[index]
           if tag then
              tag:view_only(tag)
           end
        end
     },
    awful.key{
       modifiers = {mod.super, mod.ctrl},
       keygroup    = 'numrow',
       description = 'toggle tag',
       group = 'tag',
       on_press = function(index)
          local screen = awful.screen.focused()
          local tag = screen.tags[index]
          if tag then
             tag:viewtoggle(tag)
          end
       end
    },
    awful.key{
       modifiers = {mod.super, mod.shift},
       keygroup    = 'numrow',
       description = 'move focused client to tag',
       group = 'tag',
       on_press = function(index)
          if client.focus then
             local tag = client.focus.screen.tags[index]
             if tag then
                client.focus:move_to_tag(tag)
             end
          end
       end
    },
    awful.key {
       modifiers = {mod.super, mod.ctrl, mod.shift},
       keygroup    = 'numrow',
       description = 'toggle focused client on tag',
       group = 'tag',
       on_press = function(index)
          if client.focus then
             local tag = client.focus.screen.tags[index]
             if tag then
                client.focus:toggle_tag(tag)
             end
          end
       end,
    },
    awful.key{
       modifiers = {mod.super},
       keygroup    = 'numpad',
       description = 'select layout directrly',
       group = 'layout',
       on_press = function(index)
          local tag = awful.screen.focused().selected_tag
          if tag then
             tag.layout = tag.layouts[index] or tag.layout
          end
       end
    },
}
