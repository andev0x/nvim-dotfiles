-- ~/.config/nvim/after/ftplugin/go.lua
-- Buffer-local settings for Go files

-- Indentation
vim.opt_local.expandtab = false
vim.opt_local.tabstop = 4
vim.opt_local.shiftwidth = 4

-- Compiler configuration
vim.opt_local.makeprg = "go build"
vim.opt_local.errorformat = "%f:%l:%c: %m"

-- Autocommand group
local group = vim.api.nvim_create_augroup("GoSettings", { clear = true })

-- Format before saving (safe require)
vim.api.nvim_create_autocmd("BufWritePre", {
	group = group,
	buffer = 0,
	callback = function()
		local ok, gofmt = pcall(require, "go.format")
		if ok then
			gofmt.goimport()
		end
	end,
})

-- Automatically open quickfix window after build/test errors
vim.api.nvim_create_autocmd("QuickFixCmdPost", {
	pattern = { "make", "GoTest" },
	callback = function()
		vim.cmd("copen")
	end,
})

vim.diagnostic.config({
	virtual_text = false,
}, vim.api.nvim_get_current_buf())
