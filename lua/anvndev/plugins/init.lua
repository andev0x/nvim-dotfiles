-- ~/.config/nvim/lua/anvndev/plugins/init.lua
-- Main plugin loader for lazy.nvim

return {
  -- Core plugins
  { "folke/lazy.nvim", version = "*" },
  { "nvim-lua/plenary.nvim", lazy = true },
  { "nvim-neotest/nvim-nio", lazy = true }, -- Required for neotest and nvim-dap-ui
  
  -- UI plugins (load these first for better visual experience)
  { import = "anvndev.plugins.ui.theme" },
  { import = "anvndev.plugins.ui.dashboard" },
  { import = "anvndev.plugins.ui.lualine" },
  { import = "anvndev.plugins.ui.filetree" },
  { import = "anvndev.plugins.ui.icons" },
  
  -- LSP, completion, and formatting (load on demand)
  { import = "anvndev.plugins.lsp.init" },
  
  -- Debugger (load only when needed)
  { import = "anvndev.plugins.debugger.init" },
  
  -- Language specific plugins (load on file type)
  { import = "anvndev.plugins.lang.go", ft = "go" },
  { import = "anvndev.plugins.lang.rust", ft = "rust" },
  { import = "anvndev.plugins.lang.cpp", ft = { "cpp", "c", "h", "hpp" } },
  { import = "anvndev.plugins.lang.python", ft = "python" },
  
  -- Miscellaneous plugins (load on demand)
  { import = "anvndev.plugins.misc.git" },
  { import = "anvndev.plugins.misc.comment" },
  { import = "anvndev.plugins.misc.telescope" },
  { import = "anvndev.plugins.misc.treesitter" },
  { import = "anvndev.plugins.misc.others" },
  {
    "tpope/vim-eunuch",
    event = "VeryLazy",
    cmd = {
      "Rename",
      "Move",
      "Delete",
      "Chmod",
      "Mkdir",
      "Cfind",
      "Clocate",
      "Lfind",
      "Llocate",
      "SudoWrite",
      "SudoEdit",
    },
  },
  {
    "folke/trouble.nvim",
    cmd = "TroubleToggle",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {},
  },
}