require "nvchad.options"

-- add yours here!

local o = vim.o

o.cursorlineopt = "both" -- to enable cursorline!

vim.g.lua_snippets_path = vim.fn.stdpath "config" .. "/lua/lua_snippets"

vim.diagnostic.config({ virtual_text = false })

vim.opt.relativenumber = true

vim.opt.hidden = true
vim.opt.updatetime = 100
