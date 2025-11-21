-- ~/.config/nvim/lua/anvndev/utils.lua
-- Helper functions
-- Author: anvndev

local M = {}

-- Keymap helper: small wrapper around vim.keymap.set with sane defaults
function M.keymap(mode, lhs, rhs, opts)
	local defaults = { noremap = true, silent = true }
	opts = opts and vim.tbl_extend("force", defaults, opts) or defaults
	vim.keymap.set(mode, lhs, rhs, opts)
end

-- Safe plugin presence check (works even if lazy isn't loaded yet)
function M.has_plugin(name)
	local ok, lazy = pcall(require, "lazy.core.config")
	if not ok or not lazy or not lazy.spec then
		return false
	end
	return lazy.spec.plugins and lazy.spec.plugins[name] ~= nil
end

-- OS helpers (cached)
local _os
function M.is_mac()
	_os = _os or vim.loop.os_uname().sysname
	return _os == "Darwin"
end
function M.is_linux()
	_os = _os or vim.loop.os_uname().sysname
	return _os == "Linux"
end
function M.is_win()
	_os = _os or vim.loop.os_uname().sysname
	return _os == "Windows_NT"
end

-- Project root discovery using vim.fs (clean and fast)
function M.get_root()
	local cwd = vim.loop.cwd()
	local root_patterns = { ".git", "Makefile", "go.mod", "Cargo.toml", "package.json", "mvnw", "gradlew", "pom.xml" }
	local match = vim.fs.find(root_patterns, { upward = true, path = cwd })
	if match and #match > 0 then
		return vim.fs.abspath(vim.fn.fnamemodify(match[1], ":p:h"))
	end
	return cwd
end

-- Merge tables (shallow) using built-in helper
function M.merge(...)
	local args = { ... }
	if #args == 0 then
		return {}
	end
	return vim.tbl_extend("force", unpack(args))
end

-- Toggle an option and notify user (safe getter/setter)
function M.toggle_option(option)
	local ok, cur = pcall(vim.api.nvim_get_option_value, option, {})
	if not ok then
		vim.notify("Unknown option: " .. tostring(option), vim.log.levels.WARN)
		return
	end
	pcall(vim.api.nvim_set_option_value, option, not cur, {})
	vim.notify(option .. " " .. tostring(not cur))
end

-- Toggle diagnostics globally
function M.toggle_diagnostics()
	if not vim.diagnostic then
		return vim.notify("vim.diagnostic not available", vim.log.levels.WARN)
	end
	-- Use buffer-level enable/disable to affect all buffers
	local buf = 0
	local disabled = false
	-- we check first buffer to infer state
	if pcall(vim.diagnostic.is_disabled, buf) then
		disabled = vim.diagnostic.is_disabled(buf)
	end
	if disabled then
		vim.diagnostic.enable()
		vim.notify("Diagnostics enabled")
	else
		vim.diagnostic.disable()
		vim.notify("Diagnostics disabled")
	end
end

return M

