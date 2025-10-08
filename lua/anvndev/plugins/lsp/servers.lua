-- ~/.config/nvim/lua/anvndev/plugins/lsp/servers.lua
-- LSP servers configuration
local mason = require("mason")

local mason_tool_installer = require("mason-tool-installer")

-- Setup Mason
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

-- LSP servers to install and configure
local servers = {
  -- Backend languages
  gopls = {}, -- Go
  rust_analyzer = {}, -- Rust
  clangd = {}, -- C/C++
  pyright = {}, -- Python
  
  -- Web development
  ts_ls = {}, -- TypeScript/JavaScript
  html = {},
  cssls = {},
  jsonls = {},
  
  -- Configuration languages
  yamlls = {},
  dockerls = {},
  
  -- Lua
  lua_ls = {
    settings = {
      Lua = {
        workspace = { checkThirdParty = false },
        telemetry = { enable = false },
        diagnostics = {
          globals = { "vim" },
        },
      },
    },
  },
}

-- Tools to install (formatters, linters, debuggers)
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
  "nvim-lspconfig",
  
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
  
  -- DAP
  "delve", -- Go
  "codelldb", -- Rust, C/C++
  "debugpy", -- Python
}

-- Setup Mason LSP Config


-- Setup Mason Tool Installer
mason_tool_installer.setup({
  ensure_installed = tools,
  auto_update = true,
  run_on_start = true,
})

-- Setup LSP servers
local capabilities = require("cmp_nvim_lsp").default_capabilities()

-- Function to attach LSP-specific keymaps when an LSP connects to a buffer
local on_attach = function(client, bufnr)
  -- Enable completion triggered by <c-x><c-o>
  vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")
  
  -- Enable inlay hints if supported
  if client.server_capabilities.inlayHintProvider then
    vim.lsp.inlay_hint.enable(bufnr, true)
  end
  
  -- Enable navic (breadcrumbs) if supported
  if client.server_capabilities.documentSymbolProvider then
    local navic_ok, navic = pcall(require, "nvim-navic")
    if navic_ok then
      navic.attach(client, bufnr)
    end
  end
end

-- Configure each LSP server
for server_name, server_config in pairs(servers) do
  vim.lsp.config(server_name, {
    capabilities = capabilities,
    on_attach = on_attach,
    settings = server_config.settings or {},
    filetypes = server_config.filetypes,
  })
  vim.lsp.enable(server_name)
end