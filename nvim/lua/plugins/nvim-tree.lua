return {
	"nvim-tree/nvim-tree.lua",
	version = "*",
	lazy = false,
	dependencies = {
		"nvim-tree/nvim-web-devicons",
	},
	config = function()
		local function my_on_attach(bufnr)
			local api = require("nvim-tree.api")

			local function opts(desc)
				return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
			end
			api.config.mappings.default_on_attach(bufnr)

			vim.keymap.set("n", "<Space>tg", api.tree.toggle_gitignore_filter, opts("Toggle Filter: Git Ignore"))
			vim.keymap.set("n", "<leader>td", api.tree.toggle_hidden_filter, opts("Toggle Filter: Dotfiles"))
			-- vim.keymap.set("n", "<leader>p", api.toggle)
		end
		require("nvim-tree").setup({
			on_attach = my_on_attach,
			hijack_netrw = false,
			sync_root_with_cwd = true,
			view = {
				relativenumber = true,
				adaptive_size = true,
			},
			sort = {
				sorter = "case_sensitive",
				folders_first = true,
				files_first = false,
			},
			renderer = {
				group_empty = true,
				highlight_opened_files = "all",

				icons = {
					git_placement = "before",
					padding = " ",
					symlink_arrow = " ➛ ",
					glyphs = {
						default = "",
						symlink = "",
						bookmark = "",
						git = {
							unstaged = "",
							staged = "S",
							unmerged = "",
							renamed = "",
							untracked = "U",
							deleted = "",
							ignored = "◌",
						},
					},
				},
				special_files = { "Cargo.toml", "Makefile", "README.md", "readme.md" },
				symlink_destination = true,
			},
			filters = {
				git_ignored = true,
				dotfiles = false,
				git_clean = false,
				no_buffer = false,
				no_bookmark = false,
				custom = {},
				exclude = {},
			},
		})
	end,
}
