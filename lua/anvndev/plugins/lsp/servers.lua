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

-- Setup mason-lspconfig first
mason_lspconfig.setup({
	ensure_installed = {
		"lua_ls", -- Lua
	},
	automatic_installation = true,
})

-- Setup LSP servers with mason-lspconfig if handlers API is available
if type(mason_lspconfig.setup_handlers) == "function" then
	mason_lspconfig.setup_handlers({
		-- Default handler for servers without custom settings
		function(server_name)
			local opts = {
				capabilities = capabilities,
				on_attach = on_attach,
			}
			-- Merge any server-specific settings from `servers` table
			if servers[server_name] then
				for k, v in pairs(servers[server_name]) do
					opts[k] = v
				end
			end

			-- First try to use the explicit server registry if available.
			local ok_sc, server_configs = pcall(require, "lspconfig.server_configurations")
			local server_mod
			if ok_sc and type(server_configs) == "table" then
				server_mod = server_configs[server_name]
			else
				-- Fall back to rawget on the lspconfig table to avoid invoking
				-- its __index metamethod which can error for unknown servers.
				server_mod = rawget(lspconfig, server_name)
			end

			if type(server_mod) ~= "table" or type(server_mod.setup) ~= "function" then
				vim.notify("lspconfig server '" .. tostring(server_name) .. "' not available or cannot be configured", vim.log.levels.WARN)
			else
				local setup_ok, setup_err = pcall(function()
					server_mod.setup(opts)
				end)
				if not setup_ok then
					vim.notify("Failed to setup LSP server '" .. tostring(server_name) .. "': " .. tostring(setup_err), vim.log.levels.ERROR)
				end
			end
		end,

		-- Custom handler for lua_ls
		["lua_ls"] = function()
			-- Protect lua_ls setup as well; prefer server_configurations when
			-- available, otherwise fallback to rawget on the main lspconfig table.
			pcall(function()
				local ok_sc, server_configs = pcall(require, "lspconfig.server_configurations")
				local lua_mod
				if ok_sc and type(server_configs) == "table" then
					lua_mod = server_configs.lua_ls
				else
					lua_mod = rawget(lspconfig, "lua_ls")
				end

				if lua_mod and type(lua_mod.setup) == "function" then
					lua_mod.setup({
						capabilities = capabilities,
						on_attach = on_attach,
						settings = servers.lua_ls.settings,
					})
				else
					vim.notify("lua_ls not available in lspconfig", vim.log.levels.WARN)
				end
			end)
		end,
	})
else
	-- Fallback: some versions/installations of mason-lspconfig may not expose
	-- `setup_handlers`. In that case, register a reasonable default set of
	-- servers manually so the config doesn't error out.
	vim.notify("mason-lspconfig.setup_handlers not available; falling back to manual lspconfig setup", vim.log.levels.WARN)

	local fallback_servers = { "lua_ls", "gopls", "pyright", "rust_analyzer", "clangd", "tsserver", "bashls" }
	for _, server_name in ipairs(fallback_servers) do
		-- Use server_configurations when available; otherwise fall back to rawget
		local ok_sc, server_configs = pcall(require, "lspconfig.server_configurations")
		local server_mod
		if ok_sc and type(server_configs) == "table" then
			server_mod = server_configs[server_name]
		else
			server_mod = rawget(lspconfig, server_name)
		end
		if type(server_mod) == "table" and type(server_mod.setup) == "function" then
			local opts = { capabilities = capabilities, on_attach = on_attach }
			if servers[server_name] then
				for k, v in pairs(servers[server_name]) do
					opts[k] = v
				end
			end
			local setup_ok, setup_err = pcall(function()
				server_mod.setup(opts)
			end)
			if not setup_ok then
				vim.notify("Failed to setup LSP server '" .. tostring(server_name) .. "' (fallback): " .. tostring(setup_err), vim.log.levels.ERROR)
			end
		else
			-- Either not present or access triggered an error; warn and continue
			-- skip silently at DEBUG level because many servers in the fallback
			-- list may not be installed on the user's system.
			vim.notify("Skipping LSP server '" .. tostring(server_name) .. "' (not available)", vim.log.levels.DEBUG)
		end
	end
end