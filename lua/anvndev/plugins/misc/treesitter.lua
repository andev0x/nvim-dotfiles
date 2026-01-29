-- Treesitter configuration
-- Author: anvndev
-- Safe for:
--   - Neovim 0.11+
--   - Apple Silicon M1–M4
--   - Linux
--   - clean install on new machines

return {
	{
		"nvim-treesitter/nvim-treesitter",

		-- Treesitter must be available before other plugins use it
		priority = 100,
		event = { "BufReadPost", "BufNewFile" },

		build = ":TSUpdate",

		config = function()
			------------------------------------------------------------------
			-- Compiler (portable)
			------------------------------------------------------------------
			local ok_install, install = pcall(require, "nvim-treesitter.install")
			if ok_install then
				-- Never hardcode only clang → Linux users die
				install.compilers = { "clang", "gcc" }
			end

			------------------------------------------------------------------
			-- Treesitter setup (new API)
			------------------------------------------------------------------
			local ok_config, config = pcall(require, "nvim-treesitter.config")
			if not ok_config then
				vim.notify("nvim-treesitter.config not found. Please run :Lazy sync", vim.log.levels.ERROR)
				return
			end

			config.setup({

				ensure_installed = {
					"lua",
					"vim",
					"vimdoc",
					"go",
					"rust",
					"c",
					"cpp",
					"python",
					"javascript",
					"typescript",
					"html",
					"css",
					"json",
					"yaml",
					"bash",
					"markdown",
					"markdown_inline",
				},

				auto_install = true,

				highlight = {
					enable = true,
					additional_vim_regex_highlighting = false,
				},

				indent = {
					enable = true,
				},

				incremental_selection = {
					enable = true,
					keymaps = {
						init_selection = "<C-space>",
						node_incremental = "<C-space>",
						node_decremental = "<BS>",
					},
				},
			})
		end,
	},

	-- Autotag - separate plugin
	{
		"windwp/nvim-ts-autotag",
		event = { "BufReadPost", "BufNewFile" },
		dependencies = { "nvim-treesitter/nvim-treesitter" },
		config = function()
			require("nvim-ts-autotag").setup({
				opts = {
					enable_close = true,
					enable_rename = true,
					enable_close_on_slash = false,
				},
			})
		end,
	},

	-- Textobjects - DISABLED until compatible with new treesitter API
	-- The current version of nvim-treesitter-textobjects requires nvim-treesitter.configs
	-- which no longer exists in the latest nvim-treesitter
	-- Alternative: Use built-in Neovim text objects or wait for plugin update
	--
	-- {
	-- 	"nvim-treesitter/nvim-treesitter-textobjects",
	-- 	event = { "BufReadPost", "BufNewFile" },
	-- 	dependencies = { "nvim-treesitter/nvim-treesitter" },
	-- },
}
