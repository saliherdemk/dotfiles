-- disable netrw at the very start of your init.lua
-- vim.g.loaded_netrw = 1
-- vim.g.loaded_netrwPlugin = 1

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

vim.api.nvim_create_autocmd("TextYankPost", {
	callback = function()
		vim.highlight.on_yank()
	end,
	group = vim.api.nvim_create_augroup("YankHighlight", { clear = true }),
	pattern = "*",
})
