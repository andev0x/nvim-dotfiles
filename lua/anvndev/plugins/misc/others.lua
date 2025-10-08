-- ~/.config/nvim/lua/anvndev/plugins/misc/others.lua
-- Miscellaneous utility plugins

return {
	-- Auto pairs
	{
		"windwp/nvim-autopairs",
		event = "InsertEnter",
		config = function()
			local npairs = require("nvim-autopairs")
			npairs.setup({
				check_ts = true,
				ts_config = {
					lua = { "string", "source" },
					javascript = { "string", "template_string" },
					java = false,
				},
				disable_filetype = { "TelescopePrompt", "spectre_panel" },
				fast_wrap = {
					map = "<M-e>",
					chars = { "{", "[", "(", '"', "'" },
					pattern = string.gsub([[ [%'%"%)%>%]%)%}%,] ]], "%s+", ""),
					offset = 0,
					end_key = "$",
					keys = "qwertyuiopzxcvbnmasdfghjkl",
					check_comma = true,
					highlight = "PmenuSel",
					highlight_grey = "LineNr",
				},
			})

			local cmp_autopairs = require("nvim-autopairs.completion.cmp")
			local cmp = require("cmp")
			cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done({ map_char = { tex = "" } }))
		end,
	},

	-- Surround
	{
		"kylechui/nvim-surround",
		event = "VeryLazy",
		config = true,
	},

	-- Indent guides
	{
		"lukas-reineke/indent-blankline.nvim",
		event = { "BufReadPost", "BufNewFile" },
		main = "ibl",
		opts = {
			indent = { char = "│", tab_char = "│" },
			scope = { enabled = true },
			exclude = {
				filetypes = {
					"help",
					"alpha",
					"dashboard",
					"neo-tree",
					"Trouble",
					"lazy",
					"mason",
					"notify",
					"toggleterm",
					"lazyterm",
				},
			},
		},
	},

	-- Terminal
	{
		"akinsho/toggleterm.nvim",
		version = "*",
		cmd = "ToggleTerm",
		keys = {
			{ "<leader>t", "<cmd>ToggleTerm<cr>", desc = "Toggle terminal" },
			{ "<leader>tf", "<cmd>ToggleTerm direction=float<cr>", desc = "Float terminal" },
			{ "<leader>th", "<cmd>ToggleTerm direction=horizontal<cr>", desc = "Horizontal terminal" },
			{ "<leader>tv", "<cmd>ToggleTerm direction=vertical<cr>", desc = "Vertical terminal" },
		},
		config = function()
			require("toggleterm").setup({
				size = function(term)
					if term.direction == "horizontal" then
						return 15
					elseif term.direction == "vertical" then
						return vim.o.columns * 0.4
					end
				end,
				open_mapping = [[<c-\>]],
				hide_numbers = true,
				shading_factor = 2,
				start_in_insert = true,
				persist_size = true,
				direction = "float",
				close_on_exit = true,
				shell = vim.o.shell,
				float_opts = {
					border = "curved",
					winblend = 0,
					highlights = { border = "Normal", background = "Normal" },
				},
			})

			local Terminal = require("toggleterm.terminal").Terminal
			local terms = {
				lazygit = Terminal:new({ cmd = "lazygit", hidden = true, direction = "float" }),
				node = Terminal:new({ cmd = "node", hidden = true, direction = "float" }),
				python = Terminal:new({ cmd = "python3", hidden = true, direction = "float" }),
				go = Terminal:new({ cmd = "gore", hidden = true, direction = "float" }),
			}

			_G._LAZYGIT_TOGGLE = function()
				terms.lazygit:toggle()
			end
			_G._NODE_TOGGLE = function()
				terms.node:toggle()
			end
			_G._PYTHON_TOGGLE = function()
				terms.python:toggle()
			end
			_G._GO_TOGGLE = function()
				terms.go:toggle()
			end

			vim.keymap.set("n", "<leader>gg", _LAZYGIT_TOGGLE, { desc = "LazyGit" })
			vim.keymap.set("n", "<leader>tn", _NODE_TOGGLE, { desc = "Node REPL" })
			vim.keymap.set("n", "<leader>tp", _PYTHON_TOGGLE, { desc = "Python REPL" })
			vim.keymap.set("n", "<leader>tg", _GO_TOGGLE, { desc = "Go REPL" })
		end,
	},

	-- Which-key
	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		config = function()
			require("which-key").setup({
				plugins = {
					marks = true,
					registers = true,
					spelling = { enabled = true, suggestions = 20 },
					presets = {
						operators = true,
						motions = true,
						text_objects = true,
						windows = true,
						nav = true,
						z = true,
						g = true,
					},
				},
				icons = { breadcrumb = "»", separator = "➜", group = "+" },
				win = { border = "rounded", position = "bottom", padding = { 2, 2, 2, 2 } },
				layout = { height = { min = 4, max = 25 }, width = { min = 20, max = 50 }, spacing = 3 },
				triggers = { "<leader>" },
			})
		end,
	},

	-- Notify
	{
		"rcarriga/nvim-notify",
		event = "VeryLazy",
		config = function()
			local notify = require("notify")
			local function time_icon()
				local hour = tonumber(os.date("%H"))
				if hour < 5 then
					return "🌙"
				end
				if hour < 12 then
					return "☀️"
				end
				if hour < 17 then
					return "⛅"
				end
				if hour < 20 then
					return "🍹"
				end
				return "🌙"
			end

			notify.setup({
				stages = "fade",
				timeout = 3000,
				render = "default",
				background_colour = "#000000",
				icons = {
					ERROR = time_icon(),
					WARN = "⚠️",
					INFO = "ℹ️",
					DEBUG = "🔍",
					TRACE = "✎",
				},
			})

			vim.notify = function(msg, level, opts)
				opts = opts or {}
				opts.icon = time_icon()
				return notify(msg, level, opts)
			end
		end,
	},

	-- Dressing UI
	{
		"stevearc/dressing.nvim",
		event = "VeryLazy",
		opts = {
			input = { border = "rounded", prefer_width = 40 },
			select = {
				backend = { "telescope", "fzf_lua", "fzf", "builtin", "nui" },
				builtin = { border = "rounded" },
			},
		},
	},

	-- Web devicons
	{
		"nvim-tree/nvim-web-devicons",
		event = "VeryLazy",
		opts = {
			override = {
				go = { icon = "", color = "#519aba", name = "Go" },
				py = { icon = "󰌠", color = "#ffd43b", name = "Python" },
			},
			default = true,
		},
	},

	-- Todo comments
	{
		"folke/todo-comments.nvim",
		event = { "BufReadPost", "BufNewFile" },
		dependencies = { "nvim-lua/plenary.nvim" },
		opts = {
			signs = true,
			keywords = {
				FIX = { icon = "", color = "error", alt = { "FIXME", "BUG" } },
				TODO = { icon = "", color = "info" },
				HACK = { icon = "", color = "warning" },
				WARN = { icon = "", color = "warning" },
				PERF = { icon = "" },
				NOTE = { icon = "󰍨", color = "hint" },
			},
		},
	},

	-- Trouble
	{
		"folke/trouble.nvim",
		cmd = { "Trouble", "TroubleToggle" },
		dependencies = { "nvim-tree/nvim-web-devicons" },
		keys = {
			{ "<leader>xx", "<cmd>TroubleToggle<cr>", desc = "Toggle Trouble" },
			{ "<leader>xw", "<cmd>TroubleToggle workspace_diagnostics<cr>", desc = "Workspace Diagnostics" },
			{ "<leader>xd", "<cmd>TroubleToggle document_diagnostics<cr>", desc = "Document Diagnostics" },
			{ "gR", "<cmd>TroubleToggle lsp_references<cr>", desc = "LSP References" },
		},
		opts = {
			position = "bottom",
			height = 10,
			icons = true,
			mode = "workspace_diagnostics",
			auto_open = false,
			auto_close = false,
			use_diagnostic_signs = false,
		},
	},

	-- Mini icons
	{
		"echasnovski/mini.icons",
		event = "VeryLazy",
		config = true,
	},
}
