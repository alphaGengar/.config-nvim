return {
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
      before = {
        "#include <bits/stdc++.h>",
        '#include "./ListNode.cpp"',
        "using namespace std;",
        "#define ll long long",
        "#define all(x) x.begin(), x.end()",
      },
    },
  },
}
