-- ~/.config/nvim/lua/anvndev/core/autocmds.lua
-- ==================================================
-- ⚙️ Autocommands for anvndev Neovim setup
-- ==================================================

-- Shortcuts
local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

-- --------------------------------------------------
-- 🧩 General Settings
-- --------------------------------------------------
local general = augroup("General", { clear = true })

-- Highlight text on yank
autocmd("TextYankPost", {
	group = general,
	callback = function()
		vim.highlight.on_yank({ higroup = "IncSearch", timeout = 200 })
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
autocmd("BufWritePre", {
	group = general,
	callback = function(event)
		if event.match:match("^%w%w+://") then
			return
		end
		local file = vim.loop.fs_realpath(event.match) or event.match
		vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
	end,
	desc = "Auto-create parent directories before saving a file",
})

-- Close certain filetypes with 'q'
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

-- Auto format before saving (skip Lua to avoid corruption)
autocmd("BufWritePre", {
	group = general,
	callback = function()
		if vim.bo.filetype ~= "lua" then
			pcall(vim.lsp.buf.format, { async = false })
		end
	end,
	desc = "Auto-format before saving (except Lua)",
})

-- --------------------------------------------------
-- 🧠 Language Specific Settings
-- --------------------------------------------------
local language = augroup("LanguageSettings", { clear = true })

-- Go indentation
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

-- Rust indentation
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
-- 🖥️ Terminal Settings
-- --------------------------------------------------
local terminal = augroup("TerminalSettings", { clear = true })

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
-- 🧰 LSP Settings
-- --------------------------------------------------
local lsp = augroup("LspSettings", { clear = true })

-- Set up LSP keymaps when LSP attaches
autocmd("LspAttach", {
	group = lsp,
	callback = function(event)
		local opts = { buffer = event.buf, silent = true }
		local map = vim.keymap.set

		map("n", "gD", vim.lsp.buf.declaration, opts)
		map("n", "gd", vim.lsp.buf.definition, opts)
		map("n", "K", vim.lsp.buf.hover, opts)
		map("n", "gi", vim.lsp.buf.implementation, opts)
		map("n", "<C-k>", vim.lsp.buf.signature_help, opts)
		map("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, opts)
		map("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, opts)
		map("n", "<leader>wl", function()
			print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
		end, opts)
		map("n", "<leader>D", vim.lsp.buf.type_definition, opts)
		map("n", "<leader>rn", vim.lsp.buf.rename, opts)
		map({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)
		map("n", "gr", vim.lsp.buf.references, opts)
		map("n", "<leader>lf", function()
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
	virtual_text = false, -- Disable inline diagnostics
	underline = true,
	update_in_insert = false,
	severity_sort = true,
	float = {
		border = "rounded",
		source = "always",
	},
})

-- Show diagnostics popup when cursor holds
autocmd("CursorHold", {
	callback = function()
		vim.diagnostic.open_float(nil, { focus = false })
	end,
	desc = "Show diagnostics popup on cursor hold",
})

-- --------------------------------------------------
-- 🌳 Treesitter Safety Check
-- --------------------------------------------------
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

-- ==================================================
-- 🧠 End of autocmds.lua
-- ==================================================