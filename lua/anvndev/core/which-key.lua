local status_ok, wk = pcall(require, "which-key")
if not status_ok then
	return
end

wk.setup({
	plugins = {
		marks = true,
		registers = true,
		spelling = {
			enabled = true,
			suggestions = 20,
		},
		presets = {
			operators = true,
			motions = true,
			text_objects = true,
			windows = true,
			nav = true,
			z = true,
			g = true,
		},
	},
	operators = { gc = "Comments" },
	key_labels = {
		["<space>"] = "SPC",
		["<cr>"] = "RET",
		["<tab>"] = "TAB",
	},
	icons = {
		breadcrumb = "»",
		separator = "➜",
		group = "+",
	},
	window = {
		border = "rounded",
		position = "bottom",
		margin = { 1, 0, 1, 0 },
		padding = { 2, 2, 2, 2 },
		winblend = 0,
	},
	layout = {
		height = { min = 4, max = 25 },
		width = { min = 20, max = 50 },
		spacing = 3,
		align = "left",
	},
	ignore_missing = true,
	hidden = { "<silent>", "<cmd>", "<Cmd>", "<CR>", "call", "lua", "^:", "^ " },
	show_help = true,
	show_keys = true,
	triggers = "auto",
	triggers_blacklist = {
		i = { "j", "k" },
		v = { "j", "k" },
	},
})

-- 🔹 Modern which-key v3 spec (flat list)
wk.add({
	{ "<leader>l", group = "LSP" },
	{ "<leader>g", group = "Git" },
	{ "<leader>c", group = "Code" },
	{ "<leader>t", group = "Terminal" },
	{ "<leader>b", group = "Buffers" },
	{ "<leader>d", group = "Debug" },
	{ "<leader>r", group = "Refactor" },
	{ "<leader>w", group = "Workspace" },
	{ "<leader>f", group = "Find/Files" },
	{ "<leader>x", group = "Text" },

	-- 🔹 Optional: group toggle
	{ "<leader>to", group = "Toggle" },
	{ "<leader>tl", desc = "Toggle invisible characters" },
	{ "<leader>th", desc = "Horizontal terminal" },
	{ "<leader>ts", desc = "Toggle spell check" },
	{ "<leader>tt", desc = "Toggle terminal" },
	{ "<leader>tr", desc = "Toggle relative line numbers" },
	{ "<leader>tw", desc = "Toggle word wrap" },
	{ "<leader>tv", desc = "Vertical terminal" },
	{ "<leader>tf", desc = "Float terminal" },
})
