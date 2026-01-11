return {
	-- Adjust indents
	{ "tpope/vim-sleuth" },

	-- Useful plugin to show you pending keybinds.
	{ "folke/which-key.nvim", opts = {} },

	{
		-- Add indentation guides even on blank lines
		"lukas-reineke/indent-blankline.nvim",
		-- Enable `lukas-reineke/indent-blankline.nvim`
		-- See `:help ibl`
		main = "ibl",
		opts = {},
	},

	-- "gc" to comment visual regions/lines
	{ "numToStr/Comment.nvim", opts = {} },

	{
		"windwp/nvim-autopairs",
		event = "InsertEnter",
		config = true,
	},
	-- Hide colorColumn until one of lines in the scope exceeds the colorColumn
	{
		"m4xshen/smartcolumn.nvim",
		opts = {},
	},
	{
		"iamcco/markdown-preview.nvim",
		cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
		build = "cd app && npm install && git restore .",
		init = function()
			vim.g.mkdp_filetypes = { "markdown" }
		end,
		ft = { "markdown" },
	},
	{
		"Diogo-ss/five-server.nvim",
		cmd = { "FiveServer" },
		build = function()
			require("fs.utils.install")()
		end,
		opts = {
			notify = true,
			-- add other options
		},
		config = function(_, opts)
			require("fs").setup(opts)
		end,
	},
	{
		"akinsho/toggleterm.nvim",
		version = "*",
		opts = {},
	},
	{ "stevearc/dressing.nvim" },
	{
		"linux-cultist/venv-selector.nvim",
		dependencies = {
			"neovim/nvim-lspconfig",
			{ "nvim-telescope/telescope.nvim", branch = "0.1.x", dependencies = { "nvim-lua/plenary.nvim" } }, -- optional: you can also use fzf-lua, snacks, mini-pick instead.
		},
		ft = "python", -- Load when opening Python files
		keys = {
			{ "<C-l>", "<cmd>VenvSelect<cr>" }, -- Open picker on keymap
		},
		opts = { -- this can be an empty lua table - just showing below for clarity.
			search = {}, -- if you add your own searches, they go here.
			options = {}, -- if you add plugin options, they go here.
		},
	},
	{
		"akinsho/bufferline.nvim",
		version = "*",
		dependencies = "nvim-tree/nvim-web-devicons",
		config = function()
			require("bufferline").setup({
				options = {
					mode = "tabs",
					offsets = {
						{
							filetype = "NvimTree",
							text = "File Explorer",
							text_align = "center",
							highlight = "Directory",
							separator = true,
						},
					},
				},
			})
		end,
	},

	{
		"chrisgrieser/nvim-spider",
		lazy = true,
	},
}
