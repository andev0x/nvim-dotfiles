-- ~/.config/nvim/lua/anvndev/plugins/lang/cpp.lua
-- C/C++ language configuration for Neovim

return {
	---------------------------------------------------------------------------
	-- Clangd (LSP) Extensions
	---------------------------------------------------------------------------
	{
		"p00f/clangd_extensions.nvim",
		ft = { "c", "cpp", "objc", "objcpp", "cuda", "proto" },

		config = function()
			----------------------------------------------------------------------------
			-- Configure diagnostic signs with icons
			----------------------------------------------------------------------------
			vim.diagnostic.config({
				virtual_text = false, -- disable inline diagnostics
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

			----------------------------------------------------------------------------
			-- Clangd Extensions setup
			----------------------------------------------------------------------------
			require("clangd_extensions").setup({
				server = {
					cmd = {
						"clangd",
						"--background-index",
						"--pch-storage=memory",
						"--clang-tidy",
						"--suggest-missing-includes",
						"--all-scopes-completion",
						"--completion-style=detailed",
						"--header-insertion=iwyu",
						"--header-insertion-decorators",
						"--enable-config",
						"--offset-encoding=utf-16",
					},

					-- Required for Neovim 0.10+
					capabilities = {
						offsetEncoding = { "utf-16" },
					},

					on_attach = function(client, bufnr)
						local map = vim.keymap.set
						local opts = { noremap = true, silent = true, buffer = bufnr }

						----------------------------------------------------------------------
						-- LSP Mappings
						----------------------------------------------------------------------
						map("n", "K", vim.lsp.buf.hover, opts)
						map("n", "gd", vim.lsp.buf.definition, opts)
						map("n", "gr", vim.lsp.buf.references, opts)
						map("n", "<leader>rn", vim.lsp.buf.rename, opts)
						map("n", "<leader>ca", vim.lsp.buf.code_action, opts)
						map("n", "<leader>f", function()
							vim.lsp.buf.format({ async = true })
						end, opts)

						----------------------------------------------------------------------
						-- Enable Clangd inlay hints
						----------------------------------------------------------------------
						require("clangd_extensions.inlay_hints").setup_autocmd()
						require("clangd_extensions.inlay_hints").set_inlay_hints()
					end,
				},

				------------------------------------------------------------------------
				-- Extensions Settings
				------------------------------------------------------------------------
				extensions = {
					-- Auto set inlay hints
					autoSetHints = true,

					inlay_hints = {
						inline = vim.fn.has("nvim-0.10") == 1,
						only_current_line = false,
						only_current_line_autocmd = "CursorHold",
						show_parameter_hints = true,
						parameter_hints_prefix = "<- ",
						other_hints_prefix = "=> ",
						max_len_align = false,
						right_align = false,
						highlight = "Comment",
						priority = 100,
					},

					-- AST visualizer icons
					ast = {
						role_icons = {
							type = "🄣",
							declaration = "🄓",
							expression = "🄔",
							statement = ";",
							specifier = "🄢",
							["template argument"] = "🆃",
						},
						kind_icons = {
							Compound = "🄲",
							Recovery = "🅁",
							TranslationUnit = "🅄",
							PackExpansion = "🄿",
							TemplateTypeParm = "🅃",
							TemplateTemplateParm = "🅃",
							TemplateParamObject = "🅃",
						},
						highlights = { detail = "Comment" },
					},

					memory_usage = { border = "none" },
					symbol_info = { border = "none" },
				},
			})
		end,
	},

	---------------------------------------------------------------------------
	-- C/C++ Unit Testing (GoogleTest)
	---------------------------------------------------------------------------
	{
		"nvim-neotest/neotest",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-treesitter/nvim-treesitter",
			"antoinemadec/FixCursorHold.nvim",
			"alfaix/neotest-gtest",
		},
		config = function()
			require("neotest").setup({
				adapters = {
					require("neotest-gtest")({
						gtest_command = "gtest",
						gtest_args = { "--gtest_color=yes" },
					}),
				},
			})
		end,
	},
}
