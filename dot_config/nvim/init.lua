-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- Leader & local leader
vim.g.mapleader = ","
vim.g.maplocalleader = " "

-- Undo files
vim.o.undofile 	= true

-- No status bar
vim.o.laststatus = 0

-- Indentation control
vim.o.expandtab         = true
vim.opt.shiftwidth      = 4
vim.o.autoindent        = true
vim.o.smartindent       = true
vim.o.softtabstop       = -1

-- System clipboard
vim.o.clipboard = "unnamedplus"

-- Left bar
vim.o.signcolumn = "no"
vim.o.number = true
vim.o.relativenumber = true

-- Colors
vim.cmd('syntax on')
vim.o.termguicolors = true

-- Intraline scrolling
vim.cmd("nnoremap <expr> j v:count ? 'j' : 'gj'")
vim.cmd("nnoremap <expr> k v:count ? 'k' : 'gk'")

-- Buffer nagivation
vim.keymap.set('n', "L", function()
    vim.cmd(":bnext")
end)
vim.keymap.set('n', "H", function()
    vim.cmd(":bprevious")
end)
vim.keymap.set('n', "<space>b", function()
	vim.cmd("buffers")
end)

-- credit: https://yobibyte.github.io/vim.html
vim.keymap.set("n", "<space>c", function()
  vim.ui.input({}, function(c) 
      if c and c~="" then 
        vim.cmd("noswapfile vnew") 
        vim.bo.buftype = "nofile"
        vim.bo.bufhidden = "wipe"
        vim.api.nvim_buf_set_lines(0, 0, -1, false, vim.fn.systemlist(c))
      end 
  end) 
end)

local function buffer_input(opts, on_confirm)
  opts = opts or {}
  local prompt = opts.prompt or "Input: "
  local default = opts.default or ""
  local completion = opts.completion
  
  local buf = vim.api.nvim_create_buf(false, true)
  
  -- Changed from 'prompt' to 'nofile' for multi-line support
  vim.api.nvim_buf_set_option(buf, 'buftype', 'nofile')
  vim.api.nvim_buf_set_option(buf, 'bufhidden', 'wipe')
  vim.api.nvim_buf_set_option(buf, 'swapfile', false)
  
  -- Set completion if provided
  if completion then
    vim.api.nvim_buf_set_option(buf, 'completefunc', 'v:lua.vim.fn.' .. completion)
  end
  
  local width = opts.width or 60
  local height = 10
  local row = math.floor((vim.o.lines - height) / 2)
  local col = math.floor((vim.o.columns - width) / 2)
  
  local win = vim.api.nvim_open_win(buf, true, {
    relative = 'editor',
    width = width,
    height = height,
    row = row,
    col = col,
    style = 'minimal',
    border = 'rounded',
    title = prompt,
    title_pos = 'left',
  })
  
  if default ~= "" then
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, { default })
    -- Move cursor to end
    vim.api.nvim_win_set_cursor(win, {1, #default})
  end
  
  local submitted = false
  
  local function submit()
    if submitted then return end
    submitted = true
    
    local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
    -- Changed to support multi-line: join all lines
    local input = table.concat(lines, '\n')
    
    if vim.api.nvim_win_is_valid(win) then
      vim.api.nvim_win_close(win, true)
    end
    
    if on_confirm then
      on_confirm(input)
    end
  end
  
  local function cancel()
    if submitted then return end
    submitted = true
    
    if vim.api.nvim_win_is_valid(win) then
      vim.api.nvim_win_close(win, true)
    end
    
    if on_confirm then
      on_confirm(nil)
    end
  end
  
  local keymap_opts = { noremap = true, silent = true, buffer = buf }
  
  -- Submit keybinds (your originals)
  vim.keymap.set('n', '<CR>', submit, keymap_opts)
  vim.keymap.set('i', '<C-CR>', submit, keymap_opts)
  
  -- Cancel keybinds (your originals)
  vim.keymap.set({'n', 'i'}, '<C-c>', cancel, keymap_opts)
  vim.keymap.set('n', '<Esc>', cancel, keymap_opts)
  
  -- Cleanup on buffer close
  vim.api.nvim_create_autocmd('BufLeave', {
    buffer = buf,
    once = true,
    callback = cancel,
  })
  
  vim.cmd('startinsert!')
end

require("lazy").setup({
  spec = {
    {
        'nvim-treesitter/nvim-treesitter',
        lazy = false,
        branch = 'main',
        build = ':TSUpdate'
    },
    {
        'neovim/nvim-lspconfig',
        lazy = false
    },
    { "nvim-tree/nvim-web-devicons", opts = {} },
    {
        'nvim-telescope/telescope.nvim', branch='master',
        dependencies = { 'nvim-lua/plenary.nvim' }
    },
    {
        "hyperb1iss/silkcircuit-nvim",
        lazy = false,
        priority = 1000,
        config = function()
            require("silkcircuit").setup({
                variant = "glow",
            })
            --vim.cmd.colorscheme("silkcircuit")
            -- OLED-friendly pure black background
            vim.api.nvim_set_hl(0, "Normal", { bg = "#000000" })
            vim.api.nvim_set_hl(0, "NormalFloat", { bg = "#000000" })
            vim.api.nvim_set_hl(0, "NormalNC", { bg = "#000000" })
            vim.api.nvim_set_hl(0, "SignColumn", { bg = "#000000" })
            vim.api.nvim_set_hl(0, "EndOfBuffer", { bg = "#000000" })
        end,
    },
    {
        "miikanissi/modus-themes.nvim",
        lazy = false,
        priority = 1000,
        config = function()
            local function read_theme_mode()
                local f = io.open(os.getenv("HOME") .. "/.config/theme-mode", "r")
                if f then
                    local mode = f:read("*l")
                    f:close()
                    return mode or "dark"
                end
                return "dark"
            end

            local mode = read_theme_mode()
            local style = mode == "light" and "light" or "dark"
            local colorscheme = mode == "light" and "modus_operandi" or "modus_vivendi"

            require("modus-themes").setup({
                style = style,
                variant = "tinted",
                italic_constructs = true,
                bold_constructs = true,
            })
            vim.cmd.colorscheme(colorscheme)
        end,
    },
    {
      "lervag/vimtex",
      lazy = false,     -- we don't want to lazy load VimTeX
      -- tag = "v2.15", -- uncomment to pin to a specific release
      init = function()
        -- VimTeX configuration goes here, e.g.
        vim.g.vimtex_view_method = "zathura"
      end
    },
    {
      "mozanunal/sllm.nvim",
      dependencies = {
        "echasnovski/mini.notify",
        "echasnovski/mini.pick",
      },
      config = function()
        require("sllm").setup({
          default_model = "openrouter/anthropic/claude-sonnet-4.5",
          input_func = buffer_input
        })
      end,
    },
    {
        'MeanderingProgrammer/render-markdown.nvim',
        dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-mini/mini.nvim' },            -- if you use the mini.nvim suite
        ---@module 'render-markdown'
        ---@type render.md.UserConfig
        opts = {
            enabled = true
        },
    },
    --{
    --    "Kurama622/llm.nvim",
    --    dependencies = { "nvim-lua/plenary.nvim", "MunifTanjim/nui.nvim"},
    --    cmd = { "LLMSessionToggle", "LLMSelectedTextHandler", "LLMAppHandler" },
    --    config = function()
    --        require("llm").setup({
    --            prompt = "You are a helpful AI assistant for a professional programmer.",
    --            url = "https://openrouter.ai/api/v1/chat/completions",
    --            model = "anthropic/claude-sonnet-4.5",
    --            api_type = "openai",
    --            keys = {
    --                -- The keyboard mapping for the input window.
    --                ["Input:Submit"]      = { mode = "n", key = "<cr>" },
    --                ["Input:Cancel"]      = { mode = {"n", "i"}, key = "<C-c>" },
    --                ["Input:Resend"]      = { mode = {"n", "i"}, key = "<C-r>" },

    --                -- only works when "save_session = true"
    --                ["Input:HistoryNext"] = { mode = {"n", "i"}, key = "<C-j>" },
    --                ["Input:HistoryPrev"] = { mode = {"n", "i"}, key = "<C-k>" },

    --                -- The keyboard mapping for the output window in "split" style.
    --                ["Output:Ask"]        = { mode = "n", key = "i" },
    --                ["Output:Cancel"]     = { mode = "n", key = "<C-c>" },
    --                ["Output:Resend"]     = { mode = "n", key = "<C-r>" },

    --                -- The keyboard mapping for the output and input windows in "float" style.
    --                ["Session:Toggle"]    = { mode = "n", key = "<leader>ac" },
    --                ["Session:Close"]     = { mode = "n", key = {"<esc>", "Q"} },

    --                -- Scroll
    --                ["PageUp"]            = { mode = {"i","n"}, key = "<C-b>" },
    --                ["PageDown"]          = { mode = {"i","n"}, key = "<C-f>" },
    --                ["HalfPageUp"]        = { mode = {"i","n"}, key = "<C-u>" },
    --                ["HalfPageDown"]      = { mode = {"i","n"}, key = "<C-d>" },
    --                ["JumpToTop"]         = { mode = "n", key = "gg" },
    --                ["JumpToBottom"]      = { mode = "n", key = "G" },
    --            },
    --        })
    --    end,
    --    keys = {
    --        { "<leader>ac", mode = "n", "<cmd>LLMSessionToggle<cr>" },
    --        { "<leader>af", mode = "v", "<cmd>LLMSelectedTextHandler 'Finish this'<cr>" }
    --    },
    --},
    {
      "folke/flash.nvim",
      event = "VeryLazy",
      ---@type Flash.Config
      opts = {},
      -- stylua: ignore
      keys = {
        { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
        { "S", mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
        { "r", mode = "o", function() require("flash").remote() end, desc = "Remote Flash" },
        { "R", mode = { "o", "x" }, function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
        { "<c-s>", mode = { "c" }, function() require("flash").toggle() end, desc = "Toggle Flash Search" },
      },
    },
    {
      "williamboman/mason.nvim",
      opts = {}
    },
    {
      'chomosuke/typst-preview.nvim',
      lazy = false,
      version = '1.*',
      opts = {
          debug = true,
          open_cmd = (vim.fn.has('mac') == 1 or vim.fn.has('macunix') == 1)
            and "open -W -a qutebrowser -u %s"
            or "qutebrowser %s",
          get_root = function(path_of_main_file)
            return "~/typst"
          end
      },
    }
  },
  -- Configure any other settings here. See the documentation for more details.
  -- colorscheme that will be used when installing plugins.
  install = { colorscheme = {"modus_operandi"} },
  -- automatically check for plugin updates
  checker = { enabled = false },
})

-- Parsers
require'nvim-treesitter'.install {
    'swift', 'objc',
    'c', 'cpp',
    'rust',
    'python',
    'typst', 'latex', 'markdown', 'markdown_inline',
    'html',
    'yaml',
    'json',
    'julia'
}

-- Enable highlighting with parsers
vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'swift', 'objc', 'c', 'cpp', 'rust', 'python', 'typst' },
  callback = function() vim.treesitter.start() end,
})

-- SourceKit (for just Swift)
vim.lsp.config('sourcekit', {
    filetypes = { 'swift' },
})
vim.lsp.enable('sourcekit')

-- clangd (for everything else)
vim.lsp.enable('clangd')

vim.lsp.enable('rust_analyzer')

-- tinymist for typst
vim.lsp.config("tinymist", {
    cmd = { "tinymist" },
    filetypes = { "typst" },
    root_dir = function(_, bufnr)
        -- Smart:
        -- return vim.fs.root(bufnr, { ".git" }) or vim.fn.expand("%:p:h")
        -- Dumb:
        return "~/typst"
    end,
    settings = {
        outputPath = "$root/target/$dir/$name",
        rootPath = "~/typst"
    }
})

--vim.cmd("autocmd BufNewFile,BufRead *.typ setfiletype typst")
vim.lsp.enable("tinymist")

-- Telescope
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Telescope find files' })
vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Telescope live grep' })
vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Telescope buffers' })
vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = 'Telescope help tags' })
