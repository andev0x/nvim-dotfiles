-- Comment plugin configuration (optimized - using default mappings)
-- Author: anvndev

return {
	{
		"numToStr/Comment.nvim",
		event = { "BufReadPost", "BufNewFile" },
		dependencies = {
			"JoosepAlviste/nvim-ts-context-commentstring",
		},

		config = function()
			local U = require("Comment.utils")

			-- Pre-hook to support contextual commentstring for TSX / JSX / Vue
			local function pre_hook(ctx)
				local ft = vim.bo.filetype

				-- Only apply for mixed-syntax languages
				if ft ~= "typescriptreact" and ft ~= "javascriptreact" and ft ~= "vue" then
					return
				end

				local ts_utils = require("ts_context_commentstring.utils")
				local ts_internal = require("ts_context_commentstring.internal")

				-- Determine whether the comment is linewise or blockwise
				local key = (ctx.ctype == U.ctype.linewise) and "__default" or "__multiline"

				-- Determine exact location in AST
				local location
				if ctx.ctype == U.ctype.blockwise then
					location = ts_utils.get_cursor_location()
				elseif ctx.cmotion == U.cmotion.v or ctx.cmotion == U.cmotion.V then
					location = ts_utils.get_visual_start_location()
				end

				return ts_internal.calculate_commentstring({
					key = key,
					location = location,
				})
			end

			-- Setup Comment.nvim using default keymaps
			require("Comment").setup({
				padding = true,
				sticky = true,
				mappings = {
					basic = true, -- Enables gc, gcc, gbc
					extra = true, -- Enables gco, gcO, gcA
					extended = false,
				},
				pre_hook = pre_hook,
			})
		end,
	},

	-- Context-aware commentstring setup
	{
		"JoosepAlviste/nvim-ts-context-commentstring",
		lazy = true,
		dependencies = { "nvim-treesitter/nvim-treesitter" },
		config = function()
			require("ts_context_commentstring").setup({
				enable_autocmd = false,
				languages = {
					typescript = "// %s",
					css = "/* %s */",
					scss = "/* %s */",
					html = "<!-- %s -->",
					svelte = "<!-- %s -->",
					vue = "<!-- %s -->",
					json = "",
				},
			})
		end,
	},
}
