local M = {}

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

  -- Custom snippets
  local ls = require "luasnip"
  local s = ls.snippet
  local i = ls.insert_node
  local rep = require("luasnip.extras").rep
  local fmt = require("luasnip.extras.fmt").fmt

  -- Define C++ snippets
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
          i(1), -- Placeholder for the loop body
        }
      )
    ),
    s(
      "vin", -- Snippet trigger for vector input
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
      "vout", -- Snippet trigger for vector output
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
end

return M
