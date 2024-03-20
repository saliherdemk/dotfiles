return {
	"nvim-tree/nvim-tree.lua",
	version = "*",
	lazy = false,
	dependencies = {
		"nvim-tree/nvim-web-devicons",
	},
	config = function()
		require("nvim-tree").setup({
			hijack_netrw = false,
			sync_root_with_cwd = true,
			view = {
				width = 35,
				relativenumber = true,
				-- adaptive_size = true,
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
