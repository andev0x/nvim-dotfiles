-- ~/.config/nvim/lua/anvndev/plugins/ui/icons.lua
-- Icons configuration for various filetypes

return {
	{
		"nvim-tree/nvim-web-devicons",
		lazy = true,
		config = function()
			require("nvim-web-devicons").setup({
				override = {
					go = {
						icon = "󰟓", -- Go gopher icon (Nerd Font)
						color = "#00ADD8",
						cterm_color = "65",
						name = "Go",
					},
					rust = {
						icon = "", -- Rust gear icon
						color = "#F74C00",
						cterm_color = "202",
						name = "Rust",
					},
					py = {
						icon = "", -- Python icon
						color = "#3572A5",
						cterm_color = "67",
						name = "Python",
					},
					java = {
						icon = "", -- Java coffee cup icon
						color = "#E76F00",
						cterm_color = "166",
						name = "Java",
					},
					cpp = {
						icon = "", -- C++ icon
						color = "#659BD3",
						cterm_color = "75",
						name = "Cpp",
					},
					c = {
						icon = "", -- C icon
						color = "#599EDD",
						cterm_color = "75",
						name = "C",
					},
				},
				default = true,
			})
		end,
	},
}

