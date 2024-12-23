local lazy_plugins = {
  -- UI Enhancements
  {
    'nvim-lualine/lualine.nvim',
    lazy = false,
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

  {
    'goolord/alpha-nvim',
    event = "VimEnter",
    config = function()
      require("configs.alpha")
    end
  },

  -- Navigation
  {
    "ggandor/leap.nvim",
    enabled = true,
    opts = function()
      return require("configs.leap")
    end
  },

  -- LSP and Code Quality
  {
    lazy = true,
    event = "LspAttach",
    "aznhe21/actions-preview.nvim",
    config = function()
      require("configs.code_actions")
    end,
  },

  {
    "neovim/nvim-lspconfig",
    event = "InsertEnter",
    ft = { "lua", "cpp", "python", "zsh", "sh", "java" },
    config = function()
      require("configs.lspconfig")
    end,
  },

  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    config = function()
      require("configs.cmp")
    end,
  },

  {
    "L3MON4D3/LuaSnip",
    event = "InsertEnter",
    dependencies = { "rafamadriz/friendly-snippets" },
    config = function()
      require("luasnip.loaders.from_lua").load({ paths = vim.fn.stdpath("config") .. "/lua/lua_snippets" })
      require("luasnip.loaders.from_vscode").lazy_load()
    end,
  },

  {
    "rafamadriz/friendly-snippets",
    lazy = true,
  },

  {
    "saadparwaiz1/cmp_luasnip",
    event = "InsertEnter",
  },

  {
    "hrsh7th/cmp-nvim-lsp",
    event = "InsertEnter",
  },

  {
    "hrsh7th/cmp-buffer",
    event = "InsertEnter",
  },

  {
    "hrsh7th/cmp-path",
    event = "InsertEnter",
  },

  -- {
  --   'https://git.sr.ht/~whynothugo/lsp_lines.nvim',
  --   event = 'LspAttach',
  --   opts = {},
  -- },

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
    lazy = true,
    event = "VeryLazy",
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
  -- {
  --   "vyfor/cord.nvim",
  --   build = "./build || .\\build",
  --   event = "VeryLazy",
  --   opts = {},
  -- },
}

return lazy_plugins
