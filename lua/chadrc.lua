local M = {}

M = {
  base46 = {
    theme = "ayu_dark",
    hl_add = {},
    hl_override = {},
    integrations = {},
    changed_themes = {},
    transparency = true,
    theme_toggle = { "solarized_dark", "ayu_dark" },
  },
  ui = {
    cmp = {
      icons = true,
      lspkind_text = true,
      style = "flat_default", -- default/flat_light/flat_dark/atom/atom_colored  
      format_colors = {
        tailwind = true,
      },
    },

    telescope = { style = "bordered" }, -- borderless / bordered

    statusline = {
      enabled = false,
      theme = "default", -- default/vscode/vscode_colored/minimal
       -- default/round/block/arrow separators work only for default statusline theme
       -- round and block will work for minimal theme only
      -- separator_style = "round",
      -- order = { "mode", "file",  "%=", "git", "lsp_msg", "diagnostics", "lsp"},
      -- modules = nil,
    },

    tabufline = {
      enabled = false,
      -- lazyload = true,
      -- order = { "treeOffset", "buffers", "tabs", "btns" },
      -- modules = nil,
      -- offsets = {
      --   {
      --     filetype = "NvimTree",
      --     text = "File Explorer",
      --     highlight = "Directory",
      --     separator = true,
      --   },
      -- },
    },
  },

  nvdash = {
    load_on_startup = true,
    header = {
      "                            ",
      "     ▄▄         ▄ ▄▄▄▄▄▄▄   ",
      "   ▄▀███▄     ▄██ █████▀    ",
      "   ██▄▀███▄   ███           ",
      "   ███  ▀███▄ ███           ",
      "   ███    ▀██ ███           ",
      "   ███      ▀ ███           ",
      "   ▀██ █████▄▀█▀▄██████▄    ",
      "     ▀ ▀▀▀▀▀▀▀ ▀▀▀▀▀▀▀▀▀▀   ",
      "                            ",
      "                                                            ",
      "                     Powered By  eovim                    ",
      "                                                            ",
    },

    buttons = {
      { txt = "  Find File", keys = "ff", cmd = "Telescope find_files" },
      { txt = "  Recent Files", keys = "fo", cmd = "Telescope oldfiles" },
      { txt = "󰈭  Find Word", keys = "fw", cmd = "Telescope live_grep" },
      { txt = "󱥚  Themes", keys = "th", cmd = ":lua require('nvchad.themes').open()" },
      { txt = "  Mappings", keys = "ch", cmd = "NvCheatsheet" },

      { txt = "─", hl = "NvDashLazy", no_gap = true, rep = true },

      {
        txt = function()
          local stats = require("lazy").stats()
          local ms = math.floor(stats.startuptime) .. " ms"
          return "  Loaded " .. stats.loaded .. "/" .. stats.count .. " plugins in " .. ms
        end,
        hl = "NvDashLazy",
        no_gap = true,
      },

      { txt = "─", hl = "NvDashLazy", no_gap = true, rep = true },
    },
  },

  term = {
    winopts = { number = false },
    sizes = { sp = 0.3, vsp = 0.2, ["bo sp"] = 0.3, ["bo vsp"] = 0.2 },
    float = {
      relative = "editor",
      row = 0.3,
      col = 0.25,
      width = 0.5,
      height = 0.4,
      border = "single",
    },
  },

  lsp = { signature = true },

  cheatsheet = {
    theme = "grid", -- simple/grid
  },

  mason = { pkgs = {} },

  colorify = {
    enabled = true,
    mode = "virtual",
    virt_text = "󱓻 ",
    highlight = { hex = true, lspvars = true },
  },
}

M.plugins = "custom.plugins"

return M
