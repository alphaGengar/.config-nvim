local lazy_plugins = {

  {
    lazy = true,
    event = "VeryLazy",
    'romgrk/barbar.nvim',
    dependencies = {
      'lewis6991/gitsigns.nvim', -- OPTIONAL: for git status
      'nvim-tree/nvim-web-devicons', -- OPTIONAL: for file icons
    },
    init = function() vim.g.barbar_auto_setup = false end,
    opts = function()
      require("configs.barbar")
    end
  },
  -- UI Enhancements
  {
    'nvim-lualine/lualine.nvim',
    lazy = false,
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      require("configs.lualine")
    end
  },

  {
    "rcarriga/nvim-notify",
    event = "VeryLazy",
    opts = function()
      return require("configs.notify")
    end
  },

  {
    "folke/noice.nvim",
    event = "VeryLazy",
    dependencies = {
      "hrsh7th/nvim-cmp",
      "hrsh7th/cmp-cmdline",
      "MunifTanjim/nui.nvim",
      "rcarriga/nvim-notify",
    },
    opts = function()
      return require("configs.noice")
    end
  },

  -- Navigation
  {
    "ggandor/leap.nvim",
    enabled = true,
    keys = {
      { "s",  mode = { "n", "x", "o" }, desc = "Leap Forward to" },
      { "S",  mode = { "n", "x", "o" }, desc = "Leap Backward to" },
      { "gs", mode = { "n", "x", "o" }, desc = "Leap from Windows" },
    },
    opts = function()
      return require("configs.leap")
    end
  },

  -- LSP and Code Quality
  {
    "neovim/nvim-lspconfig",
    lazy = false,
    event = "VeryLazy",
    config = function()
      require("configs.lspconfig")
    end,
  },

  {
    "jose-elias-alvarez/null-ls.nvim",
    event = "VeryLazy",
    opts = function()
      return require("configs.null-ls")
    end,
  },

  {
    'https://git.sr.ht/~whynothugo/lsp_lines.nvim',
    event = 'LspAttach',
    opts = {},
  },

  -- Package Management
  {
    "williamboman/mason.nvim",
    event = "VeryLazy",
    opts = function()
      return require("configs.mason")
    end
  },

  -- Development Tools
  {
    'ptdewey/yankbank-nvim',
    dependencies = 'kkharji/sqlite.lua',
    lazy = false,
    opts = function()
      return require("configs.yankbank")
    end
  },

  {
    "kawre/leetcode.nvim",
    lazy = true,
    cmd = "Leet",
    build = ":TSUpdate html",
    dependencies = {
      "nvim-telescope/telescope.nvim",
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      "nvim-treesitter/nvim-treesitter",
      "nvim-tree/nvim-web-devicons",
    },
    opts = function()
      return require("configs.leetcode")
    end
  },

  {
    "xeluxee/competitest.nvim",
    event = "VeryLazy",
    requires = "MunifTanjim/nui.nvim",
    ft = "cpp",
    opts = function()
      return require("configs.competitest")
    end,
  },

  -- Misc
  {
    "vyfor/cord.nvim",
    build = "./build || .\\build",
    event = "VeryLazy",
    opts = {},
  },
}

return lazy_plugins
