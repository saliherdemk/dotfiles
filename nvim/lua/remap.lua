vim.g.have_nerd_font = true

-- Move selected lines
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { silent = true })
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { silent = true })

-- Paste without overwriting register
vim.keymap.set("v", "p", '"_dP')

-- Better line join
vim.keymap.set("n", "J", "mzJ`z")

-- Scrolling
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")

-- Line navigation
vim.keymap.set("n", "<leader>0", "$")
vim.keymap.set("n", "<leader>1", "^")

-- Search & replace word under cursor
vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])

-- LSP
vim.keymap.set("n", "K", vim.lsp.buf.hover)
vim.keymap.set("n", "<leader>gd", vim.lsp.buf.definition)
vim.keymap.set("n", "<leader>gr", vim.lsp.buf.references)
vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action)
vim.keymap.set("n", "<leader>gf", vim.lsp.buf.format)

-- File tree
vim.keymap.set("n", "<leader>e", "<cmd>NvimTreeToggle<CR>", { silent = true })

-- Clear search highlight
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- Disable arrow keys
vim.keymap.set("n", "<left>", '<cmd>echo "Use h to move!!"<CR>')
vim.keymap.set("n", "<right>", '<cmd>echo "Use l to move!!"<CR>')
vim.keymap.set("n", "<up>", '<cmd>echo "Use k to move!!"<CR>')
vim.keymap.set("n", "<down>", '<cmd>echo "Use j to move!!"<CR>')

-- Diffview
vim.keymap.set("n", "<leader>do", "<cmd>DiffviewOpen<CR>")
vim.keymap.set("n", "<leader>dc", "<cmd>DiffviewClose<CR>")

-- Telescope
vim.keymap.set("n", "<C-p>", function()
	require("telescope.builtin").find_files()
end)

vim.keymap.set("n", "<leader>fg", function()
	require("telescope.builtin").live_grep()
end)

-- NvimTree filters
local api = require("nvim-tree.api")
vim.keymap.set("n", "<leader>tg", api.tree.toggle_gitignore_filter)
vim.keymap.set("n", "<leader>td", api.tree.toggle_hidden_filter)

-- Window navigation
vim.keymap.set("n", "<M-h>", "<C-w>h")
vim.keymap.set("n", "<M-j>", "<C-w>j")
vim.keymap.set("n", "<M-k>", "<C-w>k")
vim.keymap.set("n", "<M-l>", "<C-w>l")

-- Resize windows
vim.keymap.set("n", "<C-0>", "<C-w>=")

-- Close window
vim.keymap.set("n", "<leader>x", "<C-w>q")

-- Tabs & terminal
vim.keymap.set("n", "<leader>b", "<cmd>tabnew<CR>")
vim.keymap.set("n", "<leader>n", "<cmd>tab term<CR>")
vim.keymap.set("n", "<leader>m", "<cmd>ToggleTerm<CR>")
vim.keymap.set("n", "<A-Tab>", "<cmd>tabnext<CR>")

-- Select all
vim.keymap.set("n", "<C-a>", "ggVG")

-- Save
vim.keymap.set("n", "<C-s>", "<cmd>w<CR>")
vim.keymap.set("i", "<C-s>", "<Esc><cmd>w<CR>a")

-- Exit insert mode
vim.keymap.set("i", "jj", "<Esc>")

-- TERMINAL
function _G.set_terminal_keymaps()
	local opts = { buffer = 0 }
	vim.keymap.set("t", "<esc>", [[<C-\><C-n>]], opts)
	vim.keymap.set("t", "<C-w>", [[<C-\><C-n><C-w>]], opts)
end

vim.cmd("autocmd! TermOpen term://* lua set_terminal_keymaps()")

-- DIAGNOSTICS
vim.keymap.set("n", "<leader>se", function()
	vim.diagnostic.open_float({
		focusable = true,
		scope = "line",
	})
end)

-- Subword Config

local function spider(motion)
	return function()
		require("spider").motion(motion)
	end
end

vim.keymap.set({ "n", "x", "o" }, "w", spider("w"), { silent = true })
vim.keymap.set({ "n", "x", "o" }, "e", spider("e"), { silent = true })
vim.keymap.set({ "n", "x", "o" }, "b", spider("b"), { silent = true })

vim.keymap.set("i", "<C-Right>", spider("w"), { silent = true })
vim.keymap.set("i", "<C-Left>", spider("b"), { silent = true })

-- Delete previous word in insert mode (Ctrl+Backspace)
vim.keymap.set("i", "<C-BS>", function()
	local row, col = unpack(vim.api.nvim_win_get_cursor(0))
	local line = vim.api.nvim_get_current_line()

	-- nothing to delete
	if col == 0 then
		return
	end

	-- Find start of previous "word" (letters, numbers, or _)
	local left = line:sub(1, col)
	local start_col = left:find("[%w_]+[^%w_]*$") or 1

	-- Delete from start_col-1 to col
	local new_line = left:sub(1, start_col - 1) .. line:sub(col + 1)
	vim.api.nvim_set_current_line(new_line)
	vim.api.nvim_win_set_cursor(0, { row, start_col - 1 })
end, { silent = true })
