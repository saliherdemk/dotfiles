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

			lspconfig["tsserver"].setup({
				capabilities = capabilities,
			})

			lspconfig["cssls"].setup({
				capabilities = capabilities,
			})

			lspconfig["tailwindcss"].setup({
				capabilities = capabilities,
			})
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

			lspconfig["pyright"].setup({
				capabilities = capabilities,
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
}
