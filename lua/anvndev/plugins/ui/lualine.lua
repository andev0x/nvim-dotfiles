-- ~/.config/nvim/lua/anvndev/plugins/ui/lualine.lua
-- Lualine and UI enhancements configuration
-- Author: anvndev

return {
	-- Markdown preview (via Node)
	{
		-- "andev0x/mdview.nvim",
		-- 	build = "npm install",
		-- 	config = function()
		-- 		require("mdview").setup()
		-- 	end,
		-- },

		-- Markdown Rendering for interactive buttons
		{
			"MeanderingProgrammer/render-markdown.nvim",
			opts = { file_types = { "markdown" } },
			ft = { "markdown" },
		},

		-- Git diff viewer
		{
			"sindrets/diffview.nvim",
			event = "VeryLazy",
		},

		-- Statusline setup
		{
			"nvim-lualine/lualine.nvim",
			event = "VeryLazy",
			dependencies = { "nvim-tree/nvim-web-devicons", "SmiteshP/nvim-navic" },
			config = function()
				local navic = require("nvim-navic")
				local devicons = require("nvim-web-devicons")

				-- Custom component: username
				local function user_name()
					local hour = tonumber(os.date("%H"))
					local is_day = hour >= 6 and hour < 18
					local icon = is_day and "󰈸" or "󰏒"
					return string.format("%s anvndev", icon)
				end

				-- Custom component: filetype with icon
				local function filetype_with_icon()
					local fname = vim.fn.expand("%:t")
					local ext = vim.fn.expand("%:e")
					local icon, _ = devicons.get_icon(fname, ext, { default = true })
					local ft = vim.bo.filetype ~= "" and vim.bo.filetype or "plain"
					return string.format("%s %s", icon or "", ft)
				end

				-- Custom component: dynamic time-based icon
				local function time_icon()
					local hour = tonumber(os.date("%H"))
					local icons = {
						{ 5, 11, "🌞" },
						{ 11, 13, "🥪" },
						{ 13, 14, "☕" },
						{ 14, 17, "⛅" },
						{ 17, 19, "🌵" },
						{ 19, 22, "🌙" },
						{ 22, 23, "🪐" },
						{ 0, 5, "🌚" },
					}
					for _, v in ipairs(icons) do
						if hour >= v[1] and hour < v[2] then
							return v[3]
						end
					end
					return "🌚"
				end

				-- Optional: color changes based on time of day
				local function day_color()
					local h = tonumber(os.date("%H"))
					if h >= 6 and h < 18 then
						return { fg = "#EBCB8B" } -- day tone
					else
						return { fg = "#02210C" } -- night tone
					end
				end

				require("lualine").setup({
					options = {
						icons_enabled = true,
						theme = "catppuccin-mocha",
						section_separators = { left = "", right = "" },
						component_separators = { left = "", right = "" },
						globalstatus = true,
						always_divide_middle = true,
						refresh = { statusline = 1000 }, -- refresh every 1s for dynamic icon
					},

					sections = {
						lualine_a = {
							{ user_name, color = day_color },
							{ "mode", icon = "" },
						},
						lualine_b = {
							{ "branch", icon = "" },
							{
								"diff",
								symbols = {
									added = " ",
									modified = " ",
									removed = " ",
								},
							},
							{
								"diagnostics",
								sources = { "nvim_diagnostic" },
								symbols = {
									error = " ",
									warn = " ",
									info = " ",
									hint = " ",
								},
								colored = true,
								update_in_insert = false,
							},
						},
						lualine_c = {
							filetype_with_icon,
							{
								"filename",
								path = 1,
								symbols = {
									modified = " [+]",
									readonly = " ",
									unnamed = "[No Name]",
									newfile = "[New]",
								},
								icon = "",
							},
							{
								function()
									return navic.is_available() and navic.get_location() or ""
								end,
								cond = function()
									return navic.is_available()
								end,
								color = { fg = "#A3BE8C" },
							},
						},
						lualine_x = {
							time_icon,
							"encoding",
							"fileformat",
						},
						lualine_y = { "progress" },
						lualine_z = { "location" },
					},

					inactive_sections = {
						lualine_a = {},
						lualine_b = {},
						lualine_c = { "filename" },
						lualine_x = { "location" },
						lualine_y = {},
						lualine_z = {},
					},

					extensions = {
						"nvim-tree",
						"toggleterm",
						"quickfix",
						"fugitive",
						"man",
					},
				})
			end,
		},

		-- Breadcrumbs (code context)
		{
			"SmiteshP/nvim-navic",
			lazy = true,
			config = function()
				require("nvim-navic").setup({
					highlight = true,
					separator = " > ",
					depth_limit = 0,
					depth_limit_indicator = "..",
				})
			end,
		},
	},
}
