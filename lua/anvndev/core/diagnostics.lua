-- ~/.config/nvim/lua/anvndev/core/diagnostics.lua
-- ==================================================
-- 🎯 Centralized Diagnostic Configuration
-- ==================================================

-- Define custom diagnostic icons
local signs = {
	Error = " ",
	Warn = " ",
	Hint = "󰌵 ",
	Info = " ",
}

-- Register the signs with Neovim
for type, icon in pairs(signs) do
	local hl = "DiagnosticSign" .. type
	vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
end

-- Global diagnostic configuration
vim.diagnostic.config({
	-- Disable inline text diagnostics
	virtual_text = false,

	-- Keep underlines for errors/warnings
	underline = true,

	-- Do not update diagnostics while typing
	update_in_insert = false,

	-- Sort diagnostics by severity (Error > Warn > Info > Hint)
	severity_sort = true,

	-- Configure floating window (when hovering)
	float = {
		border = "rounded",
		focusable = true,
		header = "",
		source = "if_many",
		prefix = function(diagnostic)
			local icons = {
				[vim.diagnostic.severity.ERROR] = " ",
				[vim.diagnostic.severity.WARN] = " ",
				[vim.diagnostic.severity.INFO] = " ",
				[vim.diagnostic.severity.HINT] = "󰌵 ",
			}
			return icons[diagnostic.severity] or ""
		end,
	},

	-- Configure sign column (left symbols)
	signs = {
		text = {
			[vim.diagnostic.severity.ERROR] = signs.Error,
			[vim.diagnostic.severity.WARN] = signs.Warn,
			[vim.diagnostic.severity.INFO] = signs.Info,
			[vim.diagnostic.severity.HINT] = signs.Hint,
		},
	},
})
