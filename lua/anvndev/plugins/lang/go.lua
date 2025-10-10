-- ~/.config/nvim/lua/anvndev/plugins/lang/go.lua
-- Go language configuration for Neovim

return {
  {
    "ray-x/go.nvim",
    dependencies = {
      "ray-x/guihua.lua",
      "nvim-treesitter/nvim-treesitter",
    },
    ft = { "go", "gomod", "gosum", "gowork" },
    config = function()
      require("go").setup({
        -- 🔧 LSP configuration
        lsp_cfg = {
          settings = {
            gopls = {
              analyses = {
                unusedparams = true,
                shadow = true,
                nilness = true,
                unusedwrite = true,
                useany = true,
              },
              staticcheck = true,
              gofumpt = true,
              usePlaceholders = true,
              hints = {
                assignVariableTypes = true,
                compositeLiteralFields = true,
                compositeLiteralTypes = true,
                constantValues = true,
                functionTypeParameters = true,
                parameterNames = true,
                rangeVariableTypes = true,
              },
            },
          },
        },

        -- 💡 Inlay hints
        lsp_inlay_hints = {
          enable = true,
          only_current_line = false,
          only_current_line_autocmd = "CursorHold",
          show_parameter_hints = true,
          show_variable_name = true,
          parameter_hints_prefix = "󰊕 ",
          other_hints_prefix = "=> ",
          highlight = "Comment",
        },

        -- 🧩 Diagnostics
        lsp_diag_hdlr = true,
        lsp_diag_virtual_text = { space = 2, prefix = "●" },
        lsp_diag_signs = {
          text = {
            [vim.diagnostic.severity.ERROR] = " ",
            [vim.diagnostic.severity.WARN] = " ",
            [vim.diagnostic.severity.HINT] = "󰌶 ",
            [vim.diagnostic.severity.INFO] = " ",
          },
        },
        lsp_diag_update_in_insert = false,

        -- 🧱 Formatter
        formatter = "gofumpt",
        formatter_extra_args = { "-s" },

        -- 🧪 Testing
        test_runner = "go",
        run_in_floaterm = true,

        -- 🧰 Misc features
        lsp_codelens = true,
        trouble = true,
        text_obj = true,
        tag_transform = "camelcase",
        lsp_format_on_save = true,

        -- ⚡ on_attach: keymaps & more
        lsp_on_attach = function(client, bufnr)
          local map = vim.keymap.set
          local opts = { noremap = true, silent = true, buffer = bufnr }

          -- Go-specific actions
          map("n", "<leader>gfs", "<cmd>GoFillStruct<CR>", opts)
          map("n", "<leader>gfr", "<cmd>GoFillReturn<CR>", opts)
          map("n", "<leader>gfc", "<cmd>GoFixComment<CR>", opts)
          map("n", "<leader>gat", "<cmd>GoAddTag<CR>", opts)
          map("n", "<leader>grt", "<cmd>GoRmTag<CR>", opts)
          map("n", "<leader>gct", "<cmd>GoClearTag<CR>", opts)
          map("n", "<leader>gii", "<cmd>GoIfErr<CR>", opts)
        end,

        -- 🐞 DAP integration
        dap_debug = true,
        dap_debug_gui = true,
      })
    end,
  },

  -- 🧠 Neotest integration for Go
  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "antoinemadec/FixCursorHold.nvim",
      "nvim-neotest/neotest-go",
    },
    config = function()
      require("neotest").setup({
        adapters = {
          require("neotest-go")({
            experimental = { test_table = true },
            args = { "-count=1", "-timeout=60s" },
          }),
        },
      })
    end,
  },
}
