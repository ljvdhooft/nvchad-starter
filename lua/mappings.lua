require "nvchad.mappings"

-- add yours here

local map = vim.keymap.set

map("i", "jk", "<ESC>")
map("n", "<C-h>", "<cmd>TmuxNavigateLeft<cr>")
map("n", "<C-j>", "<cmd>TmuxNavigateDown<cr>")
map("n", "<C-k>", "<cmd>TmuxNavigateUp<cr>")
map("n", "<C-l>", "<cmd>TmuxNavigateRight<cr>")
-- map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")
map("n", "gc", "<cmd>tabnew<CR>", { desc = "New tab" })
map("n", "<A-h>", function() require("nvchad.tabufline").move_buf(-1) end, { desc = "Move buffer left" })
map("n", "<A-l>", function() require("nvchad.tabufline").move_buf(1) end, { desc = "Move buffer right" })
map("n", "g<A-h>", "<cmd>tabmove -1<CR>", { desc = "Move tab left" })
map("n", "g<A-l>", "<cmd>tabmove +1<CR>", { desc = "Move tab right" })
map("n", "gx", "<cmd>tabclose<CR>", { desc = "Close tab" })

-- Delete/change to black hole register (don't clobber clipboard)
map({ "n", "v" }, "d", '"_d', { desc = "Delete (no clipboard)" })
map("n", "dd", '"_dd', { desc = "Delete line (no clipboard)" })
map({ "n", "v" }, "D", '"_D', { desc = "Delete to EOL (no clipboard)" })
map({ "n", "v" }, "c", '"_c', { desc = "Change (no clipboard)" })
map("n", "cc", '"_cc', { desc = "Change line (no clipboard)" })
map({ "n", "v" }, "C", '"_C', { desc = "Change to EOL (no clipboard)" })
map({ "n", "v" }, "x", '"_x', { desc = "Delete char (no clipboard)" })

-- Delete to clipboard with leader
map({ "n", "v" }, "<leader>d", '"+d', { desc = "Delete to clipboard" })
map("n", "<leader>dd", '"+dd', { desc = "Delete line to clipboard" })
map({ "n", "v" }, "<leader>D", '"+D', { desc = "Delete to EOL to clipboard" })
