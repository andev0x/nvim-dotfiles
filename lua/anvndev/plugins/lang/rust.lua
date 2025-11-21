-- ~/.config/nvim/lua/anvndev/plugins/lang/rust.lua
-- Rust language configuration for Neovim

return {
	{
		"mrcjkb/rustaceanvim",
		version = "^5", -- ensure stable release
		ft = { "rust" },
		config = function()
			-------------------------------------------------------------------------
			-- Setup rustaceanvim (Rust LSP + Tools)
			-------------------------------------------------------------------------
			vim.g.rustaceanvim = {
				server = {
					on_attach = function(client, bufnr)
						local map = vim.keymap.set
						local opts = { noremap = true, silent = true, buffer = bufnr }

						-- 🔧 LSP keymaps
						map("n", "K", vim.lsp.buf.hover, opts)
						map("n", "gd", vim.lsp.buf.definition, opts)
						map("n", "gr", vim.lsp.buf.references, opts)
						map("n", "<leader>rn", vim.lsp.buf.rename, opts)
						map("n", "<leader>ca", vim.lsp.buf.code_action, opts)
						map("n", "<leader>f", function()
							vim.lsp.buf.format({ async = true })
						end, opts)

						-- Rust-specific actions
						map("n", "<leader>rr", "<cmd>RustLsp runnables<CR>", opts)
						map("n", "<leader>rt", "<cmd>RustLsp testables<CR>", opts)
						map("n", "<leader>re", "<cmd>RustLsp expandMacro<CR>", opts)
						map("n", "<leader>rd", "<cmd>RustLsp openDocs<CR>", opts)
					end,
					settings = {
						["rust-analyzer"] = {
							cargo = {
								allFeatures = true,
							},
							checkOnSave = {
								command = "clippy",
							},
							diagnostics = {
								enable = true,
								experimental = { enable = true },
							},
							inlayHints = {
								bindingModeHints = { enable = true },
								chainingHints = { enable = true },
								closingBraceHints = { enable = true },
								closureReturnTypeHints = { enable = "always" },
								lifetimeElisionHints = { enable = "always" },
								parameterHints = { enable = true },
								reborrowHints = { enable = "always" },
								typeHints = { enable = true },
							},
						},
					},
				},
			}

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

			-------------------------------------------------------------------------
			-- Auto format on save for Rust files
			-------------------------------------------------------------------------
			vim.api.nvim_create_autocmd("BufWritePre", {
				pattern = "*.rs",
				callback = function()
					vim.lsp.buf.format({ async = false })
				end,
			})
		end,
	},
}
