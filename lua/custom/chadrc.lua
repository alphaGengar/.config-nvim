vim.opt.relativenumber = true

local M = {}
M.ui = {
  hl_add = {},
  hl_override = {},
  changed_themes = {},

  theme_toggle = { "gruvbox", "catppuccin" },
  theme = "gruvbox",
  transparency = true,

  cmp = {
    icons = true,
    lspkind_text = true,
    style = "default", -- default/flat_light/flat_dark/atom/atom_colored
  },

  statusline = {
    theme = "minimal",
    separator_style = "round",
  },

  tabufline = {
    enabled = true,
    offsets = {
      filetype = "NvimTree",
      text = "File Explorer", -- title on top
      highlight = "Directory",
      separator = true,
    }
  },
}

M.plugins = "custom.plugins"

return M
