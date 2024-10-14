require "nvchad.mappings"

-- add yours here
-- -- n, v, i, t = mode names

local map = vim.keymap.set

-- General mappings
map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")

-- CP (Competitive Programming) mappings
map("n", "<leader>cta", ":CompetiTest add_testcase<Space><CR>", { desc = "Add Testcase" })
map("n", "<leader>cte", ":CompetiTest edit_testcase<Space><CR>", { desc = "Edit Testcase" })
map("n", "<leader>ctr", ":CompetiTest run<Space><CR>", { desc = "Run Testcases" })
map("n", "<leader>ctc", ":CompetiTest receive contest<Space><CR>", { desc = "Receive Contest" })
map("n", "<leader>ctp", ":CompetiTest receive problem<Space><CR>", { desc = "Receive Problem" })
map("n", "<leader>ctg", ":CompetiTest receive testcases<Space><CR>", { desc = "Receive Testcases" })
map("n", "<leader>cf", ":lua CopyCurrentFileName()<CR>", { desc = "Copy File Name" })

-- Leet (LeetCode) mappings
map("n", "<leader>leet", "<cmd>Leet<CR>", { desc = "Leet Dashboard" })
map("n", "<leader>lq", "<cmd>Leet exit<CR>", { desc = "Close Leet" })
map("n", "<leader>lrt", "<cmd>Leet test<CR>", { desc = "Test Question" })
map("n", "<leader>lrq", "<cmd>Leet random<CR>", { desc = "Random Question" })
map("n", "<leader>lre", "<cmd>Leet random difficulty=easy<CR>", { desc = "Random Easy Question" })
map("n", "<leader>lrm", "<cmd>Leet random difficulty=medium<CR>", { desc = "Random Medium Question" })
map("n", "<leader>lrh", "<cmd>Leet random difficulty=hard<CR>", { desc = "Random Hard Question" })
map("n", "<leader>lx", "<cmd>Leet reset<CR>", { desc = "Reset Question" })
map("n", "<leader>ld", "<cmd>Leet desc<CR>", { desc = "Toggle Description" })

-- Additional useful mappings from the original config
map("n", "<leader>dn", ":lua require('notify').dismiss()<CR>", { desc = "Dismiss Notifications" })
map("n", "<C-c>", "<cmd> %y+ <CR>", { desc = "Copy whole file" })
map("n", "<leader>n", "<cmd> set nu! <CR>", { desc = "Toggle line number" })
map("n", "<leader>b", "<cmd> enew <CR>", { desc = "New buffer" })
map("n", "<leader>ch", "<cmd> NvCheatsheet <CR>", { desc = "Mapping cheatsheet" })

-- Transparency toggle
map("n", "<leader>tt", function()
  require("base46").toggle_transparency()
end, { desc = "Toggle transparency" })

-- LSP formatting
map("n", "<leader>fm", function()
  vim.lsp.buf.format { async = true }
end, { desc = "LSP formatting" })
