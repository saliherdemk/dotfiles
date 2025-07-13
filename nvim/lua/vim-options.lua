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

-- Word skipping in insert mode. Thanks to LLM's.
vim.keymap.set("i", "<C-Right>", function()
	local row, col = unpack(vim.api.nvim_win_get_cursor(0))
	local lines = vim.api.nvim_buf_get_lines(0, row - 1, row + 1, false)
	local line = lines[1] or ""
	local next_line = lines[2] or ""
	local len = #line

	if col >= len then
		if next_line ~= "" then
			vim.api.nvim_win_set_cursor(0, { row + 1, 0 })
		end
		return
	end

	col = col + 1
	while col <= len and not line:sub(col, col):match("[%w_]") do
		col = col + 1
	end
	while col <= len and line:sub(col, col):match("[%w_]") do
		col = col + 1
	end

	vim.api.nvim_win_set_cursor(0, { row, col })
end, { noremap = true, silent = true })

vim.keymap.set("i", "<C-Left>", function()
	local row, col = unpack(vim.api.nvim_win_get_cursor(0))
	local line = vim.api.nvim_get_current_line()

	if col == 0 then
		if row > 1 then
			local prev_line = vim.api.nvim_buf_get_lines(0, row - 2, row - 1, false)[1] or ""
			vim.api.nvim_win_set_cursor(0, { row - 1, #prev_line })
		end
	else
		while col > 0 and not line:sub(col, col):match("[%w_]") do
			col = col - 1
		end
		while col > 0 and line:sub(col, col):match("[%w_]") do
			col = col - 1
		end
		vim.api.nvim_win_set_cursor(0, { row, col })
	end
end, { noremap = true, silent = true })

vim.keymap.set("i", "<Right>", function()
	local row, col = unpack(vim.api.nvim_win_get_cursor(0))
	local line = vim.api.nvim_get_current_line()
	if col >= #line then
		local total_lines = vim.api.nvim_buf_line_count(0)
		if row < total_lines then
			vim.api.nvim_win_set_cursor(0, { row + 1, 0 })
		end
	else
		vim.api.nvim_win_set_cursor(0, { row, col + 1 })
	end
end, { noremap = true, silent = true })

vim.keymap.set("i", "<Left>", function()
	local row, col = unpack(vim.api.nvim_win_get_cursor(0))
	if col == 0 then
		if row > 1 then
			local prev_line = vim.api.nvim_buf_get_lines(0, row - 2, row - 1, false)[1] or ""
			vim.api.nvim_win_set_cursor(0, { row - 1, #prev_line })
		end
	else
		vim.api.nvim_win_set_cursor(0, { row, col - 1 })
	end
end, { noremap = true, silent = true })
