vim.opt.relativenumber = true

local M = {}
M.ui = {
  hl_add = {},
  hl_override = {},
  changed_themes = {},

  theme_toggle = { "gruvbox", "ayu_dark" },
  theme = "gruvbox",
  transparency = false,

  cmp = {
    icons = true,
    lspkind_text = true,
  },

  statusline = {
    theme = "minimal",
    -- separator_style = "default",
  },

  tabufline = {
    enabled = true,
    lazyload = true,
    offsets = {
      filetype = "NvimTree",
      text = "File Explorer",       -- title on top
      highlight = "Directory",
      separator = true,
    }
  },
}

M.plugins = "custom.plugins"

return M
