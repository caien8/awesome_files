local awful = require('awful')
local hotkeys_popup = require('awful.hotkeys_popup')
require('awful.hotkeys_popup.keys')

local apps = require('config.apps')
local mod = require('bindings.mod')

terminal = "kitty"

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
        on_press = function() awful.spawn(terminal) end,
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
        on_press = function() awful.util.spawn('dmenu_run') end,
    },
    awful.key{  --* BRAVE
        modifiers = {mod.super},
        key = 'w',
        description = 'run brave',
        group = 'Apps',
        on_press = function() awful.util.spawn('brave') end,
    },
    awful.key{  --* THUNAR
        modifiers = {mod.super},
        key = 'f',
        description = 'run Thunar',
        group = 'Apps',
        on_press = function() awful.util.spawn('thunar') end,
    },
    awful.key{  --* CODIUM
        modifiers = {mod.super},
        key = 'e',
        description = 'run codium',
        group = 'Apps',
        on_press = function() awful.util.spawn('codium') end,
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
        modifiers = {mod.super},
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
    awful.key {  --* MUTE VOLUME
        modifiers = {},
        key = "XF86AudioMute",
        description = "mute", 
        group = "Media",
        on_press = function ()
            awful.spawn.easy_async_with_shell("pamixer -t", function(stdout)
                awesome.emit_signal("popup::volume")
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
    --[[ 
    awful.key{
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
    },
    ]]
   awful.key{
      modifiers = {mod.super},
      key = 'Tab',
      description = 'go back',
      group = 'client',
      on_press = function()
         awful.client.focus.history.previous()
         if client.focus then
            client.focus:raise()
         end
      end,
   },
   awful.key{
      modifiers = {mod.super, mod.ctrl},
      key = 'j',
      description = 'focus the next screen',
      group = 'screen',
      on_press = function() awful.screen.focus_relative(1) end,
   },
   awful.key{
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