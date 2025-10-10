-- ~/.config/nvim/lua/anvndev/core/diagnostics.lua
-- Centralized diagnostic configuration

local signs = {
	Error = " ",
	Warn = " ",
	Hint = "󰌶 ",
	Info = " ",
}

for type, icon in pairs(signs) do
	local hl = "DiagnosticSign" .. type
	vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
end

vim.diagnostic.config({
	virtual_text = {
		prefix = "●",
		spacing = 2,
	},
	float = {
		border = "rounded",
		source = "always",
	},
	severity_sort = true,
	underline = true,
	update_in_insert = false,
})
