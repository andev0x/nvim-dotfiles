-- ~/.config/nvim/lua/anvndev/plugins/lsp/init.lua
-- ==================================================
-- ⚙️ LSP, Formatting, and Linting Configuration
-- ==================================================

return {
	-- --------------------------------------------------
	-- 🧠 Core LSP Setup
	-- --------------------------------------------------
	{
		"neovim/nvim-lspconfig",
		event = { "BufReadPre", "BufNewFile" },
		dependencies = {
			-- Mason: manage LSP servers, linters, formatters, DAPs
			{ "williamboman/mason.nvim", config = true },
			"williamboman/mason-lspconfig.nvim",
			"WhoIsSethDaniel/mason-tool-installer.nvim",

			-- LSP progress/status UI
			{ "j-hui/fidget.nvim", opts = {} },

			-- Better Lua LSP integration for Neovim development
			{ "folke/neodev.nvim", opts = {} },

			-- Autocompletion capabilities
			"hrsh7th/cmp-nvim-lsp",
		},

		config = function()
			-- 1. Setup Neodev (must be before lspconfig)
			require("neodev").setup()

			-- 2. Import dependencies
			local lspconfig = require("lspconfig")
			local mason = require("mason")
			local mason_lspconfig = require("mason-lspconfig")
			local mason_tool_installer = require("mason-tool-installer")
			local cmp_nvim_lsp = require("cmp_nvim_lsp")

			-- 3. Setup Mason UI
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

			-- 4. Install tools automatically
			mason_tool_installer.setup({
				ensure_installed = {
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
					"tailwindcss", -- Optional: added widely used tailwind

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

					-- Debuggers
					"delve", -- Go
					"codelldb", -- Rust, C/C++
					"debugpy", -- Python
				},
				auto_update = true,
				run_on_start = true,
			})

			-- 5. Define Capabilities (for nvim-cmp)
			local capabilities = vim.lsp.protocol.make_client_capabilities()
			capabilities = cmp_nvim_lsp.default_capabilities(capabilities)

			-- 6. Setup Mason-LSPConfig Handlers (The FIX)
			-- This automatically sets up every server installed by Mason
			mason_lspconfig.setup({
				automatic_installation = true,
				handlers = {
					-- Default handler for all servers
					function(server_name)
						lspconfig[server_name].setup({
							capabilities = capabilities,
						})
					end,

					-- Specific overrides (example: Lua)
					["lua_ls"] = function()
						lspconfig.lua_ls.setup({
							capabilities = capabilities,
							settings = {
								Lua = {
									diagnostics = {
										globals = { "vim" },
									},
									completion = {
										callSnippet = "Replace",
									},
								},
							},
						})
					end,

					-- Specific overrides (example: Clangd)
					["clangd"] = function()
						lspconfig.clangd.setup({
							capabilities = capabilities,
							cmd = {
								"clangd",
								"--offset-encoding=utf-16", -- Fix encoding error with null-ls/copilot
							},
						})
					end,
				},
			})

			-- 7. Keymaps & Inlay Hints (LspAttach)
			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("UserLspConfig", {}),
				callback = function(args)
					local client = vim.lsp.get_client_by_id(args.data.client_id)
					local bufnr = args.buf
					local opts = { buffer = bufnr, silent = true }

					-- Keymaps
					opts.desc = "Show LSP references"
					vim.keymap.set("n", "gR", "<cmd>Telescope lsp_references<CR>", opts)

					opts.desc = "Go to declaration"
					vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)

					opts.desc = "Show LSP definitions"
					vim.keymap.set("n", "gd", "<cmd>Telescope lsp_definitions<CR>", opts)

					opts.desc = "Show LSP implementations"
					vim.keymap.set("n", "gi", "<cmd>Telescope lsp_implementations<CR>", opts)

					opts.desc = "Show LSP type definitions"
					vim.keymap.set("n", "gt", "<cmd>Telescope lsp_type_definitions<CR>", opts)

					opts.desc = "See available code actions"
					vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)

					opts.desc = "Smart rename"
					vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)

					opts.desc = "Show buffer diagnostics"
					vim.keymap.set("n", "<leader>D", "<cmd>Telescope diagnostics bufnr=0<CR>", opts)

					opts.desc = "Show line diagnostics"
					vim.keymap.set("n", "<leader>d", vim.diagnostic.open_float, opts)

					opts.desc = "Show documentation for what is under cursor"
					vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)

					opts.desc = "Restart LSP"
					vim.keymap.set("n", "<leader>rs", ":LspRestart<CR>", opts)

					-- navic
					if client.server_capabilities.documentSymbolProvider then
						local navic_ok, navic = pcall(require, "nvim-navic")
						if navic_ok then
							navic.attach(client, bufnr)
						end
					end

					-- Enable inlay hints (Neovim 0.10+)
					if client and client:supports_method("textDocument/inlayHint") then
						vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
					end
				end,
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
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-path",
			"saadparwaiz1/cmp_luasnip",
			"hrsh7th/cmp-nvim-lua",
			"onsails/lspkind.nvim",
		},
		-- NOTE: Ensure you have a config function for cmp here,
		-- usually calling require("anvndev.plugins.lsp.completion")
		-- or defining setup({ ... }) directly.
		-- If it's in an external file, keep the 'config' key pointing to it.
		config = function()
			require("anvndev.plugins.lsp.completion")
		end,
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
				-- Use the "*" filetype to run formatters on all filetypes.
				-- ["*"] = { "codespell" },
				-- Use the "_" filetype to run formatters on filetypes that don't
				-- have other formatters configured.
				["_"] = { "trim_whitespace" },
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
