return {
	"CopilotC-Nvim/CopilotChat.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"zbirenbaum/copilot.lua", -- or zbirenbaum/copilot.lua
		"nvim-telescope/telescope.nvim", -- Recommended by CopilotChat.nvim
		"folke/which-key.nvim", -- For keymaps (assuming it's already installed)
	},
	opts = {
		-- You can add any specific configuration here.
		-- For a Cursor-like experience, we mostly rely on the default commands
		-- like :CopilotChat and :CopilotChatDiff.
		-- Ensure your 'which-key' setup registers these commands for easy access.
		question_popup_border = {
			{ "╭", "CopilotChatBorder" },
			{ "─", "CopilotChatBorder" },
			{ "╮", "CopilotChatBorder" },
			{ "│", "CopilotChatBorder" },
			{ "╯", "CopilotChatBorder" },
			{ "─", "CopilotChatBorder" },
			{ "╰", "CopilotChatBorder" },
			{ "│", "CopilotChatBorder" },
		},
		response_popup_border = {
			{ "╭", "CopilotChatBorder" },
			{ "─", "CopilotChatBorder" },
			{ "╮", "CopilotChatBorder" },
			{ "│", "CopilotChatBorder" },
			{ "╯", "CopilotChatBorder" },
			{ "─", "CopilotChatBorder" },
			{ "╰", "CopilotChatBorder" },			{ "│", "CopilotChatBorder" },
		},
	},
	config = function(_, opts)
		require("CopilotChat").setup(opts)

		-- Set up keymaps for CopilotChat
		local wk = require("which-key")
		wk.add({
			mode = "n", -- Normal mode
			{ "<leader>cc", group = "CopilotChat" },
			{ "<leader>ccq", ":CopilotChatToggle<CR>", desc = "Toggle CopilotChat" },
			{ "<leader>cce", ":CopilotChatExplain<CR>", desc = "Explain code" },
			{ "<leader>ccd", ":CopilotChatFixDiagnostic<CR>", desc = "Fix diagnostic" },
			{ "<leader>cct", ":CopilotChatTests<CR>", desc = "Generate tests" },
			{ "<leader>ccn", ":CopilotChatNewSheet<CR>", desc = "New Chat Sheet" },
			{ "<leader>ccr", ":CopilotChatReset<CR>", desc = "Reset Chat" },
		})
		wk.add({
			mode = "v", -- Visual mode
			{ "<leader>cc", group = "CopilotChat" },
			{ "<leader>cce", ":CopilotChatExplain<CR>", desc = "Explain selection" },
			{ "<leader>ccr", ":CopilotChatRefactor<CR>", desc = "Refactor selection" },
			{ "<leader>ccd", ":CopilotChatDiff<CR>", desc = "Diff selection" },
			{ "<leader>ccf", ":CopilotChatFix<CR>", desc = "Fix selection" },
			{ "<leader>cct", ":CopilotChatTests<CR>", desc = "Generate tests for selection" },
		})

	end,
}