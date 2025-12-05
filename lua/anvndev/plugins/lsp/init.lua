-- ~/.config/nvim/lua/anvndev/plugins/lsp/init.lua
-- ==================================================
-- LSP, Formatting, and Linting Configuration
-- Author: anvndev
-- ==================================================

return {
	-- --------------------------------------------------
	-- Core LSP Setup
	-- --------------------------------------------------
	require("anvndev.plugins.misc.fidget"),
	{
		"neovim/nvim-lspconfig",
		event = { "BufReadPre", "BufNewFile" },
		dependencies = {
			-- Mason: manage LSP servers, linters, formatters, DAPs
			{ "williamboman/mason.nvim", config = true },
			"williamboman/mason-lspconfig.nvim",
			"WhoIsSethDaniel/mason-tool-installer.nvim",
			{ "folke/neodev.nvim", opts = {} },
			"hrsh7th/cmp-nvim-lsp",
		},

		config = function()
			require("neodev").setup()

			local lspconfig = require("lspconfig")
			local mason = require("mason")
			local mason_lspconfig = require("mason-lspconfig")
			local mason_tool_installer = require("mason-tool-installer")
			local cmp_nvim_lsp = require("cmp_nvim_lsp")

			-- 1. Setup Mason UI
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

			-- 2. Install tools automatically
			mason_tool_installer.setup({
				ensure_installed = {
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
					"tailwindcss",
					"gofumpt",
					"goimports",
					"rustfmt",
					"clang-format",
					"black",
					"isort",
					"stylua",
					"prettier",
					"golangci-lint",
					"flake8",
					"mypy",
					"luacheck",
					"eslint_d",
					"delve",
					"codelldb",
					"debugpy",
				},
				auto_update = true,
				run_on_start = true,
			})

			-- 3. UI & Diagnostics Configuration (MERGED FROM YOUR DIAGNOSTICS.LUA)

			-- Icons for the Sign Column (Gutter - Left side)
			local gutter_signs = {
				Error = "",
				Warn = "",
				Hint = "󰌵",
				Info = "",
			}

			-- Define signs for legacy support
			for type, icon in pairs(gutter_signs) do
				local hl = "DiagnosticSign" .. type
				vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
			end

			-- Global Diagnostic Config
			vim.diagnostic.config({
				-- Force signs (Gutter icons)
				signs = {
					text = {
						[vim.diagnostic.severity.ERROR] = gutter_signs.Error,
						[vim.diagnostic.severity.WARN] = gutter_signs.Warn,
						[vim.diagnostic.severity.HINT] = gutter_signs.Hint,
						[vim.diagnostic.severity.INFO] = gutter_signs.Info,
					},
				},
				virtual_text = false, -- Disable inline text as requested
				underline = true,
				update_in_insert = false,
				severity_sort = true,
				float = {
					border = "rounded",
					source = "if_many",
					header = "",
					focusable = true,
					-- FIX: This function handles the custom icons inside the Popup
					prefix = function(diagnostic)
						local icons = {
							[vim.diagnostic.severity.ERROR] = " ",
							[vim.diagnostic.severity.WARN] = " ", -- Different icon for popup
							[vim.diagnostic.severity.INFO] = "󰙎 ", -- Different icon for popup
							[vim.diagnostic.severity.HINT] = "󰌵 ",
						}
						return icons[diagnostic.severity] .. " "
					end,
				},
			})

			-- 4. Setup Mason-LSPConfig Handlers
			local capabilities = vim.lsp.protocol.make_client_capabilities()
			capabilities = cmp_nvim_lsp.default_capabilities(capabilities)

			mason_lspconfig.setup({
				automatic_installation = true,
				handlers = {
					function(server_name)
						lspconfig[server_name].setup({ capabilities = capabilities })
					end,
					["lua_ls"] = function()
						lspconfig.lua_ls.setup({
							capabilities = capabilities,
							settings = {
								Lua = {
									diagnostics = { globals = { "vim" } },
									completion = { callSnippet = "Replace" },
								},
							},
						})
					end,
					["clangd"] = function()
						lspconfig.clangd.setup({
							capabilities = capabilities,
							cmd = { "clangd", "--offset-encoding=utf-16" },
						})
					end,
				},
			})

			-- 5. LspAttach Configuration
			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("UserLspConfig", {}),
				callback = function(args)
					local client = vim.lsp.get_client_by_id(args.data.client_id)
					local bufnr = args.buf
					local opts = { buffer = bufnr, silent = true }

					-- Keymaps
					opts.desc = "Go to declaration"
					vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
					opts.desc = "Show definitions"
					vim.keymap.set("n", "gd", "<cmd>Telescope lsp_definitions<CR>", opts)
					opts.desc = "Show implementation"
					vim.keymap.set("n", "gi", "<cmd>Telescope lsp_implementations<CR>", opts)
					opts.desc = "Code Action"
					vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)
					opts.desc = "Rename"
					vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
					opts.desc = "Diagnostics (Buffer)"
					vim.keymap.set("n", "<leader>D", "<cmd>Telescope diagnostics bufnr=0<CR>", opts)
					opts.desc = "Line Diagnostics"
					vim.keymap.set("n", "<leader>d", vim.diagnostic.open_float, opts)
					opts.desc = "Documentation"
					vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
					opts.desc = "Restart LSP"
					vim.keymap.set("n", "<leader>rs", ":LspRestart<CR>", opts)

					-- Inlay Hints
					if client and client:supports_method("textDocument/inlayHint") then
						vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
					end

					-- 6. Auto-show Diagnostics Popup on Cursor Hold
					vim.api.nvim_create_autocmd("CursorHold", {
						buffer = bufnr,
						callback = function()
							-- We DO NOT define 'prefix' here, so it inherits the function
							-- from vim.diagnostic.config above!
							local float_opts = {
								focusable = false,
								close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
								border = "rounded",
								source = "if_many",
								scope = "cursor",
							}
							vim.diagnostic.open_float(nil, float_opts)
						end,
					})

					-- Navic
					if client.server_capabilities.documentSymbolProvider then
						pcall(function()
							require("nvim-navic").attach(client, bufnr)
						end)
					end
				end,
			})
		end,
	},

	-- Autocompletion
	{
		"hrsh7th/nvim-cmp",
		event = "InsertEnter",
		dependencies = {
			"L3MON4D3/LuaSnip",
			"saadparwaiz1/cmp_luasnip",
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-path",
			"hrsh7th/cmp-buffer",
			"onsails/lspkind.nvim",
		},
		config = function()
			require("anvndev.plugins.lsp.completion")
		end,
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
				javascript = { "prettier" },
				typescript = { "prettier" },
				["_"] = { "trim_whitespace" },
			},
			format_on_save = { timeout_ms = 500, lsp_fallback = true },
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
			local lint_augroup = vim.api.nvim_create_augroup("LintAutoGroup", { clear = true })
			vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
				group = lint_augroup,
				callback = function()
					lint.try_lint()
				end,
			})
		end,
	},
}
