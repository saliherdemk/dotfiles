return {
	{ -- Autoformat
		"stevearc/conform.nvim",
		opts = {
			notify_on_error = true,
			format_on_save = {
				timeout_ms = 500,
				lsp_fallback = true,
			},
			formatters_by_ft = {
				lua = { "stylua" },
				python = { "pyright", "isort", "black" },
				javascript = { "prettierd" },
				typescriptreact = { "prettierd" },
				json = { "prettierd" },
				html = { "prettierd" },
				php = { "php-cs-fixer" },
				css = { "prettierd" },
				cs = { "csharpier" },
			},
		},
	},
}
