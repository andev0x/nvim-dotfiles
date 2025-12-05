-- ~/.config/nvim/lua/anvndev/plugins/misc/which-key.lua
-- ==================================================
-- Keybinding Helper Configuration (Which-Key v3)
-- ==================================================

return {
	"folke/which-key.nvim",
	event = "VimEnter",
	init = function()
		-- Timeout settings are required for which-key to open automatically
		vim.o.timeout = true
		vim.o.timeoutlen = 300 -- Time in ms to wait before opening the popup
	end,
	opts = {
		-- ----------------------------------------------------------------
		-- UI & Layout Configuration
		-- ----------------------------------------------------------------
		-- "modern" is the default v3 style. Options: "classic", "modern", "helix"
		preset = "modern",

		-- Delay before showing the popup (in ms)
		delay = function(ctx)
			return ctx.plugin and 0 or 200
		end,

		-- Window configuration (Replaces the old 'window' and 'position' options)
		win = {
			border = "rounded",
			padding = { 2, 2 }, -- [top/bottom, right/left]
			-- 'margin' and 'position' are deprecated in v3, handled by 'wo' or layout presets
		},

		-- Icon settings
		icons = {
			breadcrumb = "»",
			separator = "➜",
			group = "+",
			-- v3 uses 'rules' to assign icons, but defaults are usually fine
		},

		-- Key label replacements (Replaces the old 'key_labels')
		replace = {
			["<space>"] = "SPC",
			["<cr>"] = "RET",
			["<tab>"] = "TAB",
		},

		-- ----------------------------------------------------------------
		-- Plugin Integrations
		-- ----------------------------------------------------------------
		plugins = {
			marks = true, -- shows a list of your marks on ' and `
			registers = true, -- shows your registers on " in NORMAL or <C-r> in INSERT mode
			spelling = {
				enabled = true, -- enabling this will show WhichKey when pressing z= to select suggestions
				suggestions = 20, -- how many suggestions should be shown in the list?
			},
			presets = {
				operators = true, -- adds help for operators like d, y, ...
				motions = true, -- adds help for motions
				text_objects = true, -- help for text objects triggered after entering an operator
				windows = true, -- default bindings on <c-w>
				nav = true, -- misc bindings to work with windows
				z = true, -- bindings for folds, spelling and others prefixed with z
				g = true, -- bindings for prefixed with g
			},
		},

		-- ----------------------------------------------------------------
		-- Mappings Registration (The 'Spec')
		-- ----------------------------------------------------------------
		-- In v3, mappings are defined in the 'spec' table.
		-- This fixes the overlap warnings by clearly defining Groups vs Commands.
		spec = {
			{
				mode = { "n", "v" }, -- Normal and Visual mode
				{ "<leader>b", group = "Buffers" },
				{ "<leader>C", group = "Code" },
				{ "<leader>d", group = "Debug" },
				{ "<leader>f", group = "Find/Files" },
				{ "<leader>g", group = "Git" },
				{ "<leader>l", group = "LSP" },
				{ "<leader>r", group = "Refactor" },
				{ "<leader>w", group = "Workspace" },
				{ "<leader>x", group = "Text" },

				-- Terminal & Toggles Group
				-- Note: Since 't' is the group, the toggle command must be 'tt'
				{ "<leader>t", group = "Terminal / Toggles" },
				{ "<leader>tf", desc = "Float terminal" },
				{ "<leader>th", desc = "Horizontal terminal" },
				{ "<leader>tl", desc = "Toggle invisible characters" },
				{ "<leader>to", group = "Toggle Options" }, -- Sub-group for specific toggles if needed
				{ "<leader>tr", desc = "Toggle relative line numbers" },
				{ "<leader>ts", desc = "Toggle spell check" },
				{ "<leader>tt", desc = "Toggle terminal" }, -- The main toggle command
				{ "<leader>tv", desc = "Vertical terminal" },
				{ "<leader>tw", desc = "Toggle word wrap" },

				-- Comment Group (non-overlapping keys)
				{ "<leader>c", group = "Comment" },
				{ "<leader>cc", desc = "Toggle comment line" },
				{ "<leader>cm", desc = "Toggle comment motion" },
				{ "<leader>cv", desc = "Toggle comment selection" },
				{ "<leader>cb", desc = "Toggle block comment line" },
				{ "<leader>cB", desc = "Toggle block comment motion" },
				{ "<leader>cV", desc = "Toggle block comment selection" },
				{ "<leader>cO", desc = "Add comment above" },
				{ "<leader>co", desc = "Add comment below" },
				{ "<leader>cA", desc = "Add comment at end of line" },

				-- Surround Group (nvim-surround with gz prefix)
				{ "gz", group = "Surround" },
				{ "gza", desc = "Add surrounding" },
				{ "gzl", desc = "Add surrounding (current line)" },
				{ "gzA", desc = "Add surrounding (new lines)" },
				{ "gzL", desc = "Add surrounding (current line, new lines)" },
				{ "gzd", desc = "Delete surrounding" },
				{ "gzr", desc = "Replace surrounding" },
				{ "gzR", desc = "Replace surrounding (new lines)" },
			},
		},
	},
}
