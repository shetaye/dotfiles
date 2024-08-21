return {
  -- Treesitter
  {
    "nvim-treesitter/nvim-treesitter"
  },
  -- Treesiter highlights
  {
    "NoahTheDuke/vim-just"
  },
  -- LSP Configurations
  {
    "neovim/nvim-lspconfig"
  },
  -- Autocompletion
  {
    "hrsh7th/nvim-cmp"
  },
  -- Snippets
  {
    "L3MON4D3/LuaSnip"
  },
  -- Snippets + Autocompletion
  {
    "saadparwaiz1/cmp_luasnip"
  },
  -- LSP + Autocompletion
  {
    "hrsh7th/cmp-nvim-lsp"
  }, 
  -- Fuzzy find
  {
    "ctrlpvim/ctrlp.vim"
  },
  -- Bufferline
  {
	  "akinsho/bufferline.nvim",
	  dependencies = {
		  "nvim-tree/nvim-web-devicons",
	  },
  }
}
