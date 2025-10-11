-- ~/.config/nvim/lua/anvndev/core/diagnostics.lua
-- ==================================================
-- 🎯 Centralized Diagnostic Configuration
-- ==================================================

-- Custom diagnostic icons for each severity level
local signs = {
	Error = " ",
	Warn = " ",
	Hint = "󰌵 ",
	Info = " ",
}

-- Safe helper to define diagnostic signs (compatible with Neovim 0.9 and 0.10+)
local define_sign = function(name, opts)
	if vim.diagnostic and vim.diagnostic.define_sign then
		vim.diagnostic.define_sign(name, opts)
	else
		vim.fn.sign_define(name, opts)
	end
end

-- Register all diagnostic signs
for type, icon in pairs(signs) do
	local hl = "DiagnosticSign" .. type
	define_sign(hl, { text = icon, texthl = hl, numhl = "" })
end

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
				[vim.diagnostic.severity.ERROR] = " ",
				[vim.diagnostic.severity.WARN] = " ",
				[vim.diagnostic.severity.INFO] = " ",
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
