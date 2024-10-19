local lspconfig = require "lspconfig"

-- Define on_attach function directly if needed
local on_attach = function(client, bufnr)
    -- Your on_attach logic here
end

-- Load LuaSnip
local ls = require("luasnip")

-- Set LuaSnip snippet path for Lua snippets
vim.g.lua_snippets_path = vim.fn.stdpath "config" .. "/lua/lua_snippets"

-- Load your Lua snippets
require("luasnip.loaders.from_lua").load({ paths = vim.g.lua_snippets_path })

vim.lsp.handlers["$/progress"] = function(_, result, ctx)
    local lsp_client = vim.lsp.get_client_by_id(ctx.client_id)
    -- Customize or suppress messages based on result and client.
end

-- Get capabilities from cmp_nvim_lsp
local capabilities = require("cmp_nvim_lsp").default_capabilities()

-- Rest of your configuration...
local servers = {
    "clangd",
    "ruff_lsp",
    "pyright",
    "lua_ls", -- Add lua-language-server to the list
    "jdtls"
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
    filetypes = { "cpp" },
    settings = {
        clangd = {
            fallbackFlags = { "--style={BasedOnStyle: Google, IndentWidth: 4}" },
        },
    },
}

lspconfig.ruff_lsp.setup {
    filetypes = { "python" },
}

lspconfig.pyright.setup {
    filetypes = { "python" },
}

lspconfig.jdtls.setup {
    filetypes = { "java" }
}

-- Add specific configuration for Lua
lspconfig.lua_ls.setup {
    settings = {
        Lua = {
            diagnostics = {
                globals = { 'vim' }, -- Recognize 'vim' as a global variable
            },
            workspace = {
                library = {
                    [vim.fn.expand('$VIMRUNTIME/lua')] = true,
                    [vim.fn.stdpath('config') .. '/lua'] = true,
                },
            },
            format = {
                enable = true, -- Enable formatting capabilities for Lua
            },
        },
    },
    on_attach = on_attach,
    capabilities = capabilities,
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
