-- Core requirements
local lspconfig = require("lspconfig")
local cmp = require("cmp")
local luasnip = require("luasnip")
local cmp_nvim_lsp = require("cmp_nvim_lsp")

-- Notification setup
-- local function setup_notifications()
--   local has_notify, notify = pcall(require, "notify")
--   if not has_notify then return nil end
--
--   return {
--     notify = notify,
--     opts = {
--       title = "LSP",
--       timeout = 1000,
--       render = "minimal",
--     }
--   }
-- end

-- LSP Progress handler
-- local function setup_progress_handler()
--   local notification = setup_notifications()
--   local progress_messages = {}
--
--   vim.lsp.handlers["$/progress"] = function(err, result, ctx)
--     if err or not result.token or not result.value then return end
--
--     local client = vim.lsp.get_client_by_id(ctx.client_id)
--     if not client then return end
--
--     local progress = progress_messages[result.token] or {}
--     progress_messages[result.token] = progress
--
--     -- Update progress data
--     progress.title = result.value.title or progress.title
--     progress.message = result.value.message or progress.message
--     progress.percentage = result.value.percentage or progress.percentage
--     progress.client = client.name
--
--     if not result.value.kind or not notification then return end
--
--     local msg
--     if result.value.kind == "begin" then
--       msg = string.format("%s: %s", progress.client, progress.title or "")
--       notification.notify(msg, "info", notification.opts)
--     elseif result.value.kind == "report" and progress.percentage and progress.percentage % 20 == 0 then
--       msg = string.format("%s: %s %.0f%%", progress.client, progress.title or "", progress.percentage)
--       notification.notify(msg, "info", notification.opts)
--     elseif result.value.kind == "end" then
--       msg = string.format("%s: %s complete", progress.client, progress.title or "")
--       notification.notify(msg, "success", notification.opts)
--       progress_messages[result.token] = nil
--     end
--   end
-- end

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

-- LSP keymaps and configuration
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
    ["<space>ca"] = "vim.lsp.buf.code_action()",
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
  local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }
  for type, icon in pairs(signs) do
    local hl = "DiagnosticSign" .. type
    vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
  end

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
      fallbackFlags = { "--std=c++17" },
    },
    settings = {
      clangd = {
        fallbackFlags = { "--std=c++17" },
      },
    },
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
}


lspconfig.lua_ls.setup({
  on_attach = function(client, bufnr)
    on_attach(client, bufnr)   -- Call the existing on_attach function with key mappings and other setup
  end,
  settings = {
    Lua = {
      diagnostics = {
        globals = { "vim" },   -- Recognize `vim` as a global variable
      },
      workspace = {
        library = {
          [vim.fn.expand("$VIMRUNTIME/lua")] = true,
          [vim.fn.stdpath("config") .. "/lua"] = true,
        },
      },
      format = { enable = true },   -- Enable formatting
    },
  },
  capabilities = get_capabilities()   -- Include the additional capabilities as well
})

-- Setup completion
local function setup_completion()
  local cmp_config = {
    snippet = {
      expand = function(args)
        luasnip.lsp_expand(args.body)
      end,
    },
    preselect = cmp.PreselectMode.None,
    completion = { completeopt = 'menu,menuone,noselect' },
    mapping = cmp.mapping.preset.insert({
      ['<Tab>'] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_next_item()
        elseif luasnip.expand_or_jumpable() then
          luasnip.expand_or_jump()
        else
          fallback()
        end
      end, { 'i', 's' }),
      ['<S-Tab>'] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_prev_item()
        elseif luasnip.jumpable(-1) then
          luasnip.jump(-1)
        else
          fallback()
        end
      end, { 'i', 's' }),
      ['<CR>'] = cmp.mapping.confirm({ select = false }),
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
        vim_item.menu = ({
          buffer = "[Buffer]",
          nvim_lsp = "[LSP]",
          luasnip = "[Snippet]",
          path = "[Path]",
        })[entry.source.name]
        return vim_item
      end
    },
    experimental = { ghost_text = true },
    window = {
      completion = cmp.config.window.bordered(),
      documentation = cmp.config.window.bordered(),
    },
  }

  cmp.setup(cmp_config)

  -- Cmdline completion
  local cmdline_mapping = cmp.mapping.preset.cmdline()
  cmp.setup.cmdline("/", {
    mapping = cmdline_mapping,
    sources = { { name = "buffer" } },
  })

  cmp.setup.cmdline(":", {
    mapping = cmdline_mapping,
    sources = cmp.config.sources(
      { { name = "path" } },
      { { name = "cmdline", option = { ignore_cmds = { "Man", "!" } } } }
    ),
  })
end

-- Initialize everything
local function init()
  -- setup_progress_handler()

  -- Helper function for merging configs
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

  -- Setup LSP servers
  local servers = { "clangd", "ruff", "pyright", "lua_ls", "jdtls" }
  for _, server in ipairs(servers) do
    local config = {
      on_attach = function(client, bufnr)
        client.server_capabilities.signatureHelpProvider = false
        on_attach(client, bufnr)
      end,
      capabilities = get_capabilities(),
    }

    if server_configs[server] then
      config = deep_merge(config, server_configs[server])
    end

    lspconfig[server].setup(config)
  end

  setup_completion()
end

vim.api.nvim_create_autocmd("FileType", {
  callback = function()
    init()
  end,
  once = true,
})
