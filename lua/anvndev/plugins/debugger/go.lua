-- ~/.config/nvim/lua/anvndev/plugins/debugger/go.lua
-- Go debugger configuration
-- Author: anvndev

local ok, dap = pcall(require, "dap")
if not ok then
	return
end

-- Configure Go debugging
dap.adapters.delve = {
	type = "server",
	port = "${port}",
	executable = {
		command = "dlv",
		args = { "dap", "-l", "127.0.0.1:${port}" },
	},
}

dap.configurations.go = {
	{
		type = "delve",
		name = "Debug File",
		request = "launch",
		program = "${file}",
	},
	{
		type = "delve",
		name = "Debug Package",
		request = "launch",
		program = "${fileDirname}",
	},
	{
		type = "delve",
		name = "Debug Test",
		request = "launch",
		mode = "test",
		program = "${file}",
	},
	{
		type = "delve",
		name = "Debug Test Package",
		request = "launch",
		mode = "test",
		program = "${fileDirname}",
	},
	{
		type = "delve",
		name = "Attach Process",
		mode = "local",
		request = "attach",
		processId = require("dap.utils").pick_process,
	},
	{
		type = "delve",
		name = "Debug Remote",
		request = "attach",
		mode = "remote",
		port = 38697,
		host = "127.0.0.1",
	},
}
