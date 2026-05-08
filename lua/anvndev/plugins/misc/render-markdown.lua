-- ~/.config/nvim/lua/anvndev/plugins/misc/render-markdown.lua
-- Enhanced markdown and MDX rendering in the buffer
-- Author: anvndev

return {
	{
		"MeanderingProgrammer/render-markdown.nvim",
		dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" },
		ft = { "markdown", "mdx" },
		opts = {
			file_types = { "markdown", "mdx" },
			-- Custom configuration to make MDX look good
			code = {
				sign = false,
				width = "block",
				right_pad = 1,
			},
			heading = {
				sign = false,
				icons = { "󰲡 ", "󰲣 ", "󰲥 ", "󰲧 ", "󰲩 ", "󰲫 " },
			},
		},
	},
}
