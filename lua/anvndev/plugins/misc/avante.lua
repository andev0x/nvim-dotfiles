-- File: lua/anvndev/plugins/misc/avante.lua
return {
	"yetone/avante.nvim",
	-- Avante needs to load early/eagerly for stability
	lazy = false,
	version = false,

	-- FIX: Use the stable build command (avoiding BUILD_FROM_SOURCE=true)
	build = vim.fn.has("win32") ~= 0 and "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false"
		or "make",

	dependencies = {
		"nvim-treesitter/nvim-treesitter",
		"nvim-lua/plenary.nvim",
		"MunifTanjim/nui.nvim",

		-- Input UI: Fixes transparent prompt issues
		{
			"stevearc/dressing.nvim",
			opts = {
				input = {
					win_options = { winblend = 0 },
					border = "rounded",
				},
			},
		},

		-- Markdown Rendering for interactive buttons
		{
			"MeanderingProgrammer/render-markdown.nvim",
			opts = { file_types = { "markdown", "Avante" } },
			ft = { "markdown", "Avante" },
		},

		-- Optional image support
		{
			"HakonHarnes/img-clip.nvim",
			event = "VeryLazy",
			opts = {
				default = {
					embed_image_as_base64 = false,
					prompt_for_file_name = false,
					drag_and_drop = { insert_mode = true },
					use_absolute_path = true,
				},
			},
		},
	},

	opts = {
		-- Core provider
		provider = "copilot",
		auto_suggestions_provider = "copilot",
		instructions_file = "avante.md",

		-- Behaviour settings
		behaviour = {
			-- IMPORTANT: Use default keymaps (keep Avante's defaults)
			auto_set_keymaps = true,
			-- Prevent Avante from auto-applying suggestions into buffers.
			-- Some providers (or upstream changes) can insert code without
			-- explicit accept. Disabling auto_suggestions ensures diffs
			-- are shown and changes are only applied when you accept them.
			auto_suggestions = false,
			debounce_time = 150,
		},

		-- UI settings
		ui = {
			position = "right",
			width = 40,
		},

		-- Enable interactive diff panel
		diff_view = {
			enabled = true,
		},
	},

	config = function(_, opts)
		-- 1. Setup Copilot (Disable native UI)
		require("copilot").setup({
			suggestion = { enabled = false },
			panel = { enabled = false },
		})

		-- 2. Setup Avante plugin
		require("avante").setup(opts)

		-- 3. Visual fixes
		vim.api.nvim_set_hl(0, "AvanteLineAdded", { bg = "#1f3b25" })
		vim.api.nvim_set_hl(0, "AvanteLineRemoved", { bg = "#4a2121" })
		vim.api.nvim_set_hl(0, "NormalFloat", { bg = "#1e1e2e" })
		vim.api.nvim_set_hl(0, "FloatBorder", { bg = "#1e1e2e", fg = "#89b4fa" })

		-- The default Avante keymaps are now fully active.
	end,
}
