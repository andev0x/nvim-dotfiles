-- Central Treesitter entry point

local M = {}

function M.setup()
	M.setup_compiler()
	M.setup_configs()
	M.setup_safety()
end

function M.setup_compiler()
	require("anvndev.treesitter.safe").compiler()
end

function M.setup_configs()
	require("nvim-treesitter.configs").setup({
		ensure_installed = require("anvndev.treesitter.parsers"),
		highlight = require("anvndev.treesitter.highlight"),
		indent = require("anvndev.treesitter.indent"),
		autotag = require("anvndev.treesitter.autotag"),
		textobjects = require("anvndev.treesitter.textobjects"),
		auto_install = false,
	})
end

function M.setup_safety()
	require("anvndev.treesitter.safe").autocmd()
end

return M
