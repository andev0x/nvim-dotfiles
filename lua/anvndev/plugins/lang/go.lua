-- ~/.config/nvim/lua/anvndev/plugins/lang/go.lua
-- Go language configuration

return {
  {
    "ray-x/go.nvim",
    dependencies = {
      "ray-x/guihua.lua",
      "neovim/nvim-lspconfig",
      "nvim-treesitter/nvim-treesitter",
    },
    ft = { "go", "gomod", "gosum", "gowork" },
    config = function()
      require("go").setup({
        -- Go lsp configuration
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
        
        -- Lsp inlay hints
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
        
        -- Lsp codelens
        lsp_codelens = true,
        
        -- Diagnostic configuration
        lsp_diag_hdlr = true,
        lsp_diag_virtual_text = { space = 0, prefix = "" },
        lsp_diag_signs = true,
        lsp_diag_update_in_insert = false,
        
        -- Formatting
        formatter = "gofumpt",
        formatter_extra_args = { "-s" },
        
        -- Test configuration
        test_runner = "go",
        run_in_floaterm = true,
        
        -- Trouble integration
        trouble = true,
        
        -- Auto tags
        tag_transform = "camelcase",
        
        -- Text objects
        text_obj = true,
        
        -- Key mappings
        keymaps = {
          -- Comments
          ["<leader>gc"] = "<cmd>GoDoc<cr>",
          ["<leader>gca"] = "<cmd>GoCodeAction<cr>",
          ["<leader>gd"] = "<cmd>GoDoc<cr>",
          
          -- Test
          ["<leader>gt"] = "<cmd>GoTest<cr>",
          ["<leader>gT"] = "<cmd>GoTestFunc<cr>",
          ["<leader>gtc"] = "<cmd>GoCoverage<cr>",
          ["<leader>gtC"] = "<cmd>GoCoverageClear<cr>",
          ["<leader>gta"] = "<cmd>GoAddTest<cr>",
          ["<leader>gte"] = "<cmd>GoTestsExp<cr>",
          ["<leader>gtg"] = "<cmd>GoTestsAll<cr>",
          
          -- Import
          ["<leader>gi"] = "<cmd>GoImport<cr>",
          ["<leader>gI"] = "<cmd>GoImpl<cr>",
          ["<leader>gaa"] = "<cmd>GoAlt<cr>",
          ["<leader>gas"] = "<cmd>GoAltS<cr>",
          ["<leader>gav"] = "<cmd>GoAltV<cr>",
        },
        
        -- Auto setup Go paths
        go_path = false,
        
        -- Verbose output
        verbose = false,
        
        -- Automatically format on save
        lsp_format_on_save = true,
        
        -- Automatically organize imports on save
        lsp_on_attach = function(client, bufnr)
          local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
          
          -- Mappings
          local opts = { noremap = true, silent = true }
          
          -- Go specific mappings
          buf_set_keymap("n", "<leader>gfs", "<cmd>GoFillStruct<CR>", opts)
          buf_set_keymap("n", "<leader>gfr", "<cmd>GoFillReturn<CR>", opts)
          buf_set_keymap("n", "<leader>gfc", "<cmd>GoFixComment<CR>", opts)
          buf_set_keymap("n", "<leader>gat", "<cmd>GoAddTag<CR>", opts)
          buf_set_keymap("n", "<leader>grt", "<cmd>GoRmTag<CR>", opts)
          buf_set_keymap("n", "<leader>gct", "<cmd>GoClearTag<CR>", opts)
          buf_set_keymap("n", "<leader>gii", "<cmd>GoIfErr<CR>", opts)
        end,
        
        -- Dap configuration
        dap_debug = true,
        dap_debug_gui = true,
      })
    end,
  },
  
  -- Go test coverage
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
          experimental = {
            test_table = true,
          },
          args = { "-count=1", "-timeout=60s" },
        }),
        },
      })
    end,
  },
}