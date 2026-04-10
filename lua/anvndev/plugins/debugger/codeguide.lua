return {
	"andev0x/codeguide.nvim",
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
