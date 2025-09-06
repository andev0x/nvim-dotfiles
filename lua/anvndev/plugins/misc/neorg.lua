return {
	{
		"nvim-neorg/neorg",
		build = ":Neorg sync-parsers",
		ft = "norg",
		cmd = "Neorg",
		dependencies = { "nvim-lua/plenary.nvim", "nvim-treesitter/nvim-treesitter" },
		config = function()
			require("neorg").setup({
				load = {
					["core.defaults"] = {},
					["core.concealer"] = {
						config = {
							icon_preset = "varied",
						},
					},
					["core.dirman"] = {
						config = {
							workspaces = {
								notes = "~/notes",
							},
							default_workspace = "notes",
						},
					},
					["core.esupports.metagen"] = {},
					["core.integrations.telescope"] = {},
				},
			})
			local map = vim.keymap.set
			map("n", "<leader>nw", ":Neorg workspace notes<CR>", { desc = "Open Neorg workspace 'notes'" })
			map("n", "<leader>nr", ":Neorg return<CR>", { desc = "Return from Neorg" })
			map("n", "<leader>nt", ":Neorg toggle-concealer<CR>", { desc = "Toggle concealer" })
		end,
	},
}
