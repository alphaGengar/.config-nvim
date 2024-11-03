local lspconfig = require("lspconfig")
local cmp = require("cmp")
local luasnip = require("luasnip")

-- Set up LuaSnip
vim.g.lua_snippets_path = vim.fn.stdpath("config") .. "/lua/lua_snippets"
require("luasnip.loaders.from_lua").load({ paths = vim.g.lua_snippets_path })
require("luasnip.loaders.from_vscode").lazy_load()

-- Set up notification system if notify is available
local has_notify, notify = pcall(require, "notify")
local notify_opts = {
  title = "LSP",
  timeout = 1000,
  render = "minimal",
}

-- Progress tracking table
local progress_messages = {}

-- LSP Progress handler with notifications
vim.lsp.handlers["$/progress"] = function(err, result, ctx)
  local lsp_client = vim.lsp.get_client_by_id(ctx.client_id)
  if not lsp_client or err then return end
  local token = result.token
  local value = result.value
  if not token or not value then return end
  -- Track progress messages
  progress_messages[token] = progress_messages[token] or {}
  local progress = progress_messages[token]
  -- Update progress data
  progress.title = value.title or progress.title
  progress.message = value.message or progress.message
  progress.percentage = value.percentage or progress.percentage
  progress.client = lsp_client.name
  -- Handle different progress states
  if value.kind then
    if value.kind == "begin" then
      -- New progress started
      local msg = string.format("%s: %s", progress.client, progress.title or "")
      if has_notify then
        notify(msg, "info", notify_opts)
      end
    elseif value.kind == "report" and progress.percentage then
      -- Progress update
      local msg = string.format("%s: %s %.0f%%",
        progress.client,
        progress.title or "",
        progress.percentage
      )
      if has_notify and progress.percentage % 20 == 0 then -- notify every 20%
        notify(msg, "info", notify_opts)
      end
    elseif value.kind == "end" then
      -- Progress completed
      local msg = string.format("%s: %s complete", progress.client, progress.title or "")
      if has_notify then
        notify(msg, "success", notify_opts)
      end
      -- Clear the progress data
      progress_messages[token] = nil
    end
  end
end

-- Get LSP capabilities with additional settings
local capabilities = require("cmp_nvim_lsp").default_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true
capabilities.textDocument.completion.completionItem.preselectSupport = true
capabilities.textDocument.completion.completionItem.insertReplaceSupport = true
capabilities.textDocument.completion.completionItem.labelDetailsSupport = true
capabilities.textDocument.completion.completionItem.deprecatedSupport = true
capabilities.textDocument.completion.completionItem.commitCharactersSupport = true
capabilities.textDocument.completion.completionItem.documentationFormat = { "markdown", "plaintext" }

-- Define common on_attach function with keymaps and highlighting
local function on_attach(client, bufnr)
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

  -- Enable completion triggered by <c-x><c-o>
  buf_set_option("omnifunc", "v:lua.vim.lsp.omnifunc")

  -- Mappings
  local opts = { noremap = true, silent = true }

  -- See `:help vim.lsp.*` for documentation on any of the below functions
  buf_set_keymap("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", opts)
  buf_set_keymap("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", opts)
  buf_set_keymap("n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", opts)
  buf_set_keymap("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts)
  buf_set_keymap("n", "<C-k>", "<cmd>lua vim.lsp.buf.signature_help()<CR>", opts)
  buf_set_keymap("n", "<space>wa", "<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>", opts)
  buf_set_keymap("n", "<space>wr", "<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>", opts)
  buf_set_keymap("n", "<space>wl", "<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>", opts)
  buf_set_keymap("n", "<space>D", "<cmd>lua vim.lsp.buf.type_definition()<CR>", opts)
  buf_set_keymap("n", "<space>ra", "<cmd>lua vim.lsp.buf.rename()<CR>", opts)
  buf_set_keymap("n", "<space>ca", "<cmd>lua vim.lsp.buf.code_action()<CR>", opts)
  buf_set_keymap("n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", opts)
  buf_set_keymap("n", "<space>e", "<cmd>lua vim.diagnostic.open_float()<CR>", opts)
  buf_set_keymap("n", "[d", "<cmd>lua vim.diagnostic.goto_prev()<CR>", opts)
  buf_set_keymap("n", "]d", "<cmd>lua vim.diagnostic.goto_next()<CR>", opts)
  buf_set_keymap("n", "<space>q", "<cmd>lua vim.diagnostic.setloclist()<CR>", opts)

  -- Set autocommands conditional on server capabilities
  if client.server_capabilities.documentHighlightProvider then
    vim.api.nvim_exec([[
            augroup lsp_document_highlight
                autocmd! * <buffer>
                autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
                autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
            augroup END
        ]], false)
  end

  -- Set diagnostic signs
  local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }
  for type, icon in pairs(signs) do
    local hl = "DiagnosticSign" .. type
    vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
  end

  -- Show diagnostic popup on cursor hold
  vim.api.nvim_create_autocmd("CursorHold", {
    buffer = bufnr,
    callback = function()
      local float_opts = {
        focusable = false,
        close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
        border = "rounded",
        source = "always",
        prefix = " ",
        scope = "cursor",
      }
      vim.diagnostic.open_float(nil, float_opts)
    end
  })
end

-- Server-specific configurations
local server_configs = {
  clangd = {
    filetypes = { "cpp" },
    settings = {
      clangd = {
        fallbackFlags = {
          "--std=c++17",
          "--style={BasedOnStyle: Google, IndentWidth: 4}" },
      },
    },
  },
  ruff_lsp = {
    filetypes = { "python" },
  },
  pyright = {
    filetypes = { "python" },
  },
  jdtls = {
    filetypes = { "java" },
  },
  lua_ls = {
    settings = {
      Lua = {
        diagnostics = {
          globals = { "vim" },
        },
        workspace = {
          library = {
            [vim.fn.expand("$VIMRUNTIME/lua")] = true,
            [vim.fn.stdpath("config") .. "/lua"] = true,
          },
        },
        format = {
          enable = true,
        },
      },
    },
  },
}

-- Set up LSP servers
local servers = {
  "clangd",
  "ruff_lsp",
  "pyright",
  "lua_ls",
  "jdtls",
}

-- Deep merge function for tables
local function deep_merge(t1, t2)
  for k, v in pairs(t2) do
    if type(v) == "table" and type(t1[k]) == "table" then
      deep_merge(t1[k], v)
    else
      t1[k] = v
    end
  end
  return t1
end

-- Configure each server
for _, server in ipairs(servers) do
  local config = {
    on_attach = function(client, bufnr)
      client.server_capabilities.signatureHelpProvider = false
      on_attach(client, bufnr)
    end,
    capabilities = capabilities,
  }

  -- Merge server-specific config if it exists
  if server_configs[server] then
    config = deep_merge(config, server_configs[server])
  end

  lspconfig[server].setup(config)
end

cmp.setup({
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  preselect = cmp.PreselectMode.None,     -- Disable preselection
  completion = {
    completeopt = 'menu,menuone,noselect' -- Disable automatic selection
  },
  mapping = cmp.mapping.preset.insert({
    -- Tab to select
    ['<Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end, { 'i', 's' }),
    -- Shift+Tab to go back
    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { 'i', 's' }),
    ['<CR>'] = cmp.mapping.confirm({ select = false }), -- Only confirm explicitly selected items
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.abort(),
    ['<C-d>'] = cmp.mapping.scroll_docs(4),
    ['<C-u>'] = cmp.mapping.scroll_docs(-4),
  }),
  sources = cmp.config.sources({
    { name = 'nvim_lsp', max_item_count = 5 },
    { name = 'luasnip',  max_item_count = 5 },
    { name = 'path',     max_item_count = 5 },
  }, {
    { name = 'buffer', max_item_count = 10 },
  }),
  formatting = {
    format = function(entry, vim_item)
      -- Source
      vim_item.menu = ({
        buffer = "[Buffer]",
        nvim_lsp = "[LSP]",
        luasnip = "[Snippet]",
        path = "[Path]",
      })[entry.source.name]
      return vim_item
    end
  },
  experimental = {
    ghost_text = true, -- Show ghost text as you type
  },
  window = {
    completion = cmp.config.window.bordered(),
    documentation = cmp.config.window.bordered(),
  },
})

-- Configure cmp for cmdline
local cmdline_mapping = cmp.mapping.preset.cmdline()

-- Set up completion for search (/)
cmp.setup.cmdline("/", {
  mapping = cmdline_mapping,
  sources = {
    { name = "buffer" },
  },
})

-- Set up completion for commands (:)
cmp.setup.cmdline(":", {
  mapping = cmdline_mapping,
  sources = cmp.config.sources(
    {
      { name = "path" },
    },
    {
      {
        name = "cmdline",
        option = {
          ignore_cmds = { "Man", "!" },
        },
      },
    }
  ),
})
