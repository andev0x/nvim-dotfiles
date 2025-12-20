return {
	"zbirenbaum/copilot.lua",
	event = "InsertEnter",
	config = function()
		require("copilot").setup({
			enable = true,
			autostart = true,
			panel = {
				enable = true,
				reveal = { "*" },
				layout = {
					position = "right", -- | top | bottom | left
					size = "30%", -- default is 1/3 of current window
				},
			},
			suggestion = {
				enable = true,
				auto_trigger = true,
				dim_color = { "#6e6a86", "#e0b162" }, -- Default from Cursor.nvim (Dracula theme)
				keymap = {
					accept = "<M-m>", -- Default from Cursor.nvim
					next = "<M-[>",
					prev = "<M-]>",
					-- dismiss = "<C-]-d>",
				},
			},
			filetypes = {
				markdown = true,
				help = false,
				gitcommit = false,
				gitrebase = false,
				diff = false,
				"", -- other filetypes
			},
		})
	end,
}
