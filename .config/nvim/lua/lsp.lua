-- Add more capabilities from nvim-cmp
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').update_capabilities(capabilities)

local lsp = require('lspconfig')

-- Configure diagnostics
vim.diagnostic.config({
	virtual_text = false,
	signs = true,
	underline = true,
	update_in_insert = true,
	severity_sort = false,
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

-- Python
-- npx install jedi-language-server
lsp.jedi_language_server.setup {
	capabilities = capabilities,
	on_attach = on_attach
}

-- Julia
-- COMMAND: julia --project=~/.julia/environments/nvim-lspconfig -e 'using Pkg; Pkg.add("LanguageServer")'
lsp.julials.setup {
	capabilities = capabilities,
	on_attach = on_attach
}

-- ESLint
-- COMMAND: yarn global add vscode-langservers-extracted
lsp.eslint.setup{
	capabilities = capabilities,
	on_attach = on_attach,
	settings = {
		codeAction = {
			disableRuleComment = {
				enable = true,
				location = "separateLine"
			},
			showDocumentation = {
				enable = true
			}
    },
		codeActionOnSave = {
			enable = false,
			mode = "all"
		},
		format = true,
		nodePath = "",
		onIgnoredFiles = "off",
		packageManager = "yarn",
		quiet = false,
		rulesCustomizations = {},
		run = "onType",
		useESLintClass = false,
		validate = "on",
		workingDirectory = {
			mode = "location"
		}
	}
}

-- Typescript
-- COMMAND: yarn global add typescript typescript-language-server
lsp.tsserver.setup{
	capabilities = capabilities,
	on_attach = on_attach
}

-- Lua
-- COMMAND: brew install lua-language-server
local runtime_path = vim.split(package.path, ';')
lsp.sumneko_lua.setup {
	capabilities = capabilities,
	on_attach = on_attach,
	settings = {
		Lua = {
			runtime = {
				version = 'LuaJIT',
				path = runtime_path,
			},
			diagnostics = {
				globals = {'vim'},
			},
			workspace = {
				library = vim.api.nvim_get_runtime_file('', true)
			},
			telemetry = {
				enable = false,
			},
		},
	},
}

-- Go
-- COMMAND: go install golang.org/x/tools/gopls@latest
lsp.gopls.setup{
	cmd = { "/Users/josephs/go/bin/gopls" },
	on_attach = on_attach
}
