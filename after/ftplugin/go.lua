-- ~/.config/nvim/after/ftplugin/go.lua
-- Go specific settings

-- Set indentation
vim.opt_local.expandtab = false
vim.opt_local.tabstop = 4
vim.opt_local.shiftwidth = 4

-- Set compiler
vim.opt_local.makeprg = "go build"
vim.opt_local.errorformat = "%f:%l:%c: %m"

-- Key mappings
local opts = { noremap = true, silent = true, buffer = true }

-- Go specific mappings
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

-- Auto commands
local group = vim.api.nvim_create_augroup("GoSettings", { clear = true })

-- Format on save
vim.api.nvim_create_autocmd("BufWritePre", {
  group = group,
  buffer = 0,
  callback = function()
    require("go.format").goimport()
  end,
})

-- Run tests on save
vim.api.nvim_create_autocmd("BufWritePost", {
  group = group,
  pattern = "*_test.go",
  callback = function()
    require("go.test").test_file()
  end,
})