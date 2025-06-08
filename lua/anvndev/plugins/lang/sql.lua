return {
	{
		"nanotee/sqls.nvim",
		ft = "sql",
		dependencies = {
			"neovim/nvim-lspconfig",
		},
		config = function()
			local lspconfig = require("lspconfig")
			local configs = require("lspconfig.configs")

			-- SQL language server configuration
			lspconfig.sqls.setup({
				on_attach = function(client, bufnr)
					-- Enable completion triggered by <c-x><c-o>
					vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

					-- Mappings
					local opts = { noremap = true, silent = true, buffer = bufnr }
					vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
					vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
					vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
					vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
					vim.keymap.set("n", "<leader>f", vim.lsp.buf.formatting, opts)
				end,
				settings = {
					sqls = {
						connections = {
							{
								driver = "postgres", -- or "mysql", "sqlite3", etc.
								dataSourceName = "host=127.0.0.1 port=5432 user=postgres password=postgres dbname=postgres sslmode=disable",
							},
						},
					},
				},
			})
		end,
	},
	{
		"andev0x/nvim-sqlformat",
		ft = "sql",
		config = function()
			vim.g.sqlformat_command = "sqlformat"
			vim.g.sqlformat_options = "-r -k upper"
		end,
	},
}
