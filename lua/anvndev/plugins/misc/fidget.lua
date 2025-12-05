-- ~/.config/nvim/lua/anvndev/plugins/misc/fidget.lua
-- Custom Fidget UI - Minimal Dark Green Edition

return {
	"j-hui/fidget.nvim",
	tag = "legacy",
	event = "LspAttach",

	config = function()
		require("fidget").setup({
			notification = {
				filter = vim.log.levels.INFO,
				override_vim_notify = true,
				window = {
					winblend = 15,
					border = "rounded",
					normal_hl = "FidgetNormal",
					border_hl = "FidgetBorder",
				},
			},

			progress = {
				suppress_on_insert = false,
				ignore_done_already = true,

				display = {
					render_limit = 6,
					done_icon = "",
					progress_icon = "",
					group_icon = "",
					group_style = "Title",
				},

				lsp = {
					progress_ringbuf_size = 256,
				},
			},
		})

		-- Highlights MUST be inside config()
		vim.api.nvim_set_hl(0, "FidgetNormal", { fg = "#7aa87a", bg = "none" })
		vim.api.nvim_set_hl(0, "FidgetBorder", { fg = "#4c604c", bg = "none" })
	end,
}
