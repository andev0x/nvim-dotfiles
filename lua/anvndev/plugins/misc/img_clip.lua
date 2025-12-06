-- lua/anvndev/plugins/misc/img_clip.lua
-- Image paste support for Markdown / Docs
-- Safe, lazy-loaded, no startup overhead

return {
	"HakonHarnes/img-clip.nvim",
	ft = { "markdown", "norg", "mdx" }, -- only load when writing docs
	opts = {
		default = {
			dir_path = "assets/images",
			file_name = "%Y-%m-%d-%H-%M-%S",
			prompt_for_file_name = false,

			use_absolute_path = false,
			relative_to_current_file = true,
			embed_image_as_base64 = false,
		},
	},
	keys = {
		{
			"<leader>pi",
			"<cmd>PasteImage<cr>",
			desc = "Paste image into document",
		},
	},
}
