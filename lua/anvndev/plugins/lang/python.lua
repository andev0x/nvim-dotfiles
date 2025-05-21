-- ~/.config/nvim/lua/anvndev/plugins/lang/python.lua
-- Python language configuration

return {
  {
    "mfussenegger/nvim-dap-python",
    ft = "python",
    dependencies = {
      "mfussenegger/nvim-dap",
      "rcarriga/nvim-dap-ui",
    },
    config = function()
      local path = vim.fn.stdpath("data") .. "/mason/packages/debugpy/venv/bin/python"
      require("dap-python").setup(path)
      
      -- Add configurations
      local dap = require("dap")
      table.insert(dap.configurations.python, {
        type = "python",
        request = "launch",
        name = "Django",
        program = "${workspaceFolder}/manage.py",
        args = { "runserver", "--noreload" },
        django = true,
        console = "integratedTerminal",
      })
      
      table.insert(dap.configurations.python, {
        type = "python",
        request = "launch",
        name = "Flask",
        module = "flask",
        args = { "run", "--no-debugger", "--no-reload" },
        env = {
          FLASK_APP = "${workspaceFolder}/app.py",
          FLASK_ENV = "development",
        },
        jinja = true,
        console = "integratedTerminal",
      })
      
      -- Key mappings
      vim.keymap.set("n", "<leader>dpm", require("dap-python").test_method, { desc = "Debug Python Method" })
      vim.keymap.set("n", "<leader>dpc", require("dap-python").test_class, { desc = "Debug Python Class" })
      vim.keymap.set("n", "<leader>dps", require("dap-python").debug_selection, { desc = "Debug Python Selection" })
    end,
  },
  
  -- Python test integration
  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "antoinemadec/FixCursorHold.nvim",
      "nvim-neotest/neotest-python",
    },
    config = function()
      require("neotest").setup({
        adapters = {
        require("neotest-python")({
          dap = { justMyCode = false },
          runner = "pytest",
          python = vim.fn.stdpath("data") .. "/mason/packages/debugpy/venv/bin/python",
        }),
        },
      })
    end,
  },
  
  -- Python REPL
  {
    "michaelb/sniprun",
    build = "bash ./install.sh",
    config = function()
      require("sniprun").setup({
        display = { "Terminal" },
        display_options = {
          terminal_width = 45,
          terminal_position = "vertical",
        },
        interpreter_options = {
          Python3_original = {
            interpreter = vim.fn.stdpath("data") .. "/mason/packages/debugpy/venv/bin/python",
          },
        },
      })
      
      -- Key mappings
      vim.keymap.set("n", "<leader>sr", "<Plug>SnipRun", { desc = "Run code snippet" })
      vim.keymap.set("v", "<leader>sr", "<Plug>SnipRun", { desc = "Run selected code" })
    end,
  },
}