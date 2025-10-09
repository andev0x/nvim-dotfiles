-- ~/.config/nvim/lua/anvndev/plugins/lsp/servers.lua
-- LSP servers configuration

-- Mason setup
local mason = require("mason")
local mason_lspconfig = require("mason-lspconfig")
local mason_tool_installer = require("mason-tool-installer")

mason.setup({
  ui = {
    border = "rounded",
    icons = {
      package_installed = "✓",
      package_pending = "➜",
      package_uninstalled = "✗",
    },
  },
})

-- Define tools to install (LSP servers, formatters, linters, debuggers)
local tools = {
  -- LSP servers
  "gopls",
  "rust-analyzer",
  "clangd",
  "pyright",
  "lua-language-server",
  "typescript-language-server",
  "html-lsp",
  "css-lsp",
  "json-lsp",
  "yaml-language-server",
  "dockerfile-language-server",

  -- Formatters
  "gofumpt",
  "goimports",
  "rustfmt",
  "clang-format",
  "black",
  "isort",
  "stylua",
  "prettier",

  -- Linters
  "golangci-lint",
  "flake8",
  "mypy",
  "luacheck",
  "eslint_d",

  -- Debuggers
  "delve",     -- Go
  "codelldb",  -- Rust, C/C++
  "debugpy",   -- Python
}

-- Ensure tools are installed
mason_tool_installer.setup({
  ensure_installed = tools,
  auto_update = true,
  run_on_start = true,
})

-- LSP servers and custom settings
local servers = {
  gopls = {},
  rust_analyzer = {},
  clangd = {},
  pyright = {},
  tsserver = {}, -- fixed from ts_ls
  html = {},
  cssls = {},
  jsonls = {},
  yamlls = {},
  dockerls = {},
  lua_ls = {
    settings = {
      Lua = {
        workspace = { checkThirdParty = false },
        telemetry = { enable = false },
        diagnostics = { globals = { "vim" } },
      },
    },
  },
}

-- LSP capabilities (for autocompletion)
local capabilities = require("cmp_nvim_lsp").default_capabilities()

-- Function called when an LSP connects to a buffer
local on_attach = function(client, bufnr)
  -- Enable omnifunc completion
  vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

  -- Enable inlay hints if supported
  if client.server_capabilities.inlayHintProvider then
    vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
  end

  -- Enable breadcrumbs (nvim-navic) if supported
  if client.server_capabilities.documentSymbolProvider then
    local navic_ok, navic = pcall(require, "nvim-navic")
    if navic_ok then
      navic.attach(client, bufnr)
    end
  end
end

-- Setup all LSP servers using mason-lspconfig
mason_lspconfig.setup({
  ensure_installed = vim.tbl_keys(servers),
})

mason_lspconfig.setup_handlers({
  function(server_name)
    local server_opts = servers[server_name] or {}
    require("lspconfig")[server_name].setup({
      capabilities = capabilities,
      on_attach = on_attach,
      settings = server_opts.settings or {},
      filetypes = server_opts.filetypes,
    })
  end,
})
