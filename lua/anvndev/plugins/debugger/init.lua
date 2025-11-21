-- ~/.config/nvim/lua/anvndev/plugins/debugger/init.lua
-- ==================================================
-- Debugger Configuration
-- Author: anvndev
-- ==================================================

return {
	{
		"mfussenegger/nvim-dap",
		dependencies = {
			{ "rcarriga/nvim-dap-ui" }, -- Debug UI
			{ "theHamsta/nvim-dap-virtual-text" }, -- Inline variable preview
			{ "jay-babu/mason-nvim-dap.nvim", dependencies = { "williamboman/mason.nvim" } },
			"nvim-neotest/nvim-nio", -- Added explicit dependency for new dap-ui versions
		},

		config = function()
			local dap = require("dap")
			local dapui = require("dapui")

			-- ==========================
			-- DAP UI Setup
			-- ==========================
			dapui.setup({
				icons = { expanded = "▾", collapsed = "▸", current_frame = "▸" },
				mappings = {
					expand = { "<CR>", "<2-LeftMouse>" },
					open = "o",
					remove = "d",
					edit = "e",
					repl = "r",
					toggle = "t",
				},
				expand_lines = vim.fn.has("nvim-0.7") == 1,
				layouts = {
					{
						elements = {
							{ id = "scopes", size = 0.25 },
							"breakpoints",
							"stacks",
							"watches",
						},
						size = 40,
						position = "left",
					},
					{
						elements = { "repl", "console" },
						size = 0.25,
						position = "bottom",
					},
				},
				controls = {
					enabled = true,
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
					border = "single",
					mappings = { close = { "q", "<Esc>" } },
				},
				windows = { indent = 1 },
				render = { max_value_lines = 100 },
			})

			-- ==========================
			-- Virtual Text Setup
			-- ==========================
			require("nvim-dap-virtual-text").setup({
				enabled = true,
				enabled_commands = true,
				highlight_changed_variables = true,
				show_stop_reason = true,
				commented = false,
				virt_text_pos = "eol",
			})

			-- ==========================
			-- Mason DAP Setup
			-- ==========================
			local ok, mason = pcall(require, "mason")
			if ok then
				mason.setup()
			end

			require("mason-nvim-dap").setup({
				ensure_installed = { "delve", "codelldb", "debugpy" },
				automatic_installation = true,
				handlers = {
					function(config)
						require("mason-nvim-dap").default_setup(config)
					end,
				},
				automatic_setup = true,
			})

			-- ==========================
			-- Auto UI Handling
			-- ==========================
			dap.listeners.after.event_initialized["dapui_config"] = function()
				dapui.open()
			end
			dap.listeners.before.event_terminated["dapui_config"] = function()
				dapui.close()
			end
			dap.listeners.before.event_exited["dapui_config"] = function()
				dapui.close()
			end

			-- ==========================
			-- Load Language-Specific Debug Configurations
			-- ==========================
			-- Ensure these modules exist, otherwise comment them out
			pcall(require, "anvndev.plugins.debugger.go")
			pcall(require, "anvndev.plugins.debugger.rust")
			pcall(require, "anvndev.plugins.debugger.python")
			pcall(require, "anvndev.plugins.debugger.cpp")

			-- ==========================
			-- DAP Signs Configuration (FIXED)
			-- ==========================
			-- We must use vim.fn.sign_define, NOT vim.diagnostic.config
			local dap_signs = {
				{ name = "DapBreakpoint", text = "", texthl = "DiagnosticSignError" },
				{ name = "DapBreakpointCondition", text = "", texthl = "DiagnosticSignWarn" },
				{ name = "DapLogPoint", text = "", texthl = "DiagnosticSignInfo" },
				{ name = "DapStopped", text = "", texthl = "DiagnosticSignHint", linehl = "Visual" },
				{ name = "DapBreakpointRejected", text = "", texthl = "DiagnosticSignError" },
			}

			for _, sign in ipairs(dap_signs) do
				vim.fn.sign_define(sign.name, {
					text = sign.text,
					texthl = sign.texthl,
					linehl = sign.linehl or "",
					numhl = "",
				})
			end
		end,
	},
}
