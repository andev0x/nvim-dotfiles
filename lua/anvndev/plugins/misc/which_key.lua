return {
	"folke/which-key.nvim",
	event = "VeryLazy",
	init = function()
		vim.o.timeout = true
		vim.o.timeoutlen = 400
	end,
	opts = {
		preset = "modern",
		delay = function(ctx)
			return ctx.plugin and 0 or 200
		end,
		spec = {
			{ mode = { "n", "v" }, { "<leader>b", group = "Buffer" }, { "<leader>d", group = "Debug" }, { "<leader>f", group = "Find" }, { "<leader>g", group = "Git" }, { "<leader>k", group = "Testing" }, { "<leader>l", group = "LSP" }, { "<leader>t", group = "Toggle/Term" }, { "<leader>x", group = "Diagnostics" } },
		},
	},
}
