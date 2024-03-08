return {
	"quarto-dev/quarto-nvim",
	oprt = {},
	dependencies = {
		"jmbuhr/otter.nvim",
		opts = {
			lspFeatures = {
				languages = {
					"r",
					"python",
					"julia",
					"bash",
					"lua",
					"html",
					"dot",
					"javascript",
					"typescript",
					"ojs",
				},
			},
		},
	},
}
