vim.opt.relativenumber = true

local M = {}
M.ui = {
    hl_add = {},
    hl_override = {},
    changed_themes = {},

    theme_toggle = { "gruvchad", "catppuccin" },
    theme = "gruvchad",
    transparency = false,

    cmp = {
        icons = true,
        lspkind_text = true,
        style = "flat_dark", -- default/flat_light/flat_dark/atom/atom_colored
    },

    statusline = {
        theme = "minimal",
        separator_style = "round",
    },

    tabufline = {
        enabled = true,
        lazyload = false,
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
