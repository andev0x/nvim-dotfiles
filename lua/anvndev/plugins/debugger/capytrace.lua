return {
	{
		"andev0x/capytrace.nvim",
		build = "make",
		event = "VeryLazy",
		config = function()
			require("capytrace").setup({
				output_format = "markdown", -- or "json"
				save_path = "~/capytrace_logs/",
			})
		end,
	},
}
