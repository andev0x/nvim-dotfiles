-- ~/.config/nvim/lua/anvndev/plugins/lang/rust.lua
-- Rust language configuration (updated for new rust-analyzer schema)

return {
	{
		"simrat39/rust-tools.nvim",
		ft = { "rust" },
		dependencies = {
			"nvim-lua/plenary.nvim",
			"mfussenegger/nvim-dap",
		},
		config = function()
			local rt = require("rust-tools")

			-- Detect paths for codelldb (debugger)
			local extension_path = vim.fn.stdpath("data") .. "/mason/packages/codelldb/extension/"
			local codelldb_path = extension_path .. "adapter/codelldb"
			local liblldb_path = extension_path .. "lldb/lib/liblldb.dylib" -- macOS specific

			rt.setup({
				server = {
					on_attach = function(client, bufnr)
						-- Hover and code actions
						vim.keymap.set("n", "<C-space>", rt.hover_actions.hover_actions, { buffer = bufnr })
						vim.keymap.set("n", "<Leader>ra", rt.code_action_group.code_action_group, { buffer = bufnr })

						-- Enable inlay hints
						rt.inlay_hints.enable()

						-- Default LSP mappings
						local opts = { buffer = bufnr }
						vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
						vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
						vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
						vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
						vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
						vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
					end,

					settings = {
						["rust-analyzer"] = {
							cargo = {
								allFeatures = true,
								loadOutDirsFromCheck = true,
								runBuildScripts = true,
							},
							check = {
								command = "clippy", -- Replaces the old `checkOnSave = { command = "clippy" }`
							},
							checkOnSave = true, -- Run the check automatically on save
							procMacro = { enable = true },
							diagnostics = { enable = true },
							inlayHints = {
								bindingModeHints = { enable = true },
								chainingHints = { enable = true },
								closingBraceHints = { enable = true, minLines = 25 },
								closureReturnTypeHints = { enable = "always" },
								lifetimeElisionHints = { enable = "always", useParameterNames = true },
								maxLength = 25,
								parameterHints = { enable = true },
								reborrowHints = { enable = "always" },
								renderColons = true,
								typeHints = {
									enable = true,
									hideClosureInitialization = false,
									hideNamedConstructor = false,
								},
							},
						},
					},
				},

				tools = {
					inlay_hints = {
						auto = true,
						show_parameter_hints = true,
						parameter_hints_prefix = "<- ",
						other_hints_prefix = "=> ",
						max_len_align = false,
						right_align = false,
						highlight = "Comment",
					},
					hover_actions = {
						border = "rounded",
						auto_focus = true,
					},
				},

				dap = {
					adapter = {
						type = "executable",
						command = codelldb_path,
						name = "rt_lldb",
						args = { "--liblldb", liblldb_path },
					},
				},
			})
		end,
	},

	-- Crates.io integration
	{
		"saecki/crates.nvim",
		event = { "BufRead Cargo.toml" },
		dependencies = { "nvim-lua/plenary.nvim" },
		config = function()
			require("crates").setup({
				null_ls = { enabled = true, name = "crates.nvim" },
				popup = { border = "rounded" },
			})
		end,
	},

	-- Rust test integration
	{
		"nvim-neotest/neotest",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-treesitter/nvim-treesitter",
			"antoinemadec/FixCursorHold.nvim",
			"rouge8/neotest-rust",
		},
		config = function()
			require("neotest").setup({
				adapters = { require("neotest-rust") },
			})
		end,
	},
}

