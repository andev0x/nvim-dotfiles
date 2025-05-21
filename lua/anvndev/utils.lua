-- ~/.config/nvim/lua/anvndev/utils.lua
-- Helper functions

local M = {}

-- Keymap helper function
function M.keymap(mode, lhs, rhs, opts)
  local options = { noremap = true, silent = true }
  if opts then
    options = vim.tbl_extend("force", options, opts)
  end
  vim.keymap.set(mode, lhs, rhs, options)
end

-- Check if a plugin is available
function M.has_plugin(plugin)
  return require("lazy.core.config").spec.plugins[plugin] ~= nil
end

-- Check if running on macOS
function M.is_mac()
  return vim.loop.os_uname().sysname == "Darwin"
end

-- Check if running on Linux
function M.is_linux()
  return vim.loop.os_uname().sysname == "Linux"
end

-- Check if running on Windows
function M.is_win()
  return vim.loop.os_uname().sysname == "Windows_NT"
end

-- Get the root directory of the project
function M.get_root()
  local path = vim.loop.cwd()
  local root_patterns = { ".git", "Makefile", "go.mod", "Cargo.toml", "package.json", "mvnw", "gradlew", "pom.xml" }
  
  -- Check if any root pattern exists in the current directory
  for _, pattern in ipairs(root_patterns) do
    if vim.fn.filereadable(path .. "/" .. pattern) == 1 or vim.fn.isdirectory(path .. "/" .. pattern) == 1 then
      return path
    end
  end
  
  -- If no root pattern found, try to find it in parent directories
  local function find_root_in_parent(path)
    for _, pattern in ipairs(root_patterns) do
      local match = vim.fn.finddir(pattern, path .. ";")
      if match ~= "" then
        return vim.fn.fnamemodify(match, ":p:h:h")
      end
      
      match = vim.fn.findfile(pattern, path .. ";")
      if match ~= "" then
        return vim.fn.fnamemodify(match, ":p:h")
      end
    end
    return nil
  end
  
  local root = find_root_in_parent(path)
  return root or path
end

-- Merge tables
function M.merge(...)
  local result = {}
  for i = 1, select("#", ...) do
    local tbl = select(i, ...)
    if tbl then
      for k, v in pairs(tbl) do
        result[k] = v
      end
    end
  end
  return result
end

-- Toggle boolean option
function M.toggle_option(option)
  local value = not vim.api.nvim_get_option_value(option, {})
  vim.opt[option] = value
  vim.notify(option .. " " .. tostring(value))
end

-- Toggle diagnostics
function M.toggle_diagnostics()
  if vim.diagnostic.is_disabled() then
    vim.diagnostic.enable()
    vim.notify("Diagnostics enabled")
  else
    vim.diagnostic.disable()
    vim.notify("Diagnostics disabled")
  end
end

return M