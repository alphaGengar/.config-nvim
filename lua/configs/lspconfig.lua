
local lspconfig = require "lspconfig"

-- Define on_attach function directly if needed
local on_attach = function(client, bufnr)
  -- Your on_attach logic here
end

-- Get capabilities from cmp_nvim_lsp
local capabilities = require("cmp_nvim_lsp").default_capabilities()

-- Rest of your configuration...
local servers = {
  "clangd",
  "ruff_lsp",
  "pyright",
}

for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup {
    on_attach = function(client, bufnr)
      client.server_capabilities.signatureHelpProvider = false
      on_attach(client, bufnr)
    end,
    capabilities = capabilities,
  }
end

-- Specific configurations for each server
lspconfig.clangd.setup {
  filetypes = {"cpp"},
}

lspconfig.ruff_lsp.setup {
  filetypes = {"python"},
}

lspconfig.pyright.setup {
  filetypes = {"python"},
}

-- using cmp in the terminal
local cmp = require("cmp")

require("luasnip.loaders.from_vscode").lazy_load()

-- `/` cmdline setup.
cmp.setup.cmdline("/", {
  mapping = cmp.mapping.preset.cmdline(),
  sources = {
    { name = "buffer" },
  },
})

-- `:` cmdline setup.
cmp.setup.cmdline(":", {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({
    { name = "path" },
  }, {
      {
        name = "cmdline",
        option = {
          ignore_cmds = { "Man", "!" },
        },
      },
    }),
})

