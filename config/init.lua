local awful = require("awful")

require("config.layout")
require("config.tags")

awful.spawn.with_shell("~/.config/awesome/config/autorun.sh")
