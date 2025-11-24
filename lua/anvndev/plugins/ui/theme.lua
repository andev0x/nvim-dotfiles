-- ~/.config/nvim/lua/anvndev/plugins/ui/theme.lua
-- Theme configuration
-- Author: anvndev

return {
	{
		"catppuccin/nvim",
		name = "catppuccin",
		lazy = false,
		priority = 1000,
		config = function()
			require("catppuccin").setup({
				flavour = "mocha", -- latte, frappe, macchiato, mocha
				background = { -- :h background
					light = "latte",
					dark = "mocha",
				},
				transparent_background = true,
				show_end_of_buffer = false,
				term_colors = true,
				dim_inactive = {
					enabled = false,
					shade = "dark",
					percentage = 0.15,
				},
				no_italic = false,
				no_bold = false,
				no_underline = false,
				styles = {
					comments = { "italic" },
					conditionals = { "italic" },
					loops = {},
					functions = {},
					keywords = {},
					strings = {},
					variables = {},
					numbers = {},
					booleans = {},
					properties = {},
					types = {},
					operators = {},
				},
				color_overrides = {},
				custom_highlights = {},
				integrations = {
					cmp = true,
					gitsigns = true,
					nvimtree = true,
					telescope = true,
					notify = false,
					mini = false,
				},
			})

			-- Set the theme
			vim.cmd.colorscheme("catppuccin")
			-- Ensure Telescope highlight groups exist (some themes may not define them
			-- until later; link to sensible defaults).
			do
				local safe_links = {
					TelescopeBorder = "Normal",
					TelescopeNormal = "Normal",
					TelescopePromptNormal = "Normal",
					TelescopePromptBorder = "Normal",
					TelescopePreviewBorder = "Normal",
					TelescopeResultsBorder = "Normal",
					TelescopePromptPrefix = "Question",
					TelescopeSelection = "PmenuSel",
					TelescopeSelectionCaret = "PmenuSel",
					TelescopeMatching = "Search",
					TelescopeMultiSelection = "PmenuSel",
				}

				for group, link in pairs(safe_links) do
					if vim.fn.hlexists(group) == 0 then
						pcall(vim.cmd, string.format("highlight link %s %s", group, link))
					end
				end
			end
			-- Reapply links whenever the colorscheme is changed to handle runtime
			-- theme switches or reloads.
			vim.api.nvim_create_autocmd("ColorScheme", {
				callback = function()
					local safe_links = {
						TelescopeBorder = "Normal",
						TelescopeNormal = "Normal",
						TelescopePromptNormal = "Normal",
						TelescopePromptBorder = "Normal",
						TelescopePreviewBorder = "Normal",
						TelescopeResultsBorder = "Normal",
						TelescopePromptPrefix = "Question",
						TelescopeSelection = "PmenuSel",
						TelescopeSelectionCaret = "PmenuSel",
						TelescopeMatching = "Search",
						TelescopeMultiSelection = "PmenuSel",
					}
					for group, link in pairs(safe_links) do
						if vim.fn.hlexists(group) == 0 then
							pcall(vim.cmd, string.format("highlight link %s %s", group, link))
						end
					end
				end,
			})
		end,
	},

	-- Other themes (commented out but available if needed)
	-- {
	--   "catppuccin/nvim",
	--   name = "catppuccin",
	--   lazy = true,
	-- },
	-- {
	--   "ellisonleao/gruvbox.nvim",
	--   lazy = true,
	-- },
}

