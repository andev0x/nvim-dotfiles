return {
	"andev0x/codeguide.nvim",
	-- This tells lazy.nvim to only load the plugin when you run these commands
	cmd = { "CodeGuideAnalyze", "CodeGuideToggle" },
	config = function()
		require("codeguide").setup({
			auto_analyze = true,
			go = {
				enabled = true,
				binary = "codeguide-go",
			},
		})
	end,
}
