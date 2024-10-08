local lazy_plugins = {
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
  {
    'vyfor/cord.nvim',
    build = './build || .\\build',
    event = 'VeryLazy',
    opts = {}, -- calls require('cord').setup()
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
    }
  },
  -- null-ls
  {
    event = "VeryLazy",
    "jose-elias-alvarez/null-ls.nvim",
    opts = function()
      return require "custom.configs.null-ls"
    end,
  },

  -- mason
  {
    event = "VeryLazy",
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        -- cpp
        "clangd",
        "clang-format",
        "codelldb",
        -- python
        "black",
        "debugpy",
        "ruff-lsp",
        "pyright",
      }
    }
  },

  -- Competitest (for C++)
  {
    event = "VeryLazy",
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
    event = "VeryLazy",
    "neovim/nvim-lspconfig",
    config = function()
      require "plugins.configs.lspconfig"
      require "custom.configs.lspconfig"
    end,
  },
}

return lazy_plugins
