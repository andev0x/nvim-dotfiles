-- ~/.config/nvim/lua/anvndev/core/autocmds.lua
-- ==================================================
-- Autocommands for anvndev Neovim setup
-- Author: anvndev
-- ==================================================

-- Shortcuts
local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

-- --------------------------------------------------
-- General Settings
-- --------------------------------------------------
local general = augroup("General", { clear = true })

-- Highlight text on yank
autocmd("TextYankPost", {
	group = general,
	callback = function()
		-- FIX: Updated from vim.highlight.on_yank to vim.hl.on_yank
		vim.hl.on_yank({ higroup = "IncSearch", timeout = 200 })
	end,
	desc = "Highlight selected text on yank",
})

-- Auto-resize splits when the window size changes
autocmd("VimResized", {
	group = general,
	callback = function()
		vim.cmd("tabdo wincmd =")
	end,
	desc = "Automatically resize splits on window resize",
})

-- Auto-create missing directories when saving a file
-- (e.g., :w new_folder/file.txt will create new_folder automatically)
autocmd("BufWritePre", {
	group = general,
	callback = function(event)
		if event.match:match("^%w%w+://") then
			return
		end
		-- Note: vim.loop is typically vim.uv in newer versions, but vim.loop still works for compatibility
		local file = vim.loop.fs_realpath(event.match) or event.match
		vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
	end,
	desc = "Auto-create parent directories before saving a file",
})

-- Close certain utility filetypes with 'q' instead of :q
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
		"checkhealth",
	},
	callback = function(event)
		vim.bo[event.buf].buflisted = false
		vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = event.buf, silent = true })
	end,
	desc = "Close utility buffers with 'q'",
})

-- Restore last cursor position when reopening a file
autocmd("BufReadPost", {
	group = general,
	callback = function()
		local mark = vim.api.nvim_buf_get_mark(0, '"')
		local lcount = vim.api.nvim_buf_line_count(0)
		if mark[1] > 0 and mark[1] <= lcount then
			pcall(vim.api.nvim_win_set_cursor, 0, mark)
		end
	end,
	desc = "Restore cursor position when reopening a file",
})

-- --------------------------------------------------
-- Language Specific Settings (Indentation)
-- --------------------------------------------------
local language = augroup("LanguageSettings", { clear = true })

-- Go indentation (Tab width 4)
autocmd("FileType", {
	group = language,
	pattern = "go",
	callback = function()
		vim.opt_local.expandtab = false
		vim.opt_local.tabstop = 4
		vim.opt_local.shiftwidth = 4
	end,
	desc = "Set Go indentation to tabs (4 spaces width)",
})

-- Rust indentation (Tab width 4)
autocmd("FileType", {
	group = language,
	pattern = "rust",
	callback = function()
		vim.opt_local.expandtab = false
		vim.opt_local.tabstop = 4
		vim.opt_local.shiftwidth = 4
	end,
	desc = "Set Rust indentation to tabs (4 spaces width)",
})

-- --------------------------------------------------
-- Terminal Settings
-- --------------------------------------------------
local terminal = augroup("TerminalSettings", { clear = true })

-- Remove line numbers and start in insert mode for terminal buffers
autocmd("TermOpen", {
	group = terminal,
	callback = function()
		vim.opt_local.number = false
		vim.opt_local.relativenumber = false
		vim.cmd("startinsert")
	end,
	desc = "Auto enter insert mode in terminal",
})

-- --------------------------------------------------
-- Treesitter Safety Check
-- --------------------------------------------------
-- Ensure syntax highlighting is enabled if for some reason it didn't load
autocmd("BufWinEnter", {
	callback = function(args)
		local buf = args.buf
		local ft = vim.bo[buf].filetype
		local ok, parsers = pcall(require, "nvim-treesitter.parsers")
		if not ok then
			return
		end
		local parser = parsers.get_parser(buf, ft)
		if not parser then
			vim.defer_fn(function()
				pcall(vim.cmd, "TSBufEnable highlight")
			end, 80)
		end
	end,
	desc = "Force enable Treesitter highlight if missing",
})
