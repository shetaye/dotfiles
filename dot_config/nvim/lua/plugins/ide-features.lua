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
  -- VimTeX
  {
    "lervag/vimtex",
    lazy = false,
    init = function()
      -- VimTeX configuration goes here, e.g.
      vim.g.vimtex_view_method = "zathura"
    end
  },
  -- Ollama
  {
    "nomnivore/ollama.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },

    -- All the user commands added by the plugin
    cmd = { "Ollama", "OllamaModel", "OllamaServe", "OllamaServeStop" },

    keys = {
      -- Sample keybind for prompt menu. Note that the <c-u> is important for selections to work properly.
      {
        "<leader>oo",
        ":<c-u>lua require('ollama').prompt()<cr>",
        desc = "ollama prompt",
        mode = { "n", "v" },
      },

      -- Sample keybind for direct prompting. Note that the <c-u> is important for selections to work properly.
      {
        "<leader>oG",
        ":<c-u>lua require('ollama').prompt('Generate_Code')<cr>",
        desc = "ollama Generate Code",
        mode = { "n", "v" },
      },
    }
  }
}
