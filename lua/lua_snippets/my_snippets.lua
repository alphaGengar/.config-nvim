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
    "frpn",
    fmt(
      [[
#ifndef LOCAL
    freopen("{}.in", "r", stdin);
    freopen("{}.out", "w", stdout);
#endif
      ]],
      {
        i(1),
        rep(1),
      }
    )
  ),
  s(
    "fastio",
    fmt(
      [[
ios_base::sync_with_stdio(false);
cin.tie(NULL);
      ]],
      {}
    )
  ),
  s(
    "tcs",
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
