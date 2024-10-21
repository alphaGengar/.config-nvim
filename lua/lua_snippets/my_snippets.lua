print("C++ snippets loaded")

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
