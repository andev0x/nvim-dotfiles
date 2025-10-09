-- ~/.config/nvim/after/ftplugin/go.lua
-- Buffer-local settings for Go files

-- Indentation
vim.opt_local.expandtab = false
vim.opt_local.tabstop = 4
vim.opt_local.shiftwidth = 4

-- Compiler configuration
vim.opt_local.makeprg = "go build"
vim.opt_local.errorformat = "%f:%l:%c: %m"

-- Key mappings
local opts = { noremap = true, silent = true, buffer = true }

-- Go-specific commands
vim.keymap.set("n", "<leader>gr", "<cmd>GoRun<CR>", opts)
vim.keymap.set("n", "<leader>gt", "<cmd>GoTest<CR>", opts)
vim.keymap.set("n", "<leader>gtf", "<cmd>GoTestFunc<CR>", opts)
vim.keymap.set("n", "<leader>gc", "<cmd>GoCoverage<CR>", opts)
vim.keymap.set("n", "<leader>gi", "<cmd>GoImport<CR>", opts)
vim.keymap.set("n", "<leader>gfs", "<cmd>GoFillStruct<CR>", opts)
vim.keymap.set("n", "<leader>gat", "<cmd>GoAddTag<CR>", opts)
vim.keymap.set("n", "<leader>grt", "<cmd>GoRmTag<CR>", opts)
vim.keymap.set("n", "<leader>gie", "<cmd>GoIfErr<CR>", opts)
vim.keymap.set("n", "<leader>gal", "<cmd>GoAlt<CR>", opts)

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

-- Run tests on save for *_test.go (safe require)
vim.api.nvim_create_autocmd("BufWritePost", {
	group = group,
	pattern = "*_test.go",
	callback = function()
		local ok, gotest = pcall(require, "go.test")
		if ok then
			gotest.test_file()
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
