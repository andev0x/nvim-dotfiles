-- ~/.config/nvim/lua/anvndev/plugins/misc/treesitter.lua
-- Treesitter configuration
-- Author: anvndev

return {
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		event = { "BufReadPre", "BufNewFile" },
		dependencies = {
			"nvim-treesitter/nvim-treesitter-textobjects",
			"windwp/nvim-ts-autotag",
			"nvim-treesitter/playground",
		},
		config = function()
			require("nvim-treesitter.configs").setup({
				-- A list of parser names, or "all" (the five listed parsers should always be installed)
				ensure_installed = {
					"bash",
					"c",
					"cpp",
					"go",
					"java",
					"javascript",
					"json",
					"lua",
					"markdown",
					"markdown_inline",
					"python",
					"rust",
					"toml",
					"tsx",
					"typescript",
					"vim",
					"vimdoc",
					"yaml",
				},

				-- Install parsers synchronously (only applied to `ensure_installed`)
				sync_install = false,

				-- Automatically install missing parsers when entering buffer
				auto_install = true,

				-- List of parsers to ignore installing (or "all")
				ignore_install = {},

				highlight = {
					enable = true,

					-- NOTE: these are the names of the parsers and not the filetype. (for example if you want to
					-- disable highlighting for the `tex` filetype, you need to include `latex` in this list as this is
					-- the name of the parser)
					-- list of language that will be disabled
					disable = {},

					-- Setting this to true will run `:h syntax` and tree-sitter at the same time.
					-- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
					-- Using this option may slow down your editor, and you may see some duplicate highlights.
					-- Instead of true it can also be a list of languages
					additional_vim_regex_highlighting = false,
				},

				indent = {
					enable = true,
					disable = { "yaml" },
				},

				autotag = {
					enable = true,
				},

				playground = {
					enable = true,
					disable = {},
					updatetime = 25, -- Debounced time for highlighting nodes in the playground from source code
					persist_queries = false, -- Whether the query persists across vim sessions
					keybindings = {
						toggle_query_editor = "o",
						toggle_hl_groups = "i",
						toggle_injected_languages = "t",
						toggle_anonymous_nodes = "a",
						toggle_language_display = "I",
						focus_language = "f",
						unfocus_language = "F",
						update = "R",
						goto_node = "<cr>",
						show_help = "?",
					},
				},

				textobjects = {
					select = {
						enable = true,
						lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
						keymaps = {
							-- You can use the capture groups defined in textobjects.scm
							["aa"] = "@parameter.outer",
							["ia"] = "@parameter.inner",
							["af"] = "@function.outer",
							["if"] = "@function.inner",
							["ac"] = "@class.outer",
							["ic"] = "@class.inner",
							["al"] = "@loop.outer",
							["il"] = "@loop.inner",
							["ai"] = "@conditional.outer",
							["ii"] = "@conditional.inner",
							["ab"] = "@block.outer",
							["ib"] = "@block.inner",
							["as"] = "@statement.outer",
							["is"] = "@statement.inner",
							["am"] = "@comment.outer",
							["im"] = "@comment.inner",
						},
					},
					move = {
						enable = true,
						set_jumps = true, -- whether to set jumps in the jumplist
						goto_next_start = {
							["]m"] = "@function.outer",
							["]]"] = "@class.outer",
							["]b"] = "@block.outer",
							["]a"] = "@parameter.outer",
							["]l"] = "@loop.outer",
							["]c"] = "@conditional.outer",
							["]s"] = "@statement.outer",
						},
						goto_next_end = {
							["]M"] = "@function.outer",
							["]["] = "@class.outer",
							["]B"] = "@block.outer",
							["]A"] = "@parameter.outer",
							["]L"] = "@loop.outer",
							["]C"] = "@conditional.outer",
							["]S"] = "@statement.outer",
						},
						goto_previous_start = {
							["[m"] = "@function.outer",
							["[["] = "@class.outer",
							["[b"] = "@block.outer",
							["[a"] = "@parameter.outer",
							["[l"] = "@loop.outer",
							["[c"] = "@conditional.outer",
							["[s"] = "@statement.outer",
						},
						goto_previous_end = {
							["[M"] = "@function.outer",
							["[]"] = "@class.outer",
							["[B"] = "@block.outer",
							["[A"] = "@parameter.outer",
							["[L"] = "@loop.outer",
							["[C"] = "@conditional.outer",
							["[S"] = "@statement.outer",
						},
					},
					swap = {
						enable = true,
						swap_next = {
							["<leader>sa"] = "@parameter.inner",
						},
						swap_previous = {
							["<leader>sA"] = "@parameter.inner",
						},
					},
				},
			})
		end,
	},
}
