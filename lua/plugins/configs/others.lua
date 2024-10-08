local M = {}
local utils = require "core.utils"

M.blankline = {
  indentLine_enabled = 1,
  filetype_exclude = {
    "help",
    "terminal",
    "lazy",
    "lspinfo",
    "TelescopePrompt",
    "TelescopeResults",
    "mason",
    "nvdash",
    "nvcheatsheet",
    "",
  },
  buftype_exclude = { "terminal" },
  show_trailing_blankline_indent = true,
  show_first_indent_level = true,
  show_current_context = true,
  show_current_context_start = false,
}

M.luasnip = function(opts)
  require("luasnip").config.set_config(opts)

  -- vscode format
  require("luasnip.loaders.from_vscode").lazy_load()
  require("luasnip.loaders.from_vscode").lazy_load { paths = vim.g.vscode_snippets_path or "" }

  -- snipmate format
  require("luasnip.loaders.from_snipmate").load()
  require("luasnip.loaders.from_snipmate").lazy_load { paths = vim.g.snipmate_snippets_path or "" }

  -- lua format
  require("luasnip.loaders.from_lua").load()
  require("luasnip.loaders.from_lua").lazy_load { paths = vim.g.lua_snippets_path or "" }

  -- custom snipptets
  local ls = require "luasnip"
  local s = ls.snippet
  local i = ls.insert_node
  local rep = require("luasnip.extras").rep
  local fmt = require("luasnip.extras.fmt").fmt


  ls.add_snippets("cpp", {
    s(
      "frpn", -- Snippet trigger
      fmt(    -- Format the snippet
        [[
#ifndef LOCAL
    freopen("{}.in", "r", stdin);
    freopen("{}.out", "w", stdout);
#endif
      ]],
        {
          i(1),   -- Placeholder for input file name
          rep(1), -- Repeat the placeholder for output file name
        }
      )
    ),
    s(
      "fastio", -- Snippet trigger
      fmt(      -- Format the snippet
        [[
ios_base::sync_with_stdio(false);
cin.tie(NULL);
      ]],
        {} -- No placeholders or transformations needed
      )
    ),
    s(
      "tcs", -- Snippet trigger
      fmt(
        [[
  int t; cin >> t;
  while(t--){{
    {}
  }}
      ]],
        {
          i(1),
        }
      )
    ),
    s(
      "vin",
      fmt(
        [[

template <typename S>
istream &operator>>(istream &is, vector<S> &vec) 
{{
  for (auto &element : vec) {{
    is >> element;
  }}
  return is;
}}
        ]],
        {}
      )
    ),
    s(
      "vout",
      fmt(
        [[
template <typename S>
ostream& operator<<(ostream& os, const vector<S>& vector)
{{
    for (auto element : vector) {{
        os << element << " ";
    }}
    return os;
}}
        ]],
        {}
      )
    ),
  })

  vim.api.nvim_create_autocmd("InsertLeave", {
    callback = function()
      if
          require("luasnip").session.current_nodes[vim.api.nvim_get_current_buf()]
          and not require("luasnip").session.jump_active
      then
        require("luasnip").unlink_current()
      end
    end,
  })
end

M.gitsigns = {
  signs = {
    add = { text = "│" },
    change = { text = "│" },
    delete = { text = "󰍵" },
    topdelete = { text = "‾" },
    changedelete = { text = "~" },
    untracked = { text = "│" },
  },
  on_attach = function(bufnr)
    utils.load_mappings("gitsigns", { buffer = bufnr })
  end,
}

return M
