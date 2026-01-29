local M = {}

function M.compiler()
	local install = require("nvim-treesitter.install")
	install.compilers = { "clang" }
	install.command_extra_args = {
		clang = { "-O0" },
	}
end

function M.autocmd()
	vim.api.nvim_create_autocmd("FileType", {
		callback = function(args)
			pcall(vim.treesitter.start, args.buf)
		end,
	})
end

return M
