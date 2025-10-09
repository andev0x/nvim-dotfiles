-- ~/.config/nvim/lua/anvndev/core/autocmds.lua
-- ==================================================
-- ⚙️ Autocommands for anvndev Neovim setup
-- ==================================================

local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

-- --------------------------------------------------
-- 🧩 General Settings
-- --------------------------------------------------
local general = augroup("General", { clear = true })

-- Highlight on yank
autocmd("TextYankPost", {
	group = general,
	callback = function()
		vim.hl.on_yank({ higroup = "IncSearch", timeout = 300 })
	end,
	desc = "Highlight selected text on yank",
})

-- Resize splits automatically when window is resized
autocmd("VimResized", {
	group = general,
	callback = function()
		vim.cmd("tabdo wincmd =")
	end,
	desc = "Auto-resize splits on Vim resize",
})

-- Create missing directories when saving a file
autocmd("BufWritePre", {
	group = general,
	callback = function(event)
		if event.match:match("^%w%w+://") then return end
		local file = vim.loop.fs_realpath(event.match) or event.match
		vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
	end,
	desc = "Auto-create parent directories before saving",
})

-- Close specific filetypes with <q>
autocmd("FileType", {
	group = general,
	pattern = {
		"qf", "help", "man", "notify", "lspinfo",
		"spectre_panel", "startuptime", "tsplayground", "PlenaryTestPopup",
	},
	callback = function(event)
		vim.bo[event.buf].buflisted = false
		vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = event.buf, silent = true })
	end,
	desc = "Close utility buffers with <q>",
})

-- Jump to last edit position when reopening a file
autocmd("BufReadPost", {
	group = general,
	callback = function()
		local mark = vim.api.nvim_buf_get_mark(0, '"')
		local lcount = vim.api.nvim_buf_line_count(0)
		if mark[1] > 0 and mark[1] <= lcount then
			pcall(vim.api.nvim_win_set_cursor, 0, mark)
		end
	end,
	desc = "Restore cursor position on file reopen",
})

-- Auto format before saving if LSP formatter is available
autocmd("BufWritePre", {
	group = general,
	callback = function()
		pcall(vim.lsp.buf.format, { async = false })
	end,
	desc = "Auto-format before saving (if LSP supports it)",
})

-- --------------------------------------------------
-- 🧠 Language Specific Settings
-- --------------------------------------------------
local language_settings = augroup("LanguageSettings", { clear = true })

-- Go
autocmd("FileType", {
	group = language_settings,
	pattern = "go",
	callback = function()
		vim.opt_local.expandtab = false
		vim.opt_local.tabstop = 4
		vim.opt_local.shiftwidth = 4
	end,
	desc = "Set Go indentation rules",
})

-- Rust
autocmd("FileType", {
	group = language_settings,
	pattern = "rust",
	callback = function()
		vim.opt_local.tabstop = 4
		vim.opt_local.shiftwidth = 4
	end,
	desc = "Set Rust indentation rules",
})

-- --------------------------------------------------
-- 🖥️ Terminal Settings
-- --------------------------------------------------
local terminal_settings = augroup("TerminalSettings", { clear = true })

autocmd("TermOpen", {
	group = terminal_settings,
	callback = function()
		vim.opt_local.number = false
		vim.opt_local.relativenumber = false
		vim.cmd("startinsert")
	end,
	desc = "Auto enter insert mode in terminal",
})

-- --------------------------------------------------
-- 🧰 LSP Settings
-- --------------------------------------------------
local lsp_settings = augroup("LspSettings", { clear = true })

-- Setup LSP keymaps dynamically when attached
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
	desc = "Set LSP keymaps on attach",
})

-- --------------------------------------------------
-- 🪶 Diagnostics Configuration
-- --------------------------------------------------
vim.diagnostic.config({
	signs = {
		text = {
			[vim.diagnostic.severity.ERROR] = "",
			[vim.diagnostic.severity.WARN] = "",
			[vim.diagnostic.severity.INFO] = "",
			[vim.diagnostic.severity.HINT] = "",
		},
	},
	virtual_text = false, -- Disable inline text diagnostics
	underline = true,
	severity_sort = true,
	float = {
		border = "rounded",
		source = "always",
	},
})

-- Show diagnostic popup automatically when cursor stops
autocmd("CursorHold", {
	callback = function()
		vim.diagnostic.open_float(nil, { focus = false })
	end,
	desc = "Show diagnostics popup on cursor hold",
})

-- ==================================================
-- 🧠 End of autocmds.lua
-- ==================================================
