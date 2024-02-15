local cmd = vim.api.nvim_command
local opt = vim.opt
local g = vim.g

g.t_co = 256
g.background = "dark"

cmd('colorscheme base16-tokyo-night-dark')

opt.syntax = "ON"                -- str:  Allow syntax highlighting
opt.termguicolors = true         -- bool: If term supports ui color then enable
