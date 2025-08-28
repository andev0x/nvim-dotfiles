-- ~/.config/nvim/lua/anvndev/core/autocmds.lua
-- Autocommands

local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

-- General settings
local general = augroup("General", { clear = true })

-- Highlight on yank
autocmd("TextYankPost", {
	group = general,
	callback = function()
		vim.hl.on_yank({
			higroup = "IncSearch",
			timeout = 300,
		})
	end,
	desc = "Highlight on yank",
})

-- Resize splits on window resize
autocmd("VimResized", {
	group = general,
	callback = function()
		vim.cmd("tabdo wincmd =")
	end,
	desc = "Resize splits on window resize",
})

-- Auto create dir when saving a file
autocmd("BufWritePre", {
	group = general,
	callback = function(event)
		if event.match:match("^%w%w+://") then
			return
		end
		local file = vim.loop.fs_realpath(event.match) or event.match
		vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
	end,
	desc = "Create directory if it doesn't exist",
})

-- Close some filetypes with <q>
autocmd("FileType", {
	group = general,
	pattern = {
		"qf",
		"help",
		"man",
		"notify",
		"lspinfo",
		"spectre_panel",
		"startuptime",
		"tsplayground",
		"PlenaryTestPopup",
	},
	callback = function(event)
		vim.bo[event.buf].buflisted = false
		vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = event.buf, silent = true })
	end,
	desc = "Close some filetypes with <q>",
})

-- Go to last location when opening a buffer
autocmd("BufReadPost", {
	group = general,
	callback = function()
		local mark = vim.api.nvim_buf_get_mark(0, '"')
		local lcount = vim.api.nvim_buf_line_count(0)
		if mark[1] > 0 and mark[1] <= lcount then
			pcall(vim.api.nvim_win_set_cursor, 0, mark)
		end
	end,
	desc = "Go to last location when opening a buffer",
})

-- Auto format on save (if formatter available)
autocmd("BufWritePre", {
	group = general,
	callback = function()
		vim.lsp.buf.format({ async = false })
	end,
	desc = "Format on save",
})

-- Language specific settings
local language_settings = augroup("LanguageSettings", { clear = true })

-- Go settings
autocmd("FileType", {
	group = language_settings,
	pattern = "go",
	callback = function()
		vim.opt_local.expandtab = false
		vim.opt_local.tabstop = 4
		vim.opt_local.shiftwidth = 4
	end,
	desc = "Go indentation settings",
})

-- Rust settings
autocmd("FileType", {
	group = language_settings,
	pattern = "rust",
	callback = function()
		vim.opt_local.tabstop = 4
		vim.opt_local.shiftwidth = 4
	end,
	desc = "Rust indentation settings",
})

-- Terminal settings
local terminal_settings = augroup("TerminalSettings", { clear = true })

-- Enter insert mode when opening terminal
autocmd("TermOpen", {
	group = terminal_settings,
	callback = function()
		vim.opt_local.number = false
		vim.opt_local.relativenumber = false
		vim.cmd("startinsert")
	end,
	desc = "Enter insert mode when opening terminal",
})

-- LSP settings
local lsp_settings = augroup("LspSettings", { clear = true })

-- LSP keymaps when attaching to buffer
autocmd("LspAttach", {
	group = lsp_settings,
	callback = function(event)
		local opts = { buffer = event.buf, silent = true }
		vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
		vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
		vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
		vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
		vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, opts)
		vim.keymap.set("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, opts)
		vim.keymap.set("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, opts)
		vim.keymap.set("n", "<leader>wl", function()
			print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
		end, opts)
		vim.keymap.set("n", "<leader>D", vim.lsp.buf.type_definition, opts)
		vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
		vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)
		vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
		vim.keymap.set("n", "<leader>lf", function()
			vim.lsp.buf.format({ async = true })
		end, opts)
	end,
	desc = "LSP keymaps when attaching to buffer",
})

-- Configure diagnostics
vim.diagnostic.config({
	signs = {
		text = {
			[vim.diagnostic.severity.ERROR] = "",
			[vim.diagnostic.severity.WARN] = "",
			[vim.diagnostic.severity.INFO] = "",
			[vim.diagnostic.severity.HINT] = "",
		},
	},
	virtual_text = true,
	underline = true,
	severity_sort = true,
	float = {
		border = "rounded",
		source = "always",
	},
})

