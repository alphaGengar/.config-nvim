-- Load NvChad base mappings
require "nvchad.mappings"

local unpack = table.unpack or unpack

-- Mapping helper function
local function map(mode, lhs, rhs, opts)
  opts = opts or {}
  opts.silent = opts.silent ~= false
  vim.keymap.set(mode, lhs, rhs, opts)
end

local M = {}

-- Organize mappings by category
M.general = {
  { "n", ";",          ":",                       { desc = "CMD enter command mode" } },
  { "n", "<leader>n",  "<cmd> set nu! <CR>",      { desc = "Toggle line number" } },
  { "n", "<leader>b",  "<cmd> enew <CR>",         { desc = "New buffer" } },
  { "n", "<leader>ch", "<cmd> NvCheatsheet <CR>", { desc = "Mapping cheatsheet" } },
  { "n", "<C-c>",      "<cmd> %y+ <CR>",          { desc = "Copy whole file" } },
  { "i", "jk",         "<ESC>",                   { desc = "Exit insert mode" } },
}

-- LSP related mappings
M.lsp = {
  { "n", "<leader>ra", ':lua require("nvchad.lsp.renamer")()<CR>',     { desc = "LSP Rename" } },
  {
    "n",
    "<leader>fm",
    function()
      vim.lsp.buf.format { async = true }
    end,
    { desc = "LSP formatting" },
  },
  { "n", "<leader>ca", ':lua require("actions-preview").code_actions()<CR>', { desc = "LSP Code Actions" } },
}

-- Competitive Programming mappings (CompetiTest plugin)
M.competitive = {
  { "n", "<leader>cta", ":CompetiTest add_testcase<Space><CR>",      { desc = "Add Testcase" } },
  { "n", "<leader>cte", ":CompetiTest edit_testcase<Space><CR>",     { desc = "Edit Testcase" } },
  { "n", "<leader>ctr", ":CompetiTest run<Space><CR>",               { desc = "Run Testcases" } },
  { "n", "<leader>ctc", ":CompetiTest receive contest<Space><CR>",   { desc = "Receive Contest" } },
  { "n", "<leader>ctp", ":CompetiTest receive problem<Space><CR>",   { desc = "Receive Problem" } },
  { "n", "<leader>ctg", ":CompetiTest receive testcases<Space><CR>", { desc = "Receive Testcases" } },
  { "n", "<leader>cf",  ":lua CopyCurrentFileName()<CR>",            { desc = "Copy File Name" } },
}

-- LeetCode mappings (Leet.nvim plugin)
M.leetcode = {
  { "n", "<leader>leet", "<cmd>Leet<CR>",                          { desc = "Leet Dashboard" } },
  { "n", "<leader>lq",   "<cmd>Leet exit<CR>",                     { desc = "Close Leet" } },
  { "n", "<leader>lrq",  "<cmd>Leet random<CR>",                   { desc = "Random Question" } },
  { "n", "<leader>lre",  "<cmd>Leet random difficulty=easy<CR>",   { desc = "Random Easy Question" } },
  { "n", "<leader>lrm",  "<cmd>Leet random difficulty=medium<CR>", { desc = "Random Medium Question" } },
  { "n", "<leader>lrh",  "<cmd>Leet random difficulty=hard<CR>",   { desc = "Random Hard Question" } },
  { "n", "<leader>lx",   "<cmd>Leet reset<CR>",                    { desc = "Reset Question" } },
  { "n", "<leader>ld",   "<cmd>Leet desc<CR>",                     { desc = "Toggle Description" } },
}

-- Utility mappings
M.utils = {
  { "n", "<leader>dn", ":lua require('notify').dismiss()<CR>", { desc = "Dismiss Notifications" } },
  {
    "n",
    "<leader>tt",
    function()
      require("base46").toggle_transparency()
    end,
    { desc = "Toggle transparency" },
  },
}

-- YankBank mappings
M.yankbank = {
  { "n", "<leader>pp", "<cmd>:YankBank<CR>",        { desc = "Yank Clipboard" } },
  { "n", "<leader>pc", "<cmd>:YankBankClearDB<CR>", { desc = "Clear YankBank History" } },
}

-- Apply all mappings
local function load_mappings()
  for _, category in pairs(M) do
    for _, mapping in ipairs(category) do
      local mode, lhs, rhs, opts = unpack(mapping)       -- Use table.unpack() here
      map(mode, lhs, rhs, opts)
    end
  end
end

-- Initialize mappings
load_mappings()

-- Export mappings table for potential external use
return M
