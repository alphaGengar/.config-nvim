local options = {
  filters = {
    dotfiles = false,
    exclude = { vim.fn.stdpath "config" .. "/lua/custom" },
    enable = true,
    custom = function(path)
      if vim.endswith(path, ".testcases") then
        return true
      end
      if not string.match(path, "%.") then
        return true
      end
      return false
    end,

  },
  disable_netrw = true,
  hijack_netrw = true,
  hijack_cursor = true,
  hijack_unnamed_buffer_when_opening = false,
  view = {
    adaptive_size = true,
    side = "left",
    width = 35,
    preserve_window_proportions = true,
  },
  git = {
    enable = true,
    ignore = true,
  },
  filesystem_watchers = {
    enable = true,
  },
  renderer = {
    root_folder_label = false,
    indent_markers = {
      enable = false,
      icons = {
        corner = "└",
        edge = "|",
        item = "|",
        bottom = "─",
        none = " ",
      },
    },

    icons = {
      glyphs = {
        default = "󰈚",
        symlink = "",
        folder = {
          default = "",
          empty = "",
          empty_open = "",
          open = "",
          symlink = "",
          symlink_open = "",
          arrow_open = "",
          arrow_closed = "",
        },
        git = {
          unstaged = "✗",
          staged = "✓",
          unmerged = "",
          renamed = "➜",
          untracked = "★",
          deleted = "",
          ignored = "◌",
        },
      },
      padding = " ",
    },
  },
  actions = {
    open_file = {
      quit_on_open = true,
      window_picker = {
        enable = true,
      },
    },
  },
  update_focused_file = {
    enable = true,
    update_root = true,
  },
  sync_root_with_cwd = true,
  respect_buf_cwd = true,
}

--[[
vim.g.loaded = 1
vim.g.loaded_netrwPlugin = 1

local opts = {
  "nvim-tree/nvim-tree.lua",
  filters = {
    dotfiles = false,
    exclude = { vim.fn.stdpath "config" .. "/lua/custom" },
    enable = true,
    custom = function(path)
      if vim.endswith(path, ".testcases") then
        return true
      end
      if not string.match(path, "%.") then
        return true
      end
      return false
    end,
  },

  view = {
    width = 45,
  },
  renderer = {
    root_folder_label = false, -- hide root directory at the top
    indent_markers = {
      enable = false,          -- folder level guide
      icons = {
        corner = "└",
        edge = "|",
        item = "|",
        bottom = "─",
        none = " ",
      },
    },
    icons = {
      glyphs = {
        default = "󰈚",
        symlink = "",
        folder = {
          arrow_closed = "",
          arrow_open = "",
          default = "",
          open = "",
          empty = "",
          empty_open = "",
        },
        git = {
          unstaged = "",
          staged = "",
          unmerged = "",
          renamed = "➜",
          untracked = "★",
          deleted = "",
          ignored = "◌",
        },
      },
      padding = " ",
    },
  },
  actions = {
    open_file = {
      quit_on_open = true,
      window_picker = {
        enable = true,
      },
    },
  },
  update_focused_file = {
    enable = true,
    update_root = true,
  },
  sync_root_with_cwd = true,
  respect_buf_cwd = true,
}
]]
return options
