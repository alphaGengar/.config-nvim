local M = {}

M.keys = {
  { "s",  mode = { "n", "x", "o" }, desc = "Leap Forward to" },
  { "S",  mode = { "n", "x", "o" }, desc = "Leap Backward to" },
  { "gs", mode = { "n", "x", "o" }, desc = "Leap from Windows" },
}

function M.config(_, opts)
  local leap = require("leap")

  -- Apply user options
  for k, v in pairs(opts or {}) do
    leap.opts[k] = v
  end

  -- Setup mappings
  leap.add_default_mappings(true)

  -- Remove conflicting mappings
  vim.keymap.del({ "x", "o" }, "x")
  vim.keymap.del({ "x", "o" }, "X")
end

return M

