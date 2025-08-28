-- ~/.config/nvim/lua/anvndev/plugins/debugger/init.lua
-- Debugger configuration

return {
	{
		"mfussenegger/nvim-dap",
		dependencies = {
			-- UI for DAP
			{ "rcarriga/nvim-dap-ui" },

			-- Virtual text for DAP
			{ "theHamsta/nvim-dap-virtual-text" },

			-- Mason integration for DAP
			{ "jay-babu/mason-nvim-dap.nvim" },
		},
		config = function()
			local dap = require("dap")
			local dapui = require("dapui")

			-- Setup DAP UI
			dapui.setup({
				icons = { expanded = "▾", collapsed = "▸", current_frame = "▸" },
				mappings = {
					-- Use a table to apply multiple mappings
					expand = { "<CR>", "<2-LeftMouse>" },
					open = "o",
					remove = "d",
					edit = "e",
					repl = "r",
					toggle = "t",
				},
				-- Expand lines larger than the window
				expand_lines = vim.fn.has("nvim-0.7") == 1,
				layouts = {
					{
						elements = {
							-- Elements can be strings or table with id and size keys.
							{ id = "scopes", size = 0.25 },
							"breakpoints",
							"stacks",
							"watches",
						},
						size = 40, -- 40 columns
						position = "left",
					},
					{
						elements = {
							"repl",
							"console",
						},
						size = 0.25, -- 25% of total lines
						position = "bottom",
					},
				},
				controls = {
					-- Requires Neovim nightly (or 0.8 when released)
					enabled = true,
					-- Display controls in this element
					element = "repl",
					icons = {
						pause = "",
						play = "",
						step_into = "󰆹",
						step_over = "󰆸",
						step_out = "󰆺",
						step_back = "",
						run_last = "",
						terminate = "",
					},
				},
				floating = {
					max_height = nil, -- These can be integers or a float between 0 and 1.
					max_width = nil, -- Floats will be treated as percentage of your screen.
					border = "single", -- Border style. Can be "single", "double" or "rounded"
					mappings = {
						close = { "q", "<Esc>" },
					},
				},
				windows = { indent = 1 },
				render = {
					max_type_length = nil, -- Can be integer or nil.
					max_value_lines = 100, -- Can be integer or nil.
				},
			})

			-- Setup DAP virtual text
			require("nvim-dap-virtual-text").setup({
				enabled = true,
				enabled_commands = true,
				highlight_changed_variables = true,
				highlight_new_as_changed = false,
				show_stop_reason = true,
				commented = false,
				only_first_definition = true,
				all_references = false,
				filter_references_pattern = "<module",
				virt_text_pos = "eol",
				all_frames = false,
				virt_lines = false,
				virt_text_win_col = nil,
			})

			-- Setup Mason DAP
			require("mason-nvim-dap").setup({
				ensure_installed = { "delve", "codelldb", "debugpy" },
				automatic_installation = true,
				handlers = {
					function(config)
						-- All sources with no handler get passed here
						-- Keep original functionality
						require("mason-nvim-dap").default_setup(config)
					end,
				},
				automatic_setup = true,
			})

			-- Auto open/close DAP UI
			dap.listeners.after.event_initialized["dapui_config"] = function()
				dapui.open()
			end
			dap.listeners.before.event_terminated["dapui_config"] = function()
				dapui.close()
			end
			dap.listeners.before.event_exited["dapui_config"] = function()
				dapui.close()
			end

			-- Load language-specific debug configurations
			require("anvndev.plugins.debugger.go")
			require("anvndev.plugins.debugger.rust")
			require("anvndev.plugins.debugger.python")
			require("anvndev.plugins.debugger.cpp")

			-- Set up signs
			vim.fn.sign_define(
				"DapBreakpoint",
				{ text = "", texthl = "DiagnosticSignError", linehl = "", numhl = "" }
			)
			vim.fn.sign_define(
				"DapBreakpointCondition",
				{ text = "", texthl = "DiagnosticSignWarn", linehl = "", numhl = "" }
			)
			vim.fn.sign_define("DapLogPoint", { text = "", texthl = "DiagnosticSignInfo", linehl = "", numhl = "" })
			vim.fn.sign_define(
				"DapStopped",
				{ text = "", texthl = "DiagnosticSignHint", linehl = "DapStoppedLine", numhl = "" }
			)
			vim.fn.sign_define(
				"DapBreakpointRejected",
				{ text = "", texthl = "DiagnosticSignError", linehl = "", numhl = "" }
			)
		end,
	},
}
