return {
	"CopilotC-Nvim/CopilotChat.nvim",
	lazy = true,

	-- Load plugin when these commands are called
	cmd = {
		"CopilotChatToggle",
		"CopilotChatExplain",
		"CopilotChatReview",
		"CopilotChat",
	},

	-- Basic lazy-load keymaps (safe, no 'q')
	keys = {
		{ "<leader>zct", "<cmd>CopilotChatToggle<CR>", desc = "Toggle CopilotChat" },
		{ "<leader>zce", "<cmd>CopilotChatExplain<CR>", desc = "Explain code" },
	},

	dependencies = {
		"nvim-lua/plenary.nvim",
		"zbirenbaum/copilot.lua",
		"nvim-telescope/telescope.nvim",
		"folke/which-key.nvim",
	},

	opts = {
		window = { border = "rounded" },
	},

	config = function(_, opts)
		local chat = require("CopilotChat")
		local select = require("CopilotChat.select")
		chat.setup(opts)

		local wk = require("which-key")

		-- NORMAL MODE mappings
		wk.add({
			{ "<leader>zc", group = "CopilotChat" },

			{ "<leader>zct", "<cmd>CopilotChatToggle<CR>", desc = "Toggle chat" },
			{ "<leader>zce", "<cmd>CopilotChatExplain<CR>", desc = "Explain code" },

			{
				"<leader>zca",
				function()
					chat.ask()
				end,
				desc = "Ask Copilot",
			},
			{
				"<leader>zcr",
				function()
					chat.review()
				end,
				desc = "Review code",
			},
		}, { mode = "n" })

		-- VISUAL MODE mappings
		wk.add({
			{ "<leader>zc", group = "CopilotChat" },

			{ "<leader>zce", "<cmd>CopilotChatExplain<CR>", desc = "Explain selection" },

			{
				"<leader>zca",
				function()
					chat.ask({ selection = select.visual })
				end,
				desc = "Ask on selection",
			},
			{
				"<leader>zcr",
				function()
					chat.review({ selection = select.visual })
				end,
				desc = "Review selection",
			},
		}, { mode = "v" })
	end,
}
