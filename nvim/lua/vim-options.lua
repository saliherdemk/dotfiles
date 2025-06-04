-- disable netrw at the very start of your init.lua
-- vim.g.loaded_netrw = 1
-- vim.g.loaded_netrwPlugin = 1

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

vim.keymap.set("n", "d", '"_d', { noremap = true })
vim.keymap.set("v", "d", '"_d', { noremap = true })
vim.keymap.set("n", "x", '"_x', { noremap = true })
vim.keymap.set("n", "c", '"_c', { noremap = true })
vim.keymap.set("v", "c", '"_c', { noremap = true })

vim.keymap.set("n", "dd", "dd", { noremap = true })


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
