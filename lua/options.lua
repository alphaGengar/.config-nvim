require "nvchad.options"

-- add yours here!

local o = vim.o
o.cursorlineopt ='both' -- to enable cursorline!

-- Set tabstop and indentation settings
o.tabstop = 4         -- Number of spaces a tab counts for
o.shiftwidth = 4      -- Number of spaces for each indentation level
o.expandtab = true    -- Convert tabs to spaces
vim.g.lua_snippets_path = vim.fn.stdpath "config" .. "/lua/lua_snippets"
