return {
	{
		"nanotee/sqls.nvim",
		ft = "sql",
		dependencies = {},
		config = function()
			local ok, lspconfig = pcall(require, "lspconfig")
			if not ok then
				return
			end

			-- SQL language server configuration
			lspconfig.sqls.setup({
				on_attach = function(client, bufnr)
					-- Enable completion triggered by <c-x><c-o>
					vim.bo[bufnr].omnifunc = "v:lua.vim.lsp.omnifunc"

					-- Mappings
					local opts = { noremap = true, silent = true, buffer = bufnr }
					vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
					vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
					vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
					vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
					vim.keymap.set("n", "<leader>lf", function()
						vim.lsp.buf.format({ async = true })
					end, opts)
				end,
				settings = {
					sqls = {
						connections = {},
					},
				},
			})
		end,
	},
	{
		"andev0x/sql-formatter.nvim",
		ft = { "sql", "mysql", "plsql", "pgsql" },
		config = function()
			vim.g.sqlformat_command = "sqlformat"
			vim.g.sqlformat_options = "-r -k upper"
			vim.g.sqlformat_prog = "sqlformat"
		end,
	},
}
