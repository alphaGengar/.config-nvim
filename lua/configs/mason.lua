local M = {
  ensure_installed = {
    -- cpp
    "clangd",
    "clang-format",

    -- python
    "black",
    "debugpy",
    "ruff-lsp",
    "pyright",

    -- lua
    "lua_language_server",
  },
}

M.config = function(_, opts)
  require("mason").setup(opts)
  vim.api.nvim_create_user_command("MasonInstallAll", function()
    vim.cmd("MasonInstall " .. table.concat(opts.ensure_installed, " "))
  end, {})
  vim.g.mason_binaries_list = opts.ensure_installed
end

return M
