local lazy_plugins = {
  --zen
  {
    event = "VeryLazy",
    "folke/zen-mode.nvim",
    opts = {
      plugins = {
        tmux = { enabled = true },
        alacritty = {
          enabled = true,
          font = "16", -- font size
        },
      },
      on_open = function()
        vim.cmd(":lua require('incline').disable()")
        vim.api.nvim_set_hl(0, "ZenBg", { ctermbg = 0 })
      end,
      on_close = function ()
        vim.cmd(":lua require('incline').enable()")
      end,
    },
  },
  -- context
  {
    'SmiteshP/nvim-navic',
  },
  -- file name
  {
    lazy = false,
    'b0o/incline.nvim',
    dependencies = "SmiteshP/nvim-navic",
    config = function()
      local helpers = require 'incline.helpers'
      local navic = require 'nvim-navic'
      local devicons = require 'nvim-web-devicons'
      require('incline').setup {
        ignore = {
          buftypes = "special",
          filetypes = {},
          floating_wins = true,
          unlisted_buffers = true,
          wintypes = "special"
        },
        window = {
          padding = 1,
          margin = { horizontal = 1, vertical = 1 },
          placement = {
            horizontal = "center",
            vertical = "top"
          },
        },
        render = function(props)
          local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(props.buf), ':t')
          if filename == '' then
            filename = '[No Name]'
          end
          local ft_icon, ft_color = devicons.get_icon_color(filename)
          local modified = vim.bo[props.buf].modified
          local res = {
            ft_icon and { ' ', ft_icon, ' ', guibg = ft_color, guifg = helpers.contrast_color(ft_color) } or '',
            ' ',
            { filename, gui = modified and 'bold,italic' or 'bold' },
          }
          if props.focused then
            for _, item in ipairs(navic.get_data(props.buf) or {}) do
              table.insert(res, {
                { ' > ',     group = 'NavicSeparator' },
                { item.icon, group = 'NavicIcons' .. item.type },
                { item.name, group = 'NavicText' },
              })
            end
          end
          table.insert(res, ' ')
          return res
        end,
      }
    end,
  },
  -- make it rain
  {
    'eandrju/cellular-automaton.nvim',
    event = "VeryLazy",
  },
  -- leetcode
  {
    "kawre/leetcode.nvim",
    lazy = true,
    cmd = "Leet",
    build = ":TSUpdate html",
    dependencies = {
      "nvim-telescope/telescope.nvim",
      "nvim-lua/plenary.nvim", -- required by telescope
      "MunifTanjim/nui.nvim",

      -- optional
      "nvim-treesitter/nvim-treesitter",
      "rcarriga/nvim-notify",
      "nvim-tree/nvim-web-devicons",
    },
    opts = {
      arg = "leetcode.nvim",
      lang = "cpp",
      keys = {
        toggle = { "q" },
        confirm = { "<CR>" },

        reset_testcases = "r",
        use_testcase = "U",
        focus_testcases = "H",
        focus_result = "L",
      },
      injector = {
        ["cpp"] = {
          before = { "#include <bits/stdc++.h>", '#include "./ListNode.cpp"', "using namespace std;", "#define ll long long", "#define all(x) x.begin(), x.end()" },
        },
      }
    },
  },
  -- Presence
  {
    "jiriks74/presence.nvim",
    event = "UIEnter",
  },
  --leap
  {
    "ggandor/leap.nvim",
    enabled = true,
    keys = {
      { "s",  mode = { "n", "x", "o" }, desc = "Leap Forward to" },
      { "S",  mode = { "n", "x", "o" }, desc = "Leap Backward to" },
      { "gs", mode = { "n", "x", "o" }, desc = "Leap from Windows" },
    },
    config = function(_, opts)
      local leap = require("leap")
      for k, v in pairs(opts) do
        leap.opts[k] = v
      end
      leap.add_default_mappings(true)
      vim.keymap.del({ "x", "o" }, "x")
      vim.keymap.del({ "x", "o" }, "X")
    end,
  },
  -- command line middle! + notify
  {
    "rcarriga/nvim-notify",
    opts = {
      background_colour = "#000000",
      render = "minimal",
      stages = "fade",
      timeout = 2000,
    },
  },
  {
    "folke/noice.nvim",
    event = { "VeryLazy" },
    opts = {
      lsp = {
        -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
        override = {
          ["vim.lsp.util.convert_input_to_mhellarkdown_lines"] = true,
          ["vim.lsp.util.stylize_markdown"] = true,
          ["cmp.entry.get_documentation"] = true, -- requires hrsh7th/nvim-cmphello bro
        },
        hover = { enabled = false },              -- <-- HERE!
        signature = { enabled = false },          -- <-- HERE!
      },
      -- you can enable a preset for easier configuration
      presets = {
        bottom_search = true,         -- use a classic bottom cmdline for search
        command_palette = true,       -- position the cmdline and popupmenu together
        long_message_to_split = true, -- long messages will be sent to a split
        inc_rename = false,           -- enables an input dialog for inc-rename.nvim
        lsp_doc_border = false,       -- add a border to hover docs and signature help
      },
    },
    dependencies = {
      "hrsh7th/nvim-cmp",
      "hrsh7th/cmp-cmdline",
      "MunifTanjim/nui.nvim",
      "rcarriga/nvim-notify",
    }
  },
  -- null-ls
  {
    "jose-elias-alvarez/null-ls.nvim",
    opts = function()
      return require "custom.configs.null-ls"
    end,
  },

  -- mason
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        "clangd",
        "clang-format",
        "codelldb",
      }
    }
  },

  -- Competitest (for C++)
  {
    "xeluxee/competitest.nvim",
    requires = "MunifTanjim/nui.nvim",
    ft = 'cpp',
    opts = function()
      return require "custom.configs.competitest"
    end,
  },
  -- LSP
  {
    lazy = true,
    "neovim/nvim-lspconfig",
    config = function()
      require "plugins.configs.lspconfig"
      require "custom.configs.lspconfig"
    end,
  },
}

return lazy_plugins
