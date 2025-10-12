-- ~/.config/nvim/lua/anvndev/plugins/lsp/servers.lua
-- LSP servers configuration using mason-lspconfig handlers

local lspconfig_ok, lspconfig = pcall(require, "lspconfig")
if not lspconfig_ok then
	vim.notify("Failed to load lspconfig", vim.log.levels.ERROR)
	return
end

local mason_lspconfig_ok, mason_lspconfig = pcall(require, "mason-lspconfig")
if not mason_lspconfig_ok then
	vim.notify("Failed to load mason-lspconfig", vim.log.levels.ERROR)
	return
end

-- LSP capabilities (for autocompletion)
local cmp_nvim_lsp_ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
local capabilities = cmp_nvim_lsp_ok and cmp_nvim_lsp.default_capabilities() or vim.empty_dict()

-- Function called when an LSP connects to a buffer
local on_attach = function(client, bufnr)
	-- Enable omnifunc completion
	vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

	-- Enable inlay hints if supported
	if client.server_capabilities.inlayHintProvider then
		vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
	end

	-- Enable breadcrumbs (nvim-navic) if supported
	if client.server_capabilities.documentSymbolProvider then
		local navic_ok, navic = pcall(require, "nvim-navic")
		if navic_ok then
			navic.attach(client, bufnr)
		end
	end
end

-- Define server-specific settings
local servers = {
	lua_ls = {
		settings = {
			Lua = {
				workspace = { checkThirdParty = false },
				telemetry = { enable = false },
				diagnostics = { globals = { "vim" } },
			},
		},
	},
	-- Add other server-specific settings here if needed
	-- e.g. gopls = { settings = { ... } }
}

-- Setup LSP servers with mason-lspconfig
mason_lspconfig.setup_handlers({
	-- Default handler for servers without custom settings
	function(server_name)
		lspconfig[server_name].setup({
			capabilities = capabilities,
			on_attach = on_attach,
		})
	end,

	-- Custom handler for lua_ls
	["lua_ls"] = function()
		lspconfig.lua_ls.setup({
			capabilities = capabilities,
			on_attach = on_attach,
			settings = servers.lua_ls.settings,
		})
	end,
})