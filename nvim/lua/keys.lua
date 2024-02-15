--[[ keys.lua ]]
local g = vim.g

g.mapleader = " "
g.localleader = " "

local function map(m, k, v)
    vim.keymap.set(m, k, v, { silent = true })
end

-- Quit neovim
map('n', '<C-Q>', '<CMD>q<CR>')

-- Quickly save the current buffer or all buffers
map('n', '<leader>w', '<CMD>update<CR>')
map('n', '<leader>W', '<CMD>wall<CR>')

-- Mimic shell movements
map('i', '<C-E>', '<C-o>$')
map('i', '<C-A>', '<C-o>^')

-- Fix * (Keep the cursor position, don't move to next match)
map('n', '*', '*N')

-- Fix n and N. Keeping cursor in center
map('n', 'n', 'nzz')
map('n', 'N', 'Nzz')

-- Shortcut to yank register
map({ 'n', 'x' }, '<leader>p', '"0p')

-- Move to the next/previous buffer
map('n', '<leader>[', '<CMD>bp<CR>')
map('n', '<leader>]', '<CMD>bn<CR>')

-- Move to last buffer
map('n', "''", '<CMD>b#<CR>')

-- leader-o/O inserts blank line below/above
map('n', '<leader>o', 'o<ESC>')
map('n', '<leader>O', 'O<ESC>')

-- Move line up and down in NORMAL and VISUAL modes
-- Reference: https://vim.fandom.com/wiki/Moving_lines_up_or_down
map('n', '<C-j>', '<CMD>move .+1<CR>')
map('n', '<C-k>', '<CMD>move .-2<CR>')
map('x', '<C-j>', ":move '>+1<CR>gv=gv")
map('x', '<C-k>', ":move '<-2<CR>gv=gv")

-- Use operator pending mode to visually select the whole buffer
-- e.g. dA = delete buffer ALL, yA = copy whole buffer ALL
map('o', 'A', ':<C-U>normal! mzggVG<CR>`z')
map('x', 'A', ':<C-U>normal! ggVG<CR>')


-- Copying the vscode behaviour of making tab splits
map('n', '<C-\\>', '<CMD>vsplit<CR>')
map('n', '<A-\\>', '<CMD>split<CR>')


-- Toggle nvim-tree
map('n', '<leader>n', '<CMD>NvimTreeToggle<CR>')

-- Toogle Indentlines
map('n', '<leader>l', '<CMD>IndentLinesToggle<CR>')

-- Toogle Tagbar
map('n', '<leader>tt', '<CMD>TagbarToggle<CR>')

-- Telescope
map('n', '<leader>f', '<CMD>Telescope find_files<CR>')

-- Floating Terminal
map('n', '<leader>t', '<CMD>FloatermNew<CR>')

