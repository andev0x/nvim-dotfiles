-- ~/.config/nvim/after/ftplugin/go.lua
-- Filetype-specific settings for Go
-- Optimized for stability and clean diagnostics (no inline messages)
-- Author: anvndev

-- ===============================
-- Indentation & syntax setup
-- ===============================
vim.opt_local.expandtab = false
vim.opt_local.tabstop = 4
vim.opt_local.shiftwidth = 4

-- ===============================
-- Build and error format
-- ===============================
vim.opt_local.makeprg = "go build"
vim.opt_local.errorformat = "%f:%l:%c: %m"

-- ===============================
-- Autocommands group
-- ===============================
local group = vim.api.nvim_create_augroup("GoFileSettings", { clear = true })

-- Auto-format and organize imports before saving
vim.api.nvim_create_autocmd("BufWritePre", {
	group = group,
	buffer = 0,
	callback = function()
		local ok, gofmt = pcall(require, "go.format")
		if ok then
			pcall(gofmt.goimport)
		end
	end,
})

-- Automatically open quickfix window after build/test errors
vim.api.nvim_create_autocmd("QuickFixCmdPost", {
	group = group,
	pattern = { "make", "GoTest" },
	callback = function()
		vim.schedule(function()
			vim.cmd("copen")
		end)
	end,
})

-- ===============================
-- NOTE: Diagnostics
-- ===============================
-- DO NOT override global diagnostic settings here
-- (Handled centrally in plugins/lang/go.lua)
-- This ensures inline errors stay disabled globally for Go files
