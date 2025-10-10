-- ~/.config/nvim/lua/anvndev/plugins/lsp/init.lua
-- ==================================================
-- ⚙️ LSP, Formatting, and Linting configuration
-- ==================================================

return {
  -- --------------------------------------------------
  -- 🧠 LSP Core Configuration
  -- --------------------------------------------------
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      -- Mason: manage LSP servers, linters, formatters, DAPs
      {
        "williamboman/mason.nvim",
        dependencies = {
          "williamboman/mason-lspconfig.nvim",
          "WhoIsSethDaniel/mason-tool-installer.nvim",
        },
        config = function()
          require("mason").setup({
            ui = {
              border = "rounded",
              icons = {
                package_installed = "✓",
                package_pending = "➜",
                package_uninstalled = "✗",
              },
            },
          })

          require("mason-lspconfig").setup({
            automatic_installation = true,
          })

          require("mason-tool-installer").setup({
            ensure_installed = {
              "gopls",
              "lua-language-server",
              "rust-analyzer",
              "golangci-lint",
              "stylua",
              "gofumpt",
              "goimports",
            },
            auto_update = true,
            run_on_start = true,
          })
        end,
      },

      -- LSP progress/status UI
      { "j-hui/fidget.nvim", opts = {} },

      -- Enhance Lua LSP for Neovim
      { "folke/neodev.nvim", opts = {} },
    },

    config = function()
      require("neodev").setup()

      -- Import custom completion and server setup modules
      require("anvndev.plugins.lsp.completion")
      require("anvndev.plugins.lsp.servers")

      -- Diagnostic configuration for better readability
      vim.diagnostic.config({
        underline = true,
        update_in_insert = false,
        virtual_text = {
          spacing = 4,
          source = "if_many",
          prefix = "●",
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

      -- Rounded borders for hover & signature popups
      vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
        border = "rounded",
        max_width = 80,
      })

      vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
        border = "rounded",
        max_width = 80,
      })

      -- ✅ Fix: Enable inlay hints correctly for Neovim 0.10+
      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(args)
          local client = vim.lsp.get_client_by_id(args.data.client_id)
          if client and client.supports_method("textDocument/inlayHint") then
            vim.lsp.inlay_hint.enable(true, { bufnr = args.buf })
          end
        end,
        desc = "Enable inlay hints when supported",
      })
    end,
  },

  -- --------------------------------------------------
  -- ⚡ Autocompletion
  -- --------------------------------------------------
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      {
        "L3MON4D3/LuaSnip",
        dependencies = { "rafamadriz/friendly-snippets" },
        config = function()
          require("luasnip.loaders.from_vscode").lazy_load()
        end,
      },
      { "hrsh7th/cmp-nvim-lsp" },
      { "hrsh7th/cmp-buffer" },
      { "hrsh7th/cmp-path" },
      { "saadparwaiz1/cmp_luasnip" },
      { "hrsh7th/cmp-nvim-lua" },
      { "onsails/lspkind.nvim" },
    },
  },

  -- --------------------------------------------------
  -- 🧹 Formatting (Conform)
  -- --------------------------------------------------
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
        desc = "Format current buffer",
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

  -- --------------------------------------------------
  -- 🧾 Linting (nvim-lint)
  -- --------------------------------------------------
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

      local lint_augroup = vim.api.nvim_create_augroup("LintAutoGroup", { clear = true })
      vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
        group = lint_augroup,
        callback = function()
          lint.try_lint()
        end,
        desc = "Auto-lint buffer on save/leave",
      })

      vim.api.nvim_create_user_command("Lint", function()
        lint.try_lint()
      end, { desc = "Manually trigger linting" })
    end,
  },
}
