-- Bootstrapper for when I end up breaking something and need to reinstall
local fn = vim.fn
local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
  packer_bootstrap = fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
end

return require('packer').startup(function ()
  -- Packer can manage itself
  use 'wbthomason/packer.nvim'
  -- Wonderful theme
  use 'morhetz/gruvbox'
  -- Another wonderful theme
  use 'rose-pine/neovim'
  -- Another wonderful theme
  use 'jeffkreeftmeijer/vim-dim'
  -- Treesitter for syntax highlighting
  use {
    'nvim-treesitter/nvim-treesitter',
     run = ':TSUpdate'
  }
	-- LSP
	use 'neovim/nvim-lspconfig'
  -- Buffer list
  use {'akinsho/bufferline.nvim', tag = "*", requires = 'nvim-tree/nvim-web-devicons'}
  -- Fuzzy finding
  use 'ctrlpvim/ctrlp.vim'
	-- Autocompletion
	use 'hrsh7th/nvim-cmp'
	-- LSP -> Autocompletion
	use 'hrsh7th/cmp-nvim-lsp'
	-- Snippets
	use 'L3MON4D3/LuaSnip'
	-- Snippets -> Autocompletion
	use 'saadparwaiz1/cmp_luasnip'
  -- MapX to make keybindings easier
  use "b0o/mapx.nvim"
	-- Lualine for status line
	use {
		'nvim-lualine/lualine.nvim',
		requires = { 'kyazdani42/nvim-web-devicons', opt = true }
	}
	-- Treesitter highlighting
	use 'NoahTheDuke/vim-just'
  if packer_bootstrap then
    require('packer').sync()
  end
end)
