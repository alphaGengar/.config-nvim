local options = {
  formatters_by_ft = {
    lua = { "stylua" },
    -- css = { "prettier" },
    -- html = { "prettier" },
    -- Adding formatters for C++, Python, and Java
    cpp = { "clang-format" },
    c = { "clang-format" },  -- Also adding C since it often uses the same formatter as C++
    python = { "black", "isort" },  -- Using Black for code formatting and isort for import sorting
    java = { "google-java-format" },
  },
  format_on_save = {
    -- These options will be passed to conform.format()
    timeout_ms = 500,
    lsp_fallback = true,
  },
}

return options
