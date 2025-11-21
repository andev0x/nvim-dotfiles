-- ~/.config/nvim/lua/anvndev/plugins/lang/go.lua
-- Professional Go language configuration for Neovim
-- Compatible with Lazy.nvim and modern Neovim setups

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
				-----------------------------------------------------------------------
				-- LSP configuration
				-----------------------------------------------------------------------
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

				-----------------------------------------------------------------------
				-- Inlay hints
				-----------------------------------------------------------------------
				lsp_inlay_hints = {
					enable = true,
					only_current_line = false,
					show_parameter_hints = true,
					parameter_hints_prefix = "󰊕 ",
					other_hints_prefix = "=> ",
					highlight = "Comment",
				},

				-----------------------------------------------------------------------
				-- Diagnostics
				-- Disable inline diagnostic virtual text for cleaner view
				-----------------------------------------------------------------------
				lsp_diag_hdlr = false, -- disable Go.nvim's internal diagnostic handler
				lsp_diag_virtual_text = false, -- disable inline diagnostics
				lsp_diag_signs = true, -- keep signs (gutter icons)
				lsp_diag_update_in_insert = false,

				-----------------------------------------------------------------------
				-- Formatting
				-----------------------------------------------------------------------
				formatter = "gofumpt",
				formatter_extra_args = { "-s" },

				-----------------------------------------------------------------------
				-- Testing
				-----------------------------------------------------------------------
				test_runner = "go",
				run_in_floaterm = true,

				-----------------------------------------------------------------------
				-- Miscellaneous features
				-----------------------------------------------------------------------
				lsp_codelens = true,
				trouble = true,
				text_obj = true,
				tag_transform = "camelcase",
				lsp_format_on_save = true,

				-----------------------------------------------------------------------
				-- On attach: keymaps and hooks
				-----------------------------------------------------------------------
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

				-----------------------------------------------------------------------
				-- DAP (Debug Adapter Protocol)
				-----------------------------------------------------------------------
				dap_debug = true,
				dap_debug_gui = true,
			})

			-------------------------------------------------------------------------
			-- Configure diagnostic signs with icons
			-------------------------------------------------------------------------
			vim.diagnostic.config({
				virtual_text = false, -- no inline diagnostic messages
				signs = {
					text = {
						[vim.diagnostic.severity.ERROR] = " ", -- nf-fa-times_circle
						[vim.diagnostic.severity.WARN] = " ", -- nf-fa-warning
						[vim.diagnostic.severity.INFO] = "󰙎 ", -- nf-fa-info_circle
						[vim.diagnostic.severity.HINT] = " ", -- nf-oct-light_bulb
					},
				},
				underline = true,
				update_in_insert = false,
				severity_sort = true,
			})
		end,
	},

	---------------------------------------------------------------------------
	-- Neotest integration for Go
	---------------------------------------------------------------------------
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
