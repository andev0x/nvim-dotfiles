-- ~/.config/nvim/lua/anvndev/plugins/debugger/rust.lua
-- Rust debugger configuration
-- Author: anvndev

local dap = require("dap")

-- Find the path to codelldb
local extension_path = vim.fn.stdpath("data") .. "/mason/packages/codelldb/extension/"
local codelldb_path = extension_path .. "adapter/codelldb"
local liblldb_path = extension_path .. "lldb/lib/liblldb.dylib" -- macOS specific

-- Configure Rust debugging with codelldb
dap.adapters.codelldb = {
	type = "server",
	port = "${port}",
	executable = {
		command = codelldb_path,
		args = { "--port", "${port}" },
	},
}

dap.configurations.rust = {
	{
		name = "Launch file",
		type = "codelldb",
		request = "launch",
		program = function()
			return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/target/debug/", "file")
		end,
		cwd = "${workspaceFolder}",
		stopOnEntry = false,
		args = {},
		runInTerminal = false,
	},
	{
		name = "Attach to process",
		type = "codelldb",
		request = "attach",
		pid = require("dap.utils").pick_process,
		args = {},
	},
}

