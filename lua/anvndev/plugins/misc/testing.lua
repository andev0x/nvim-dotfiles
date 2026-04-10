return {
	{
		"nvim-neotest/neotest",
		event = "VeryLazy",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-treesitter/nvim-treesitter",
			"antoinemadec/FixCursorHold.nvim",
			"nvim-neotest/neotest-go",
			"nvim-neotest/neotest-python",
			"alfaix/neotest-gtest",
		},
		opts = function()
			local adapters = {}

			local ok_go, neotest_go = pcall(require, "neotest-go")
			if ok_go then
				table.insert(adapters, neotest_go({
					experimental = { test_table = true },
					args = { "-count=1", "-timeout=60s" },
				}))
			end

			local ok_py, neotest_python = pcall(require, "neotest-python")
			if ok_py then
				table.insert(adapters, neotest_python({
					dap = { justMyCode = false },
					runner = "pytest",
				}))
			end

			local ok_cpp, neotest_gtest = pcall(require, "neotest-gtest")
			if ok_cpp then
				table.insert(adapters, neotest_gtest({
					gtest_command = "gtest",
					gtest_args = { "--gtest_color=yes" },
				}))
			end

			return { adapters = adapters }
		end,
		config = function(_, opts)
			require("neotest").setup(opts)
		end,
		keys = {
			{ "<leader>kn", function() require("neotest").run.run() end, desc = "Nearest test" },
			{ "<leader>kf", function() require("neotest").run.run(vim.fn.expand("%")) end, desc = "File tests" },
			{ "<leader>ko", function() require("neotest").output.open({ enter = true }) end, desc = "Test output" },
			{ "<leader>ks", function() require("neotest").summary.toggle() end, desc = "Test summary" },
		},
	},
}
