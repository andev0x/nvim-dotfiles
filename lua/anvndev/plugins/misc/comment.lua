-- ~/.config/nvim/lua/anvndev/plugins/misc/comment.lua
-- Comment plugin configuration
-- Author: anvndev

return {
	{
		"numToStr/Comment.nvim",
		event = { "BufReadPost", "BufNewFile" },
		dependencies = {
			"JoosepAlviste/nvim-ts-context-commentstring",
		},
		config = function()
			require("Comment").setup({
				padding = true,
				sticky = true,
				ignore = nil,
				-- Disable ALL default mappings to prevent gc/gcc creation
				mappings = {
					basic = false,
					extra = false,
					extended = false,
				},
				pre_hook = function(ctx)
					-- Only calculate commentstring for tsx/jsx files
					if
						vim.bo.filetype == "typescriptreact"
						or vim.bo.filetype == "javascriptreact"
						or vim.bo.filetype == "vue"
					then
						local U = require("Comment.utils")

						-- Determine whether to use linewise or blockwise commentstring
						local type = ctx.ctype == U.ctype.linewise and "__default" or "__multiline"

						-- Determine the location where to calculate commentstring from
						local location = nil
						if ctx.ctype == U.ctype.blockwise then
							location = require("ts_context_commentstring.utils").get_cursor_location()
						elseif ctx.cmotion == U.cmotion.v or ctx.cmotion == U.cmotion.V then
							location = require("ts_context_commentstring.utils").get_visual_start_location()
						end

						return require("ts_context_commentstring.internal").calculate_commentstring({
							key = type,
							location = location,
						})
					end
				end,
				post_hook = nil,
			})

			-- Set up custom keymaps using Comment API with distinct keys (no overlaps)
			local api = require("Comment.api")
			local esc = vim.api.nvim_replace_termcodes("<ESC>", true, false, true)

			-- Line comment
			vim.keymap.set("n", "<leader>//", api.toggle.linewise.current, { desc = "Toggle comment line" })

			-- Comment with motion - <leader>cm (c = comment, m = motion)
			vim.keymap.set("n", "<leader>/m", function()
				return require("Comment.api").toggle.linewise.opfunc
			end, { expr = true, desc = "Toggle comment motion" })

			-- Comment in visual mode - <leader>cv (c = comment, v = visual)
			vim.keymap.set("v", "<leader>/v", function()
				vim.api.nvim_feedkeys(esc, "nx", false)
				api.toggle.linewise(vim.fn.visualmode())
			end, { desc = "Toggle comment selection" })

			-- Block comment line - <leader>cb (c = comment, b = block)
			vim.keymap.set("n", "<leader>cb", api.toggle.blockwise.current, { desc = "Toggle block comment line" })

			-- Block comment with motion - <leader>cB (c = comment, B = block motion)
			vim.keymap.set("n", "<leader>cB", function()
				return require("Comment.api").toggle.blockwise.opfunc
			end, { expr = true, desc = "Toggle block comment motion" })

			-- Block comment in visual mode - <leader>cV (c = comment, V = visual block)
			vim.keymap.set("v", "<leader>cV", function()
				vim.api.nvim_feedkeys(esc, "nx", false)
				api.toggle.blockwise(vim.fn.visualmode())
			end, { desc = "Toggle block comment selection" })

			-- Extra mappings with distinct keys
			vim.keymap.set("n", "<leader>cO", api.insert.linewise.above, { desc = "Add comment above" })
			vim.keymap.set("n", "<leader>co", api.insert.linewise.below, { desc = "Add comment below" })
			vim.keymap.set("n", "<leader>cA", api.insert.linewise.eol, { desc = "Add comment at end of line" })

			-- Unmap any gc/gcc mappings that might have been created
			vim.schedule(function()
				pcall(vim.keymap.del, "n", "gc")
				pcall(vim.keymap.del, "n", "gcc")
				pcall(vim.keymap.del, "n", "gbc")
				pcall(vim.keymap.del, "n", "gcO")
				pcall(vim.keymap.del, "n", "gco")
				pcall(vim.keymap.del, "n", "gcA")
				pcall(vim.keymap.del, "v", "gc")
				pcall(vim.keymap.del, "v", "gb")
			end)
		end,
	},

	-- Context-aware commentstring
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
