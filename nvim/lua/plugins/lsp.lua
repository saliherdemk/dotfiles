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
			ensure_installed = {
				"omnisharp",
				"csharpier",
				"black",
				"prettierd",
				"pyright",
				"stylua",
			},
			auto_update = false,
			start_delay = 3000,
			debounce_hours = 24,
		},
	},
	{
		"neovim/nvim-lspconfig",
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
			local lspconfig = vim.lsp

			lspconfig.config("*", {
				capabilities = capabilities,
				root_markers = { ".git" },
			})

			lspconfig.config("html", {
				cmd = { "vscode-html-language-server", "--stdio" },
				filetypes = { "html" },
			})
			lspconfig.config("ts_ls", {})
			lspconfig.config("cssls", {})
			lspconfig.config("lua_ls", {})
			lspconfig.config("jsonls", {})
			lspconfig.config("tailwindcss", {})
			lspconfig.config("omnisharp", { -- Changed from csharp_ls
				filetypes = { "cs" },
				root_markers = { "*.sln", "*.csproj", ".git" },
			})
			lspconfig.config("emmet_ls", {
				filetypes = { "html", "htmldjango", "typescriptreact", "javascriptreact", "tsx", "jsx" },
			})
			lspconfig.config("pyright", {
				filetypes = { "python" },
				root_markers = { "requirements.txt", ".git" },
				settings = {
					python = {
						analysis = {
							autoSearchPaths = true,
							diagnosticMode = "workspace",
							typeCheckingMode = "basic",
						},
					},
				},
			})

			lspconfig.enable("html")
			lspconfig.enable("ts_ls")
			lspconfig.enable("cssls")
			lspconfig.enable("lua_ls")
			lspconfig.enable("jsonls")
			lspconfig.enable("tailwindcss")
			lspconfig.enable("omnisharp") -- Changed from csharp_ls
			lspconfig.enable("emmet_ls")
			lspconfig.enable("pyright")
		end,
	},
}
