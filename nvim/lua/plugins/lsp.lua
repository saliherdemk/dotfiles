return {
	{
		"williamboman/mason.nvim",
		lazy = false,
		config = function()
			require("mason").setup()
		end,
	},
	{
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		lazy = false,
		opts = {
			auto_update = false,
			start_delay = 3000,
			debounce_hours = 24,
		},
	},
	{
		"neovim/nvim-lspconfig",
		event = { "BufReadPre", "BufNewFile" },
		lazy = false,
		dependencies = {
			{
				"williamboman/mason-lspconfig.nvim",
				lazy = false,
				opts = {
					automatic_installation = true,
				},
			},
		},
		config = function()
			local capabilities = require("cmp_nvim_lsp").default_capabilities()

			local lspconfig = require("lspconfig")

			lspconfig["html"].setup({
				capabilities = capabilities,
			})

			lspconfig["ts_ls"].setup({
				capabilities = capabilities,
			})

			lspconfig["cssls"].setup({
				capabilities = capabilities,
			})

			lspconfig["tailwindcss"].setup({
				capabilities = capabilities,
			})

			-- Uncomment if you want Emmet support
			-- lspconfig["emmet_ls"].setup({
			-- 	capabilities = capabilities,
			-- 	filetypes = {
			-- 		"html",
			-- 		"typescriptreact",
			-- 		"javascriptreact",
			-- 		"css",
			-- 		"sass",
			-- 		"scss",
			-- 		"less",
			-- 		"svelte",
			-- 	},
			-- })

			-- Pyright setup with external formatting via black
			lspconfig["pyright"].setup({
				capabilities = capabilities,
				on_attach = function(client, bufnr)
					-- Enable formatting
					client.server_capabilities.documentFormattingProvider = true
					-- Keymap for formatting
					vim.api.nvim_buf_set_keymap(
						bufnr,
						"n",
						"<leader>f",
						"<cmd>lua vim.lsp.buf.format()<CR>",
						{ noremap = true, silent = true }
					)
				end,
			})

			lspconfig["lua_ls"].setup({
				capabilities = capabilities,
			})

			lspconfig["jsonls"].setup({
				capabilities = capabilities,
			})

			lspconfig["rust_analyzer"].setup({
				capabilities = capabilities,
			})

			lspconfig["intelephense"].setup({
				capabilities = capabilities,
			})
		end,
	},

	{
		"nvimtools/none-ls.nvim",
		config = function()
			local null_ls = require("null-ls")
			null_ls.setup({
				sources = {
					null_ls.builtins.formatting.black.with({
						extra_args = { "--fast" },
					}),
				},
			})
		end,
	},
}
