-- ~/.config/nvim/lua/anvndev/plugins/ui/lualine.lua
-- Statusline configuration

return {
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      local lualine = require("lualine")
      
      -- Custom component to show LSP status
      local function lsp_status()
        local clients = vim.lsp.get_clients()
        if next(clients) == nil then
          return "No LSP"
        end
        
        local client_names = {}
        for _, client in ipairs(clients) do
          table.insert(client_names, client.name)
        end
        return "LSP: " .. table.concat(client_names, ", ")
      end
      
      -- Custom component to show current function/method
      local function current_function()
        local has_navic, navic = pcall(require, "nvim-navic")
        if has_navic and navic.is_available() then
          return navic.get_location()
        end
        return ""
      end
      
      -- Custom component to show diagnostics
      local function diagnostics()
        local diagnostics_count = {
          error = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR }),
          warn = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN }),
          info = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.INFO }),
          hint = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.HINT }),
        }
        
        local result = {}
        if diagnostics_count.error > 0 then
          table.insert(result, " " .. diagnostics_count.error)
        end
        if diagnostics_count.warn > 0 then
          table.insert(result, " " .. diagnostics_count.warn)
        end
        if diagnostics_count.info > 0 then
          table.insert(result, " " .. diagnostics_count.info)
        end
        if diagnostics_count.hint > 0 then
          table.insert(result, " " .. diagnostics_count.hint)
        end
        
        return table.concat(result, " ")
      end
      
      -- Lualine configuration
      lualine.setup({
        options = {
          icons_enabled = true,
          theme = "tokyonight",
          component_separators = { left = "", right = "" },
          section_separators = { left = "", right = "" },
          disabled_filetypes = {
            statusline = { "dashboard", "alpha", "starter" },
            winbar = { "dashboard", "alpha", "starter" },
          },
          ignore_focus = {},
          always_divide_middle = true,
          globalstatus = true,
          refresh = {
            statusline = 100,
            tabline = 100,
            winbar = 100,
          },
        },
        sections = {
          lualine_a = { "mode" },
          lualine_b = {
            "branch",
            {
              "diff",
              symbols = {
                added = " ",
                modified = " ",
                removed = " ",
              },
            },
            diagnostics,
          },
          lualine_c = {
            {
              "filename",
              path = 1, -- Relative path
              symbols = {
                modified = "[+]",
                readonly = "[RO]",
                unnamed = "[No Name]",
                newfile = "[New]",
              },
            },
            current_function,
          },
          lualine_x = { lsp_status, "encoding", "fileformat", "filetype" },
          lualine_y = { "progress" },
          lualine_z = { "location" },
        },
        inactive_sections = {
          lualine_a = {},
          lualine_b = {},
          lualine_c = { "filename" },
          lualine_x = { "location" },
          lualine_y = {},
          lualine_z = {},
        },
        tabline = {},
        winbar = {},
        inactive_winbar = {},
        extensions = {
          "nvim-tree",
          "toggleterm",
          "quickfix",
          "fugitive",
          "man",
        },
      })
    end,
  },
  
  -- Breadcrumbs for code navigation
  {
    "SmiteshP/nvim-navic",
    lazy = true,
    dependencies = { "neovim/nvim-lspconfig" },
    config = function()
      require("nvim-navic").setup({
        icons = {
          File = " ",
          Module = " ",
          Namespace = " ",
          Package = " ",
          Class = " ",
          Method = " ",
          Property = " ",
          Field = " ",
          Constructor = " ",
          Enum = " ",
          Interface = " ",
          Function = " ",
          Variable = " ",
          Constant = " ",
          String = " ",
          Number = " ",
          Boolean = " ",
          Array = " ",
          Object = " ",
          Key = " ",
          Null = " ",
          EnumMember = " ",
          Struct = " ",
          Event = " ",
          Operator = " ",
          TypeParameter = " ",
        },
        highlight = true,
        separator = " > ",
        depth_limit = 0,
        depth_limit_indicator = "..",
      })
    end,
  },
}