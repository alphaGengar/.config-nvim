-- lsp.lua
local lspconfig = require("lspconfig")
local cmp_nvim_lsp = require("cmp_nvim_lsp")

-- LSP capabilities
local function get_capabilities()
  local capabilities = cmp_nvim_lsp.default_capabilities()
  capabilities.textDocument.completion.completionItem = {
    snippetSupport = true,
    preselectSupport = true,
    insertReplaceSupport = true,
    labelDetailsSupport = true,
    deprecatedSupport = true,
    commitCharactersSupport = true,
    documentationFormat = { "markdown", "plaintext" },
  }
  return capabilities
end

-- LSP on_attach function (key mappings and diagnostics)
local function on_attach(client, bufnr)
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local opts = { noremap = true, silent = true }

  -- LSP keymaps
  local keymaps = {
    ["gD"] = "vim.lsp.buf.declaration()",
    ["gd"] = "vim.lsp.buf.definition()",
    ["K"] = "vim.lsp.buf.hover()",
    ["gi"] = "vim.lsp.buf.implementation()",
    ["<C-k>"] = "vim.lsp.buf.signature_help()",
    ["<space>wa"] = "vim.lsp.buf.add_workspace_folder()",
    ["<space>wr"] = "vim.lsp.buf.remove_workspace_folder()",
    ["<space>wl"] = "print(vim.inspect(vim.lsp.buf.list_workspace_folders()))",
    ["<space>D"] = "vim.lsp.buf.type_definition()",
    ["<space>ra"] = "vim.lsp.buf.rename()",
    ["gr"] = "vim.lsp.buf.references()",
    ["<space>z"] = "vim.diagnostic.open_float()",
    ["[d"] = "vim.diagnostic.goto_prev()",
    ["]d"] = "vim.diagnostic.goto_next()",
    ["<space>q"] = "vim.diagnostic.setloclist()",
  }

  for key, cmd in pairs(keymaps) do
    buf_set_keymap("n", key, string.format("<cmd>lua %s<CR>", cmd), opts)
  end

  -- Document highlight
  if client.server_capabilities.documentHighlightProvider then
    vim.api.nvim_exec([[
      augroup lsp_document_highlight
        autocmd! * <buffer>
        autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
        autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
      augroup END
    ]], false)
  end

  -- Diagnostic signs

  vim.diagnostic.config({
  signs = {
    severity = {
      min = vim.diagnostic.severity.HINT,
      max = vim.diagnostic.severity.ERROR,
    },
    values = {
      Error = " ",
      Warn  = " ",
      Hint  = " ",
      Info  = " ",
    },
  },
  virtual_text = true,
  underline = true,
  update_in_insert = false,
  float = { border = "rounded" },
})

  -- Diagnostic popup
  vim.api.nvim_create_autocmd("CursorHold", {
    buffer = bufnr,
    callback = function()
      vim.diagnostic.open_float(nil, {
        focusable = false,
        close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
        border = "rounded",
        source = "always",
        prefix = " ",
        scope = "cursor",
      })
    end
  })
end

-- Server configurations
local server_configs = {
  clangd = {
    filetypes = { "cpp" },
    init_options = {
      clangdFileStatus = true,
      fallbackFlags = {
        "-std=c++17",
        "-I/opt/homebrew/Cellar/gcc/14.2.0_1/include/c++/14",
        "-I/opt/homebrew/Cellar/gcc/14.2.0_1/include/c++/14/aarch64-apple-darwin23",
        "-I/opt/homebrew/Cellar/gcc/14.2.0_1/include/c++/14/backward",
        "-I/opt/homebrew/Cellar/gcc/14.2.0_1/include",
        "-I/opt/homebrew/Cellar/gcc/14.2.0_1/include-fixed",
        "-I/Library/Developer/CommandLineTools/SDKs/MacOSX14.sdk/usr/include",
        "-I/Library/Developer/CommandLineTools/usr/include/c++/v1",
        "-I/Library/Developer/CommandLineTools/usr/include",
        "-I/usr/local/include",
        "-I/usr/include",
      },
    },
  },

  bashls = {

    filetypes = { "sh", "bash", "zsh" }
  },

  ruff = { filetypes = { "python" } },
  pyright = { filetypes = { "python" } },
  jdtls = { filetypes = { "java" } },
  lua_ls = {
    settings = {
      Lua = {
        diagnostics = { globals = { "vim" } },
        workspace = {
          library = {
            [vim.fn.expand("$VIMRUNTIME/lua")] = true,
            [vim.fn.stdpath("config") .. "/lua"] = true,
          },
        },
        format = { enable = true },
      },
    },
  },

  html = {
    filetypes = { "html" },
  },
  cssls = {
    filetypes = { "css", "scss", "less" },
  },
  ts_ls = {
    filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
  },
  emmet_ls = {
    filetypes = {
      "html", "css", "scss", "javascriptreact", "typescriptreact"
    },
    init_options = {
      html = { options = { ["bem.enabled"] = true } },
    },
  },
  jsonls = {
    filetypes = { "json", "jsonc" },
  },
}

-- Setup for LSP servers
for _, server in ipairs({ "clangd", "ruff", "pyright", "lua_ls", "jdtls", "bashls", "html", "cssls", "ts_ls", "emmet_ls", "jsonls" }) do
  lspconfig[server].setup({
    on_attach = on_attach,
    capabilities = get_capabilities(),
    settings = server_configs[server],
  })
end
