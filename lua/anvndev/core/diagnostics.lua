-- ~/.config/nvim/lua/anvndev/core/diagnostics.lua
-- ==================================================
-- 🎯 Centralized Diagnostic Configuration
-- ==================================================

-- Custom diagnostic icons for each severity level
local signs = {
	Error = " ",
	Warn = " ",
	Hint = "󰌵 ",
	Info = " ",
}

-- Global diagnostic behavior configuration
vim.diagnostic.config({
	-- Disable inline diagnostic virtual text (cleaner look)
	virtual_text = false,

	-- Keep underlines for errors and warnings
	underline = true,

	-- Do not update diagnostics while typing
	update_in_insert = false,

	-- Sort diagnostics by severity (Error > Warn > Info > Hint)
	severity_sort = true,

	-- Floating diagnostic window configuration
	float = {
		border = "rounded",
		focusable = true,
		header = "",
		source = "if_many",
		prefix = function(diagnostic)
			local icons = {
				[vim.diagnostic.severity.ERROR] = " ",
				[vim.diagnostic.severity.WARN] = " ",
				[vim.diagnostic.severity.INFO] = "󰙎 ",
				[vim.diagnostic.severity.HINT] = "󰌵 ",
			}
			return icons[diagnostic.severity] or ""
		end,
	},

	-- Sign column configuration (left gutter)
	signs = {
		text = {
			[vim.diagnostic.severity.ERROR] = signs.Error,
			[vim.diagnostic.severity.WARN] = signs.Warn,
			[vim.diagnostic.severity.INFO] = signs.Info,
			[vim.diagnostic.severity.HINT] = signs.Hint,
		},
	},
})

-- Optional: Hide "~" filler lines at the end of the buffer
vim.opt.fillchars:append({ eob = " " })
