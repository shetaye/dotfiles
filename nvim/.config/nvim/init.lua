vim.g.mapleader=" "
vim.g.maplocalleader = "\\"
require('config.lazy')

vim.o.showcmd = true

vim.g.ctrlp_working_path_mode="r"
vim.g.ctrlp_custom_ignore="node_modules"
vim.o.hidden = true

-- Disable backup to prevent messing with servers
vim.o.backup = false
vim.o.writebackup = false

-- Display \t as two spaces
vim.o.tabstop = 2
vim.o.softtabstop = -1
vim.o.shiftwidth = 0
-- Use tabs for indentation
vim.o.expandtab = true

vim.o.updatetime = 300

-- Set colorscheme
vim.o.termguicolors = true

-- Left bar
vim.o.signcolumn = "no"
vim.o.number = true

-- Use 80 character line wrap in markdown & text
vim.cmd("au BufRead,BufNewFile *.md setlocal textwidth=80")
vim.cmd("au BufRead,BufNewFile *.txt setlocal textwidth=80")

-- Use far for formatprg
if vim.fn.executable('far') == 1 then
    vim.o.formatprg = "far"
end

-- Diagnostic on hover
vim.cmd [[autocmd! CursorHold,CursorHoldI * lua vim.diagnostic.open_float(nil, {focus=false, scope="cursor"})]]

-- Clipboard
--vim.cmd("set clipboard+=unnamedplus")

require('config.lsp')
require('config.treesitter')

-- Keybindings
require('mapx').setup{ global = true }
nnoremap("L", ":bnext<CR>") -- Next Buffer
nnoremap("H", ":bprevious<CR>") -- Previous Buffer
nnoremap("<leader>bq", ":bp <BAR> bd #<CR>") -- Close buffer & move to previous
nnoremap("<leader>p", ":CtrlP<CR>") -- CtrlP

require("bufferline").setup{}
