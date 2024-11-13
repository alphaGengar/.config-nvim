-- Load NvChad base mappings
require "nvchad.mappings"

-- Mapping helper function
local function map(mode, lhs, rhs, opts)
  opts = opts or {}
  opts.silent = opts.silent ~= false
  vim.keymap.set(mode, lhs, rhs, opts)
end

vim.keymap.set({ "v", "n" }, "<leader>ca", require("actions-preview").code_actions)

-- Organize mappings by category
local M = {}

M.general = {
  {
    mode = "n",
    mappings = {
      [";"] = { ":", desc = "CMD enter command mode" },
      ["<leader>n"] = { "<cmd> set nu! <CR>", desc = "Toggle line number" },
      ["<leader>b"] = { "<cmd> enew <CR>", desc = "New buffer" },
      ["<leader>ch"] = { "<cmd> NvCheatsheet <CR>", desc = "Mapping cheatsheet" },
      ["<C-c>"] = { "<cmd> %y+ <CR>", desc = "Copy whole file" },
    }
  },
  {
    mode = "i",
    mappings = {
      ["jk"] = { "<ESC>", desc = "Exit insert mode" },
    }
  }
}

-- LSP related mappings
M.lsp = {
  {
    mode = "n",
    mappings = {
      ["<leader>ra"] = {
        ':lua require("nvchad.lsp.renamer")()<CR>',
        desc = "LSP Rename",
      },
      ["<leader>fm"] = {
        function()
          vim.lsp.buf.format { async = true }
        end,
        desc = "LSP formatting",
      },
    }
  }
}

-- Competitive Programming mappings (CompetiTest plugin)
M.competitive = {
  {
    mode = "n",
    mappings = {
      ["<leader>cta"] = {
        ":CompetiTest add_testcase<Space><CR>",
        desc = "Add Testcase",
      },
      ["<leader>cte"] = {
        ":CompetiTest edit_testcase<Space><CR>",
        desc = "Edit Testcase",
      },
      ["<leader>ctr"] = {
        ":CompetiTest run<Space><CR>",
        desc = "Run Testcases",
      },
      ["<leader>ctc"] = {
        ":CompetiTest receive contest<Space><CR>",
        desc = "Receive Contest",
      },
      ["<leader>ctp"] = {
        ":CompetiTest receive problem<Space><CR>",
        desc = "Receive Problem",
      },
      ["<leader>ctg"] = {
        ":CompetiTest receive testcases<Space><CR>",
        desc = "Receive Testcases",
      },
      ["<leader>cf"] = {
        ":lua CopyCurrentFileName()<CR>",
        desc = "Copy File Name",
      },
    }
  }
}

-- LeetCode mappings (Leet.nvim plugin)
M.leetcode = {
  {
    mode = "n",
    mappings = {
      ["<leader>leet"] = {
        "<cmd>Leet<CR>",
        desc = "Leet Dashboard",
      },
      ["<leader>lq"] = {
        "<cmd>Leet exit<CR>",
        desc = "Close Leet",
      },
      ["<leader>lrq"] = {
        "<cmd>Leet random<CR>",
        desc = "Random Question",
      },
      ["<leader>lre"] = {
        "<cmd>Leet random difficulty=easy<CR>",
        desc = "Random Easy Question",
      },
      ["<leader>lrm"] = {
        "<cmd>Leet random difficulty=medium<CR>",
        desc = "Random Medium Question",
      },
      ["<leader>lrh"] = {
        "<cmd>Leet random difficulty=hard<CR>",
        desc = "Random Hard Question",
      },
      ["<leader>lx"] = {
        "<cmd>Leet reset<CR>",
        desc = "Reset Question",
      },
      ["<leader>ld"] = {
        "<cmd>Leet desc<CR>",
        desc = "Toggle Description",
      },
    }
  }
}

-- Utility mappings
M.utils = {
  {
    mode = "n",
    mappings = {
      ["<leader>dn"] = {
        ":lua require('notify').dismiss()<CR>",
        desc = "Dismiss Notifications",
      },
      ["<leader>tt"] = {
        function()
          require("base46").toggle_transparency()
        end,
        desc = "Toggle transparency",
      },
    }
  }
}

-- YankBank mappings
M.yankbank = {
  {
    mode = "n",
    mappings = {
      ["<leader>pp"] = {
        "<cmd>:YankBank<CR>",
        desc = "Yank Clipboard",
      },
      ["<leader>pc"] = {
        "<cmd>:YankBankClearDB<CR>",
        desc = "Clear YankBank History",
      },
    }
  }
}

-- Apply all mappings
local function load_mappings()
  for _, category in pairs(M) do
    for _, mapping_group in ipairs(category) do
      for lhs, mapping_info in pairs(mapping_group.mappings) do
        local rhs = mapping_info[1]
        local opts = {
          desc = mapping_info.desc or "No description"
        }

        -- Merge any additional options
        if mapping_info.opts then
          opts = vim.tbl_extend("force", opts, mapping_info.opts)
        end

        map(mapping_group.mode, lhs, rhs, opts)
      end
    end
  end
end

-- Initialize mappings
load_mappings()

-- Export mappings table for potential external use
return M
