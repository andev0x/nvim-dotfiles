return {
	"kdheepak/lazygit.nvim",
	cmd = "LazyGit",
	config = function()
		-- You can add any specific configuration for lazygit here.
		-- For example, setting up keymaps to open lazygit.
		local wk = require("which-key")
		wk.add({
			mode = "n", -- Normal mode
			{"<leader>gg", ":LazyGit<CR>", desc = "Open LazyGit"},
		})
	end,
}