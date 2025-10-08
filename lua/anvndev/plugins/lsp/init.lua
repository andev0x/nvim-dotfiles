-- ~/.config/nvim/lua/anvndev/plugins/lsp/init.lua
-- LSP configuration

return {
  -- LSP Configuration & Plugins
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      -- Mason and related tooling
      {
        "williamboman/mason.nvim",
        dependencies = {
          "williamboman/mason-lspconfig.nvim",
          "WhoIsSethDaniel/mason-tool-installer.nvim",
        },
      },

      -- Useful status updates for LSP
      { "j-hui/fidget.nvim", opts = {} },

      -- Additional lua configuration, makes nvim stuff amazing!
      { "folke/neodev.nvim" },
    },
    config = function()
      -- Setup neovim lua configuration
      require("neodev").setup()
      
      -- Import completion configuration
      require("anvndev.plugins.lsp.completion")
      
      -- Import LSP servers configuration
      require("anvndev.plugins.lsp.servers")
      
      -- Configure diagnostic display with improved visibility
      vim.diagnostic.config({
        underline = true,
        update_in_insert = false,
        virtual_text = {
          spacing = 4,
          source = "if_many",
          prefix = "●",
          severity = {
            min = vim.diagnostic.severity.HINT,
          },
        },
        severity_sort = true,
        float = {
          border = "rounded",
          source = "always",
          header = "",
          prefix = function(diagnostic)
            local icons = {
              [vim.diagnostic.severity.ERROR] = "",
              [vim.diagnostic.severity.WARN] = "",
              [vim.diagnostic.severity.INFO] = "",
              [vim.diagnostic.severity.HINT] = "󰌵",
            }
            return icons[diagnostic.severity] .. ": "
          end,
        },
        signs = {
          text = {
            [vim.diagnostic.severity.ERROR] = "",
            [vim.diagnostic.severity.WARN] = "",
            [vim.diagnostic.severity.INFO] = "",
            [vim.diagnostic.severity.HINT] = "󰌵",
          },
        },
      })

      -- Add error handling for LSP setup
      local on_attach = function(client, bufnr)
        -- Enable inlay hints if supported
        if client.supports_method("textDocument/inlayHint") then
          vim.lsp.inlay_hint.enable(bufnr, true)
        end
      end

      -- Configure LSP handlers
      vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
        border = "rounded",
        max_width = 80,
      })

      vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
        border = "rounded",
        max_width = 80,
      })
    end,
  },
  
  -- Autocompletion
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      -- Snippet Engine & its associated nvim-cmp source
      {
        "L3MON4D3/LuaSnip",
        dependencies = { "rafamadriz/friendly-snippets" },
        config = function()
          require("luasnip.loaders.from_vscode").lazy_load()
        end,
      },
      
      -- Completion sources
      { "hrsh7th/cmp-nvim-lsp" },
      { "hrsh7th/cmp-buffer" },
      { "hrsh7th/cmp-path" },
      { "saadparwaiz1/cmp_luasnip" },
      { "hrsh7th/cmp-nvim-lua" },
      
      -- Icons in completion menu
      { "onsails/lspkind.nvim" },
    },
  },
  
  -- Formatting
  {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    cmd = { "ConformInfo" },
    keys = {
      {
        "<leader>lf",
        function()
          require("conform").format({ async = true, lsp_fallback = true })
        end,
        desc = "Format buffer",
      },
    },
    opts = {
      formatters_by_ft = {
        lua = { "stylua" },
        go = { "gofumpt", "goimports" },
        rust = { "rustfmt" },
        python = { "isort", "black" },
        cpp = { "clang_format" },
        c = { "clang_format" },
        java = { "google-java-format" },
        ["*"] = { "trim_whitespace" },
      },
      format_on_save = {
        timeout_ms = 500,
        lsp_fallback = true,
      },
    },
  },
  
  -- Linting
  {
    "mfussenegger/nvim-lint",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      local lint = require("lint")
      
      lint.linters_by_ft = {
        go = { "golangcilint" },
        python = { "flake8", "mypy" },
        lua = { "luacheck" },
      }
      
      -- Automatically lint on certain events
      local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })
      vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
        group = lint_augroup,
        callback = function()
          lint.try_lint()
        end,
      })
      
      -- Command to manually trigger linting
      vim.api.nvim_create_user_command("Lint", function()
        lint.try_lint()
      end, {})
    end,
  },
}
