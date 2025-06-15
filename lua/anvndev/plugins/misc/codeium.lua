return {
  {
    "Exafunction/codeium.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "hrsh7th/nvim-cmp",
    },
    config = function()
      require("codeium").setup({
        tools = {
          -- Codeium's tools configuration
        },
      })

      -- Set up keybindings
      vim.keymap.set('i', '<C-g>', function() return vim.fn['codeium#Accept']() end, { expr = true, silent = true })
      vim.keymap.set('i', '<C-;>', function() return vim.fn['codeium#CycleCompletions'](1) end, { expr = true, silent = true })
      vim.keymap.set('i', '<C-,>', function() return vim.fn['codeium#CycleCompletions'](-1) end, { expr = true, silent = true })
      vim.keymap.set('i', '<C-x>', function() return vim.fn['codeium#Clear']() end, { expr = true, silent = true })

      -- Add commands for easier management
      vim.api.nvim_create_user_command('CodeiumEnable', function()
        require("codeium").enable()
        print("Codeium enabled")
      end, {})

      vim.api.nvim_create_user_command('CodeiumDisable', function()
        require("codeium").disable()
        print("Codeium disabled")
      end, {})

      vim.api.nvim_create_user_command('CodeiumStatus', function()
        local status = require("codeium").is_enabled()
        print("Codeium status:", status and "enabled" or "disabled")
      end, {})

      -- Add authentication command
      vim.api.nvim_create_user_command('CodeiumAuth', function()
        local api_key = vim.fn.input("Enter your Codeium API key: ")
        if api_key and api_key ~= "" then
          require("codeium").authenticate(api_key)
          print("Codeium authentication successful!")
        else
          print("No API key provided. Authentication cancelled.")
        end
      end, {})

      -- Add setup command
      vim.api.nvim_create_user_command('CodeiumSetup', function()
        print("Setting up Codeium...")
        print("1. Visit https://codeium.com and sign up/login")
        print("2. Go to your dashboard and get your API key")
        print("3. Run :CodeiumAuth and paste your API key")
        print("4. Run :CodeiumEnable to enable Codeium")
        print("5. Start coding! Use <C-g> to accept suggestions")
      end, {})
    end,
  }
} 