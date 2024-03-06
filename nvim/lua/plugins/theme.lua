return {
	{ -- Theme inspired by Atom
		'navarasu/onedark.nvim',
		priority = 1000,
		lazy = false,
		config = function()
			require('onedark').setup {
				-- Set a style preset. 'dark' is default.
				style = 'dark', -- dark, darker, cool, deep, warm, warmer, light
			}
			require('onedark').load()
		end
	},
	{ {
		-- Set lualine as statusline
		'nvim-lualine/lualine.nvim',
		-- See `:help lualine.txt`
		opts = {
			options = {
				icons_enabled = false,
				theme = 'auto',
				component_separators = '|',
				section_separators = '',
			},
		},
	} },
	{ 'xiyaowong/transparent.nvim' }


}
