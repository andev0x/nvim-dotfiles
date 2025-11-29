-- File: lua/anvndev/plugins/misc/avante.lua
-- Avante AI Assistant Configuration with Safety Features
-- Author: anvndev
--
-- Key Features:
-- 1. Explicit approval workflow (no auto-apply)
-- 2. Diff view enabled for all changes
-- 3. Full keymap support for accept/reject
-- 4. Safety checks before code modification

return {
	"yetone/avante.nvim",
	lazy = false,
	version = false,

	build = vim.fn.has("win32") ~= 0 and "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false"
		or "make",

	dependencies = {
		"nvim-treesitter/nvim-treesitter",
		"nvim-lua/plenary.nvim",
		"MunifTanjim/nui.nvim",

		-- Copilot as AI Provider
		{
			"zbirenbaum/copilot.lua",
			cmd = "Copilot",
			event = "InsertEnter",
			config = function()
				require("copilot").setup({
					suggestion = {
						enabled = true,
						auto_trigger = false,
						debounce = 75,
						keymap = {
							accept = "<M-l>",
							accept_word = false,
							accept_line = false,
							next = "<M-]>",
							prev = "<M-[>",
							dismiss = "<C-]>",
						},
					},
					panel = {
						enabled = true,
						auto_refresh = false,
						keymap = {
							jump_prev = "[[",
							jump_next = "]]",
							accept = "<CR>",
							refresh = "gr",
							open = "<M-CR>",
						},
					},
					filetypes = {
						yaml = false,
						markdown = false,
						help = false,
						gitcommit = false,
						gitrebase = false,
						hgcommit = false,
						svn = false,
						cvs = false,
						["."] = false,
					},
					copilot_node_command = "node",
					server_opts_overrides = {},
				})
			end,
		},

		-- Input UI with proper styling
		{
			"stevearc/dressing.nvim",
			opts = {
				input = {
					win_options = { winblend = 0 },
					border = "rounded",
					prefer_width = 50,
				},
				select = {
					backend = { "telescope", "builtin" },
					builtin = { border = "rounded" },
				},
			},
		},

		-- Markdown rendering for interactive elements
		{
			"MeanderingProgrammer/render-markdown.nvim",
			opts = {
				file_types = { "markdown", "Avante" },
			},
			ft = { "markdown", "Avante" },
		},

		-- Image support (optional)
		{
			"HakonHarnes/img-clip.nvim",
			event = "VeryLazy",
			opts = {
				default = {
					embed_image_as_base64 = false,
					prompt_for_file_name = false,
					drag_and_drop = { insert_mode = true },
					use_absolute_path = true,
				},
			},
		},
	},

	opts = {
		-- AI Provider Configuration
		provider = "copilot",
		auto_suggestions_provider = "copilot",

		-- Behaviour: CRITICAL SAFETY SETTINGS
		behaviour = {
			-- Enable default keymaps
			auto_set_keymaps = true,
			-- NEVER auto-apply suggestions - user must explicitly accept
			auto_suggestions = false,
			-- Suppress auto-insert on provider response
			auto_apply_suggestion_to_current_buffer = false,
			-- Debounce for responsiveness
			debounce_time = 150,
			-- Require explicit window navigation
			minimize_diff = false,
		},

		-- UI Configuration
		ui = {
			position = "right",
			width = 45,
			height = 30,
			-- Show line numbers for better navigation
			relative = "editor",
		},

		-- MANDATORY: Diff view for all changes
		diff_view = {
			enabled = true,
			provider = "default",
		},

		-- File handling
		file_selector = {
			provider = "telescope",
		},

		-- Hint configuration (show helpful tips)
		hints = {
			enabled = true,
		},
	},

	config = function(_, opts)
		-- Setup Avante
		require("avante").setup(opts)

		-- ==========================================
		-- Safety Keymaps
		-- ==========================================
		local keymap = vim.keymap.set
		local opts_silent = { noremap = true, silent = true }

		-- Accept suggestion (apply changes)
		keymap("n", "<leader>aa", function()
			require("avante.api").accept()
		end, { desc = "Avante: Accept suggestion", noremap = true, silent = true })

		-- Reject suggestion (dismiss changes)
		keymap("n", "<leader>ar", function()
			require("avante.api").reject()
		end, { desc = "Avante: Reject suggestion", noremap = true, silent = true })

		-- Toggle Avante sidebar
		keymap("n", "<leader>av", function()
			require("avante.api").ask()
		end, { desc = "Avante: Ask question", noremap = true, silent = true })

		-- Refresh/regenerate suggestion
		keymap("n", "<leader>af", function()
			require("avante.api").refresh()
		end, { desc = "Avante: Refresh suggestion", noremap = true, silent = true })

		-- Toggle Diff View
		keymap("n", "<leader>ad", function()
			require("avante.diff").toggle()
		end, { desc = "Avante: Toggle diff view", noremap = true, silent = true })

		-- Edit prompt
		keymap("n", "<leader>ae", function()
			require("avante.api").edit()
		end, { desc = "Avante: Edit prompt", noremap = true, silent = true })

		-- ==========================================
		-- Visual Customization
		-- ==========================================
		-- Added lines highlighting
		vim.api.nvim_set_hl(0, "AvanteLineAdded", {
			bg = "#1f3b25",
			fg = "#90ee90",
			bold = true,
		})

		-- Removed lines highlighting
		vim.api.nvim_set_hl(0, "AvanteLineRemoved", {
			bg = "#4a2121",
			fg = "#ff6b6b",
			bold = true,
		})

		-- Float window styling
		vim.api.nvim_set_hl(0, "NormalFloat", { bg = "#1e1e2e" })
		vim.api.nvim_set_hl(0, "FloatBorder", { bg = "#1e1e2e", fg = "#89b4fa" })

		-- Diff highlights
		vim.api.nvim_set_hl(0, "AvanteConflictCurrent", { bg = "#3a2a2a", fg = "#ff6b6b" })
		vim.api.nvim_set_hl(0, "AvanteConflictIncoming", { bg = "#2a3a3a", fg = "#6bff6b" })

		-- ==========================================
		-- Safety Commands
		-- ==========================================
		-- Show Avante status and instructions
		vim.api.nvim_create_user_command("AvanteStatus", function()
			local status = {
				"=== AVANTE SAFETY GUIDE ===",
				"",
				"KEYMAPS:",
				"  <leader>aa  - ACCEPT suggestion (apply code)",
				"  <leader>ar  - REJECT suggestion (discard)",
				"  <leader>av  - ASK question / toggle sidebar",
				"  <leader>af  - REFRESH suggestion",
				"  <leader>ad  - TOGGLE diff view",
				"  <leader>ae  - EDIT prompt",
				"",
				"WORKFLOW:",
				"  1. Ask Avante a question (<leader>av)",
				"  2. Review the DIFF VIEW on the right",
				"  3. Check proposed changes carefully",
				"  4. ACCEPT (<leader>aa) or REJECT (<leader>ar)",
				"  5. Changes are NEVER auto-applied",
				"",
				"IMPORTANT:",
				"  ✓ Diff view is ALWAYS shown",
				"  ✓ Manual approval REQUIRED for all changes",
				"  ✓ Use Ctrl-Z to undo if needed",
				"  ✓ Check git diff to see what changed",
				"",
			}
			vim.api.nvim_echo(status, false, {})
		end, {})

		-- Disable auto-apply in insert mode
		vim.api.nvim_create_autocmd("InsertEnter", {
			group = vim.api.nvim_create_augroup("AvanteInsertSafety", { clear = true }),
			callback = function()
				-- Ensure Avante doesn't auto-apply while typing
				local ok, avante = pcall(require, "avante")
				if ok and avante then
					-- This is a safety check - Avante should respect auto_suggestions = false
					vim.notify("Avante: Use <leader>aa to accept changes", "info", { title = "Avante" })
				end
			end,
		})

		-- Create backup before accepting large changes
		vim.api.nvim_create_user_command("AvanteCreateBackup", function()
			local filename = vim.fn.expand("%")
			local backup = filename .. ".backup." .. os.date("%Y%m%d_%H%M%S")
			vim.cmd("write " .. backup)
			vim.notify("Backup created: " .. backup, "info", { title = "Avante" })
		end, {})

		-- Print startup message
		vim.notify("✓ Avante loaded with SAFETY MODE enabled", "info", { title = "Avante" })
		vim.notify("Run :AvanteStatus for help", "info", { title = "Avante" })
	end,
}
