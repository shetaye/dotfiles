-- Add more capabilities from nvim-cmp
local capabilities = require('cmp_nvim_lsp').default_capabilities()

local lsp = require('lspconfig')

-- Configure diagnostics
vim.diagnostic.config({
	virtual_text = false,
	signs = true,
	underline = true,
	update_in_insert = true,
	severity_sort = false,
})

-- Configure keybinds

-- Global mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
vim.keymap.set('n', '<space>e', vim.diagnostic.open_float)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
vim.keymap.set('n', '<space>q', vim.diagnostic.setqflist)

-- Use LspAttach autocommand to only map the following keys
-- after the language server attaches to the current buffer
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('UserLspConfig', {}),
  callback = function(ev)
    -- Enable completion triggered by <c-x><c-o>
    -- vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

    -- Buffer local mappings.
    -- See `:help vim.lsp.*` for documentation on any of the below functions
    local opts = { buffer = ev.buf }
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
    vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
    vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, opts)
    vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, opts)
    vim.keymap.set('n', '<space>wl', function()
      print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, opts)
    vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, opts)
    vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, opts)
    vim.keymap.set({ 'n', 'v' }, '<space>ca', vim.lsp.buf.code_action, opts)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
    vim.keymap.set('n', '<space>f', function()
      vim.lsp.buf.format { async = true }
    end, opts)
  end,
})

-- Autocomplete
local luasnip = require 'luasnip'
local cmp = require'cmp'
cmp.setup {
	snippet = {
    expand = function(args)
      require('luasnip').lsp_expand(args.body)
    end,
  },
	sources = {
		{ name = 'nvim_lsp' },
		{ name = 'luasnip' },
	},
	mapping = {
		['<C-p>'] = cmp.mapping.select_prev_item(),
    ['<C-n>'] = cmp.mapping.select_next_item(),
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.close(),
    ['<CR>'] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    },
    ['<Tab>'] = function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
			elseif luasnip.expand_or_jumpable() then
				luasnip.expand_or_jumpable()
      else
        fallback()
      end
    end,
		['<S-Tab>'] = function(fallback)
			if cmp.visible() then
				cmp.select_prev_item()
			elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
			else
				fallback()
			end
		end,
	}
}

--
-- LSP SERVER CONFIGURATION
--

local on_attach = function(client, bufnr)
	nnoremap("K", function() vim.lsp.buf.hover() end, "silent", {
		buffer = bufnr
	})
end

-- C/C++
-- COMMAND: None, build & install according to https://github.com/MaskRay/ccls
-- local lspconfig = require('lspconfig')
-- lspconfig.ccls.setup {
--   init_options = {
--     cache = {
--       directory = ".ccls-cache";
--     };
--   }
-- }

-- Python
-- COMMAND: npx install jedi-language-server
--lsp.jedi_language_server.setup {
--	capabilities = capabilities,
--	on_attach = on_attach
--}

-- Julia
-- COMMAND: julia --project=~/.julia/environments/nvim-lspconfig -e 'using Pkg; Pkg.add("LanguageServer")'
-- lsp.julials.setup {
-- 	capabilities = capabilities,
-- 	on_attach = on_attach
-- }

-- ESLint
-- COMMAND: yarn global add vscode-langservers-extracted
-- lsp.eslint.setup{
-- 	capabilities = capabilities,
-- 	on_attach = on_attach,
-- 	settings = {
-- 		codeAction = {
-- 			disableRuleComment = {
-- 				enable = true,
-- 				location = "separateLine"
-- 			},
-- 			showDocumentation = {
-- 				enable = true
-- 			}
--     },
-- 		codeActionOnSave = {
-- 			enable = false,
-- 			mode = "all"
-- 		},
-- 		format = true,
-- 		nodePath = "",
-- 		onIgnoredFiles = "off",
-- 		packageManager = "yarn",
-- 		quiet = false,
-- 		rulesCustomizations = {},
-- 		run = "onType",
-- 		useESLintClass = false,
-- 		validate = "on",
-- 		workingDirectory = {
-- 			mode = "location"
-- 		}
-- 	}
-- }

-- Typescript
-- COMMAND: yarn global add typescript typescript-language-server
-- COMMAND: npm install --global typescript typescript-language-server
lsp.tsserver.setup{
	capabilities = capabilities,
	on_attach = on_attach
}

-- Lua
-- COMMAND: brew install lua-language-server
-- local runtime_path = vim.split(package.path, ';')
-- lsp.sumneko_lua.setup {
-- 	capabilities = capabilities,
-- 	on_attach = on_attach,
-- 	settings = {
-- 		Lua = {
-- 			runtime = {
-- 				version = 'LuaJIT',
-- 				path = runtime_path,
-- 			},
-- 			diagnostics = {
-- 				globals = {'vim'},
-- 			},
-- 			workspace = {
-- 				library = vim.api.nvim_get_runtime_file('', true)
-- 			},
-- 			telemetry = {
-- 				enable = false,
-- 			},
-- 		},
-- 	},
-- }

-- Go
-- COMMAND: go install golang.org/x/tools/gopls@latest
lsp.gopls.setup{
  capabilities = capabilities,
	on_attach = on_attach,
  cmd = {"/home/shetaye/go/bin/gopls"}
}
