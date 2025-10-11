-- ~/.config/nvim/lua/anvndev/plugins/lsp/servers.lua
-- LSP servers configuration


-- Note: mason and installer setup are handled in plugin setup (see anvndev.plugins.lsp.init).
-- Here we keep configuration minimal and idempotent to avoid startup cycles.
local ok_mason_lsp, mason_lspconfig = pcall(require, "mason-lspconfig")

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

mason_tool_installer = mason_tool_installer or {}
if ok_mti and mason_tool_installer and mason_tool_installer.setup then
  mason_tool_installer.setup({
    ensure_installed = tools,
    auto_update = true,
    run_on_start = true,
  })
end

-- LSP servers and custom settings
local servers = {
  gopls = {},
  rust_analyzer = {},
  clangd = {},
  pyright = {},
  ts_ls = {}, -- renamed from tsserver
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
local ok_cmp_lsp, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
local capabilities = ok_cmp_lsp and cmp_nvim_lsp.default_capabilities() or vim.empty_dict()

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
-- Configure servers directly with lspconfig (guarded). mason-lspconfig can be used separately by plugin manager.
local function setup_server(server_name, opts)
  opts = opts or {}
  -- Prefer new API: vim.lsp.config
  if type(vim.lsp.config) == "table" and vim.lsp.config[server_name] then
    pcall(vim.lsp.config[server_name].setup, { capabilities = capabilities, on_attach = on_attach, settings = opts.settings or {}, filetypes = opts.filetypes })
    return
  end

  -- Fallback to legacy lspconfig
  local lspconfig_ok, lspconfig = pcall(require, "lspconfig")
  if lspconfig_ok and lspconfig[server_name] and lspconfig[server_name].setup then
    pcall(lspconfig[server_name].setup, { capabilities = capabilities, on_attach = on_attach, settings = opts.settings or {}, filetypes = opts.filetypes })
  end
end

for server_name, server_opts in pairs(servers) do
  setup_server(server_name, server_opts)
end
