vim.opt.relativenumber = true

local M = {}
M.ui = {
  theme_toggle = {"gruvchad", "catppuccin"},
  theme = "gruvchad",
  transparency = false,
}
M.plugins = "custom.plugins"
-- M.mappings = require "custom.mappings"

return M
