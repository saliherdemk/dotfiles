-- disable netrw at the very start of your init.lua
-- vim.g.loaded_netrw = 1
-- vim.g.loaded_netrwPlugin = 1

vim.diagnostic.config({
	virtual_text = {
		prefix = "●", -- small symbol before the message (optional)
		spacing = 2, -- space between code and message
		source = "if_many", -- show the source if there are multiple
	},
	signs = true, -- show gutter signs
	underline = true, -- underline the problematic code
	update_in_insert = false,
	severity_sort = true,
})

vim.opt.splitbelow = true
vim.opt.splitright = true

vim.opt.number = true

vim.opt.relativenumber = true

vim.opt.clipboard = "unnamedplus"

vim.opt.breakindent = true

vim.opt.smartindent = true

vim.opt.undofile = false

-- Case-insensitive searching UNLESS \C or capital in search
vim.opt.ignorecase = true
vim.opt.smartcase = true

vim.opt.list = true
vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }

vim.opt.cursorline = true

vim.opt.scrolloff = 10

vim.opt.hlsearch = true
vim.opt.incsearch = true

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

vim.opt.swapfile = false
vim.opt.backup = false

-- vim.opt.hlsearch = false

vim.opt.termguicolors = true

vim.opt.updatetime = 50

vim.opt.colorcolumn = "80"

vim.keymap.set("v", "<", "<gv", { noremap = true })
vim.keymap.set("v", ">", ">gv", { noremap = true })

vim.keymap.set("n", "c", [["_c]], { noremap = true })

vim.api.nvim_create_autocmd("TextYankPost", {
	callback = function()
		vim.highlight.on_yank()
	end,
	group = vim.api.nvim_create_augroup("YankHighlight", { clear = true }),
	pattern = "*",
})

vim.api.nvim_create_autocmd("ColorScheme", {
	callback = function()
		local highlights = {
			"Normal",
		}
		for _, name in pairs(highlights) do
			vim.cmd.highlight(name .. " guibg=none ctermbg=none")
		end
	end,
})
