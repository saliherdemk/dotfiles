vim.g.have_nerd_font = true

vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

vim.keymap.set("n", "J", "mzJ`z")
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")

vim.keymap.set("v", "p", '"_dP')

vim.keymap.set("n", "<leader>0", "$")

vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])
vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true })

vim.keymap.set("n", "K", vim.lsp.buf.hover, {})
vim.keymap.set("n", "<leader>gd", vim.lsp.buf.definition, {})
vim.keymap.set("n", "<leader>gr", vim.lsp.buf.references, {})
vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, {})

vim.keymap.set("n", "<leader>gf", vim.lsp.buf.format, {})

vim.keymap.set("n", "<leader>e", ":NvimTreeToggle<cr>")

vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

vim.keymap.set("n", "<left>", '<cmd>echo "Use h to move!!"<CR>')
vim.keymap.set("n", "<right>", '<cmd>echo "Use l to move!!"<CR>')
vim.keymap.set("n", "<up>", '<cmd>echo "Use k to move!!"<CR>')
vim.keymap.set("n", "<down>", '<cmd>echo "Use j to move!!"<CR>')

vim.keymap.set("n", "<leader>do", ":DiffviewOpen<CR>")
vim.keymap.set("n", "<leader>dc", ":DiffviewClose<CR>")

local builtin = require("telescope.builtin")
vim.keymap.set("n", "<C-p>", builtin.find_files, {})
vim.keymap.set("n", "<leader>fg", builtin.live_grep, {})

local api = require("nvim-tree.api")
vim.keymap.set("n", "<leader>tg", api.tree.toggle_gitignore_filter)
vim.keymap.set("n", "<leader>td", api.tree.toggle_hidden_filter)

vim.keymap.set("n", "<leader>ct", ":CopilotChatToggle<CR>")
vim.keymap.set("v", "<leader>ce", ":CopilotChatExplain<CR>")
vim.keymap.set("v", "<leader>cf", ":CopilotChatFix<CR>")
vim.keymap.set("n", "<leader>cd", ":CopilotChatDocs<CR>")
vim.keymap.set("v", "<leader>co", ":CopilotChatOptimize<CR>")

vim.api.nvim_set_keymap("n", "<M-Right>", "<C-w>l", { noremap = true })
vim.api.nvim_set_keymap("n", "<M-Left>", "<C-w>h", { noremap = true })
vim.api.nvim_set_keymap("n", "<M-Up>", "<C-w>k", { noremap = true })
vim.api.nvim_set_keymap("n", "<M-Down>", "<C-w>j", { noremap = true })
vim.api.nvim_set_keymap("n", "<M-j>", "<C-w>j", { noremap = true })
vim.api.nvim_set_keymap("n", "<M-k>", "<C-w>k", { noremap = true })
vim.api.nvim_set_keymap("n", "<M-h>", "<C-w>h", { noremap = true })
vim.api.nvim_set_keymap("n", "<M-l>", "<C-w>l", { noremap = true })

vim.api.nvim_set_keymap("n", "<M-,>", "<C-w><", { noremap = true })
vim.api.nvim_set_keymap("n", "<M-.>", "<C-w>>", { noremap = true })

vim.api.nvim_set_keymap("n", "<M-q>", "<C-w>q", { noremap = true })

vim.api.nvim_set_keymap("n", "<C-l>", ":VenvSelect<CR>", { noremap = true })

vim.api.nvim_set_keymap("n", "<leader>n", ":vsplit<CR>:term<CR>", { noremap = true })
vim.api.nvim_set_keymap("n", "<leader>b", ":split<CR>:term<CR>", { noremap = true })
vim.api.nvim_set_keymap("n", "<leader>m", ":ToggleTerm<CR>", { noremap = true })

vim.api.nvim_set_keymap("n", "<leader>x", ":q<CR>", { noremap = true })

vim.api.nvim_set_keymap("n", "<C-a>", "ggVG", { noremap = true })

vim.api.nvim_set_keymap("n", "<C-s>", ":w<CR>", { noremap = true })
vim.api.nvim_set_keymap("i", "<C-s>", "<Esc>:w<CR>a", { noremap = true })

vim.api.nvim_set_keymap("i", "jj", "<Esc>", { noremap = true })

local harpoon = require("harpoon")

vim.keymap.set("n", "<leader>a", function()
	harpoon:list():add()
end)
vim.keymap.set("n", "<C-e>", function()
	harpoon.ui:toggle_quick_menu(harpoon:list())
end)

vim.keymap.set("n", "<C-h>", function()
	harpoon:list():select(1)
end)
vim.keymap.set("n", "<C-t>", function()
	harpoon:list():select(2)
end)
-- Toggle previous & next buffers stored within Harpoon list
vim.keymap.set("n", "<C-m>", function()
	harpoon:list():prev()
end)
vim.keymap.set("n", "<C-n>", function()
	harpoon:list():next()
end)

function _G.set_terminal_keymaps()
	local opts = { buffer = 0 }
	vim.keymap.set("t", "<esc>", [[<C-\><C-n>]], opts)
	vim.keymap.set("t", "<C-w>", [[<C-\><C-n><C-w>]], opts)
end

vim.cmd("autocmd! TermOpen term://* lua set_terminal_keymaps()")
