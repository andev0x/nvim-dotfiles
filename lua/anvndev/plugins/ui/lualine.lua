-- ~/.config/nvim/lua/anvndev/plugins/ui/lualine.lua
-- Statusline configuration

return {
	-- Preview markdown
	{
		"andev0x/mdview.nvim",
		build = "npm install",
		config = function()
			require("mdview").setup()
		end,
	},
	-- Glow for markdown preview
	{
		"ellisonleao/glow.nvim",
		config = true,
		cmd = "Glow",
		ft = "markdown",
	},
	-- Diffview for git diffs
	{
		"sindrets/diffview.nvim",
		event = "VeryLazy",
	},
	{
		"nvim-lualine/lualine.nvim",
		event = "VeryLazy",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			local navic = require("nvim-navic")
			local devicons = require("nvim-web-devicons")
			-- Custom component: user name
			local function user_name()
				return " anvndev"
			end
			-- Custom component: filetype with icon
			local function filetype_with_icon()
				local ft = vim.bo.filetype or ""
				local fname = vim.api.nvim_buf_get_name(0)
				local ext = vim.fn.fnamemodify(fname, ":e")
				local icon, icon_hl = devicons.get_icon(fname, ext, { default = true })
				if icon == nil or icon == "" then
					icon = ""
				end
				return string.format("%s %s", icon, ft ~= "" and ft or "plain")
			end
			-- Custom component: time-based icon
			local function time_icon()
				local hour = tonumber(os.date("%H"))
				if hour >= 5 and hour < 11 then
					return "🌞"
				elseif hour >= 11 and hour < 13 then
					return "🥪"
				elseif hour >= 13 and hour < 14 then
					return "☕"
				elseif hour >= 14 and hour < 17 then
					return "⛅"
				elseif hour >= 17 and hour < 19 then
					return "🌵"
				elseif hour >= 19 and hour < 22 then
					return "🌙"
				elseif hour >= 22 and hour < 23 then
					return "🪐"
				else
					return "🌚"
				end
			end
			require("lualine").setup({
				options = {
					icons_enabled = true,
					theme = "catppuccin-mocha", -- dark theme, change if you prefer
					section_separators = { left = "", right = "" },
					component_separators = { left = "", right = "" },
					globalstatus = true,
					always_divide_middle = true,
				},
				sections = {
					lualine_a = {
						user_name,
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
							symbols = { error = " ", warn = " ", info = " ", hint = " " },
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
							icon = "",
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

	-- Breadcrumbs for code navigation
	{
		"SmiteshP/nvim-navic",
		lazy = true,
		dependencies = { "neovim/nvim-lspconfig" },
		config = function()
			require("nvim-navic").setup({
				highlight = true,
				separator = " > ",
				depth_limit = 0,
				depth_limit_indicator = "..",
			})
		end,
	},
}
