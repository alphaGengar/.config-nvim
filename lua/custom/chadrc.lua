vim.opt.relativenumber = true

local M = {}
M.ui = {
  theme_toggle = { "gruvbox", "catppuccin" },
  theme = "gruvbox",
  transparency = false,
  statusline = {
    theme = "minimal",
    separator_style = "round",
  },
}

M.override = {
  CursorLine = {
    bg = "white"
  }
}

M.plugins = "custom.plugins"

return M
