-- ~/.config/nvim/lua/anvndev/plugins/ui/theme.lua
-- Theme configuration

return {
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      require("tokyonight").setup({
        style = "night",
        transparent = false,
        terminal_colors = true,
        styles = {
          comments = { italic = true },
          keywords = { italic = true },
          functions = {},
          variables = {},
          sidebars = "dark",
          floats = "dark",
        },
        sidebars = { "qf", "help", "terminal", "packer", "nvim-tree" },
        day_brightness = 0.3,
        hide_inactive_statusline = false,
        dim_inactive = false,
        lualine_bold = false,
        on_colors = function(colors)
          colors.bg = "#0a0f0a"
          colors.bg_dark = "#050805"
          colors.bg_float = "#0a0f0a"
          colors.bg_highlight = "#0f1a0f"
          colors.bg_popup = "#0a0f0a"
          colors.bg_search = "#0f1a0f"
          colors.bg_sidebar = "#0a0f0a"
          colors.bg_statusline = "#0a0f0a"
          colors.bg_visual = "#0f1a0f"
          colors.fg = "#a0c0a0"
          colors.fg_dark = "#80a080"
          colors.fg_float = "#a0c0a0"
          colors.fg_gutter = "#608060"
          colors.fg_sidebar = "#a0c0a0"
        end,
      })
      
      -- Set colorscheme
      vim.cmd([[colorscheme tokyonight]])
    end,
  },
  
  -- Other themes (commented out but available if needed)
  -- {
  --   "catppuccin/nvim",
  --   name = "catppuccin",
  --   lazy = true,
  -- },
  -- {
  --   "ellisonleao/gruvbox.nvim",
  --   lazy = true,
  -- },
}