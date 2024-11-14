require "nvchad.options"

-- add yours here!

local o = vim.o

o.cursorlineopt = "both" -- to enable cursorline!

vim.g.lua_snippets_path = vim.fn.stdpath "config" .. "/lua/lua_snippets"

vim.diagnostic.config({ virtual_text = false })

vim.opt.relativenumber = true

vim.opt.hidden = true
vim.opt.updatetime = 100


-- Enable syntax highlighting
vim.cmd("syntax on")

-- Set tabs and indentation
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2

-- General editor settings
vim.opt.mouse = "a"                -- Enable mouse support
vim.opt.number = true              -- Show line numbers
vim.opt.relativenumber = true      -- Show relative line numbers
vim.opt.cursorline = true          -- Highlight the current line
vim.opt.clipboard = "unnamedplus"  -- Use system clipboard
vim.opt.incsearch = true           -- Incremental search
vim.opt.hlsearch = true            -- Highlight search matches
vim.opt.autoindent = true          -- Enable auto-indentation
vim.opt.smartindent = true         -- Enable smart indentation
vim.opt.cindent = true             -- Enable C-style indentation
vim.opt.showmatch = true           -- Highlight matching parentheses
vim.opt.ruler = true               -- Show cursor position
vim.opt.wrap = true                -- Wrap lines

-- Enable filetype-specific plugins and indentation
vim.cmd("filetype plugin indent on")

-- Backspace behavior and other settings
vim.opt.backspace = { "indent", "eol", "start" }
vim.opt.ttimeout = true
vim.opt.ttimeoutlen = 1
vim.opt.ttyfast = true
vim.opt.encoding = "utf-8"

-- Key mappings
vim.keymap.set("n", "y", '"+y')
vim.keymap.set("n", "Y", '"+Y')
vim.keymap.set("n", "yy", '"+yy')

-- Insert mode mappings for brackets
vim.keymap.set("i", "{", "{}<Left>")
vim.keymap.set("i", "{<CR>", "{<CR>}<ESC>O")
vim.keymap.set("i", "{{", "{")
vim.keymap.set("i", "{}", "{}")
vim.keymap.set("i", "[", "[]<Left>")
vim.keymap.set("i", "[]", "[]")
vim.keymap.set("i", "(", "()<Left>")
vim.keymap.set("i", "()", "()")

-- Normal mode mappings for deleting brackets
vim.keymap.set("n", "c(", "di(")
vim.keymap.set("n", "c{", "di{")
vim.keymap.set("n", "c[", "di[")

-- Clear search highlighting
vim.keymap.set("n", "<Esc>", ":nohlsearch<CR>")
