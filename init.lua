-- ~/.config/nvim/init.lua
-- Entry point for Neovim configuration
-- Author: anvndev

-- Bootstrap lazy.nvim if not installed
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

-- Set leader key before lazy
vim.g.mapleader = " "
vim.g.maplocalleader = ","

-- SQLFormat
-- vim.api.nvim_set_keymap("v", "<Leader>f", "<Plug>SQLFormat", { noremap = true, silent = true })
-- vim.cmd([[command! SQLFormat call sqlformat#Format(1, line('$'))]])
--
-- Python Provider
do
	local python_candidates = {
		vim.fn.exepath("python3"),
		"/opt/homebrew/bin/python3",
		"/usr/local/bin/python3",
	}
	for _, python in ipairs(python_candidates) do
		if python ~= nil and python ~= "" and vim.fn.executable(python) == 1 then
			vim.g.python3_host_prog = python
			break
		end
	end
end

-- Load core settings
require("anvndev.core.options")
require("anvndev.core.keymaps")
require("anvndev.core.autocmds")

-- Initialize lazy.nvim with plugins
require("lazy").setup("anvndev.plugins", {
	install = {
		colorscheme = { "catppuccin" },
	},
	checker = {
		enabled = false,
		notify = false,
	},
	change_detection = {
		notify = false,
	},
	performance = {
		rtp = {
			disabled_plugins = {
				"gzip",
				"matchit",
				"matchparen",
				"netrwPlugin",
				"tarPlugin",
				"tohtml",
				"tutor",
				"zipPlugin",
			},
		},
	},
	ui = {
		border = "rounded",
	},
})
