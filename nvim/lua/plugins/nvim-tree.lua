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

			vim.keymap.set("n", "ttg", api.tree.toggle_gitignore_filter, opts("Toggle Filter: Git Ignore"))
			vim.keymap.set("n", "ttd", api.tree.toggle_hidden_filter, opts("Toggle Filter: Dotfiles"))
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
			},
			-- git = {
			-- 	enable = true,
			-- 	ingore = false,
			-- 	timeout = 500,
			-- },
			renderer = {
				-- add_trailing = false,
				group_empty = true,
				-- highlight_git = true,
				-- full_name = false,
				highlight_opened_files = "all",
				-- root_folder_label = ":t",
				-- indent_width = 2,
				-- indent_markers = {
				-- 	enable = false,
				-- 	inline_arrows = true,
				-- 	icons = {
				-- 		corner = "└",
				-- 		edge = "│",
				-- 		item = "│",
				-- 		none = " ",
				-- 	},
				-- },
				icons = {
					git_placement = "before",
					padding = " ",
					symlink_arrow = " ➛ ",
					glyphs = {
						default = "",
						symlink = "",
						bookmark = "",
						-- folder = {
						-- 	arrow_closed = "",
						-- 	arrow_open = "",
						-- 	default = "󰉋",
						-- 	open = "",
						-- 	empty = "",
						-- 	empty_open = icons.ui.EmptyFolderOpen,
						-- 	symlink = icons.ui.FolderSymlink,
						-- 	symlink_open = icons.ui.FolderOpen,
						-- },
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
				git_ignored = false,
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
