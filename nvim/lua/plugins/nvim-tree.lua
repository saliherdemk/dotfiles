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

			on_attach = function(bufnr)
				local api = require("nvim-tree.api")

				api.config.mappings.default_on_attach(bufnr)

				local function open_image()
					local node = api.tree.get_node_under_cursor()
					if not node or not node.absolute_path then
						return
					end

					local file = node.absolute_path
					if file:match("%.png$") or file:match("%.jpe?g$") or file:match("%.webp$") then
						vim.fn.jobstart({ "satty", "--filename", file }, { detach = true })
					else
						vim.notify("Not an image file", vim.log.levels.INFO)
					end
				end

				vim.keymap.set("n", "si", open_image, {
					buffer = bufnr,
					noremap = true,
					silent = true,
					desc = "Open image with satty",
				})
			end,

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
