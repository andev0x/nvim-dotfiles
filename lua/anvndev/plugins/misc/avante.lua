return {
	"yetone/avante.nvim",
	event = "VeryLazy",
	lazy = false, -- Recommended: Disable lazy loading to ensure proper initialization
	version = false, -- set this if you want to always pull the latest change

	-- IMPORTANT: This is the fix for the "missing avante_templates" error.
	-- It compiles the necessary Rust core components.
	build = "make",

	dependencies = {
		"nvim-treesitter/nvim-treesitter", -- Required for syntax highlighting
		"stevearc/dressing.nvim", -- Recommended: Improves the UI for inputs
		"nvim-lua/plenary.nvim",
		"MunifTanjim/nui.nvim",
		"zbirenbaum/copilot.lua", -- Your AI provider

		-- Optional: Support for image pasting
		{
			"HakonHarnes/img-clip.nvim",
			event = "VeryLazy",
			opts = {
				default = {
					embed_image_as_base64 = false,
					prompt_for_file_name = false,
					drag_and_drop = {
						insert_mode = true,
					},
				},
			},
		},
	},

	config = function()
		--  Setup Copilot BEFORE Avante
		-- We disable Copilot's native suggestions to avoid UI clutter with Avante
		require("copilot").setup({
			suggestion = { enabled = false },
			panel = { enabled = false },
		})

		-- 2️⃣ Setup Avante with Copilot provider
		require("avante").setup({
			provider = "copilot",

			behaviour = {
				auto_suggestions = false, -- Recommended: Disable auto-suggestions if using Copilot provider to prevent conflicts
				auto_set_keymaps = false, -- We will define custom keymaps below
			},

			ui = {
				position = "right", -- Options: "right" | "left" | "bottom"
				width = 40, -- Width of the AI sidebar
			},
		})

		-- 3️⃣ Custom keymaps for Avante
		local map = vim.keymap.set
		local opts = { noremap = true, silent = true }

		-- Ask AI a question
		map(
			{ "n", "v" },
			"<leader>va",
			"<cmd>AvanteAsk<CR>",
			vim.tbl_extend("force", opts, { desc = "Avante: Ask AI" })
		)

		-- Edit selected code using AI
		map(
			{ "n", "v" },
			"<leader>ve",
			"<cmd>AvanteEdit<CR>",
			vim.tbl_extend("force", opts, { desc = "Avante: Edit code with AI" })
		)

		-- Toggle Avante chat window
		map(
			"n",
			"<leader>vc",
			"<cmd>AvanteToggle<CR>",
			vim.tbl_extend("force", opts, { desc = "Avante: Toggle AI Chat" })
		)

		-- Refresh AI response
		map(
			"n",
			"<leader>vr",
			"<cmd>AvanteRefresh<CR>",
			vim.tbl_extend("force", opts, { desc = "Avante: Refresh AI response" })
		)

		-- Stop ongoing AI generation
		map(
			"n",
			"<leader>vs",
			"<cmd>AvanteStop<CR>",
			vim.tbl_extend("force", opts, { desc = "Avante: Stop AI action" })
		)
	end,
}
