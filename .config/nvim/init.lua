-- Keybindings
require('mapx').setup{ global = true }

require('plugins')
-- require('lsp')
require('treesitter')

nnoremap("H", "gT") -- Tab right
nnoremap("L", "gt") -- Tab left

-- Disable backup to prevent messing with servers
vim.o.backup = false
vim.o.writebackup = false

-- Display \t as two spaces
vim.o.tabstop = 2
vim.o.softtabstop = -1
vim.o.shiftwidth = 0
-- Use tabs for indentation
vim.o.expandtab = false


-- 0.3s update time is fine with M1 Max :)
vim.o.updatetime = 300

-- Set colorscheme
vim.o.termguicolors = true
vim.cmd("colorscheme gruvbox")

-- Left bar
vim.o.signcolumn = "yes"
vim.o.number = true

-- Use 80 character line wrap in markdown
vim.cmd("au BufRead,BufNewFile *.md setlocal textwidth=80")

-- Diagnostic on hover
vim.cmd [[autocmd! CursorHold,CursorHoldI * lua vim.diagnostic.open_float(nil, {focus=false, scope="cursor"})]]

