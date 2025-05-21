-- ~/.config/nvim/lua/anvndev/plugins/misc/comment.lua
-- Comment plugin configuration

return {
  {
    "numToStr/Comment.nvim",
    event = { "BufReadPost", "BufNewFile" },
    dependencies = {
      "JoosepAlviste/nvim-ts-context-commentstring",
    },
    config = function()
      require("Comment").setup({
        padding = true,
        sticky = true,
        ignore = nil,
        toggler = {
          line = "gcc",
          block = "gbc",
        },
        opleader = {
          line = "gc",
          block = "gb",
        },
        extra = {
          above = "gcO",
          below = "gco",
          eol = "gcA",
        },
        mappings = {
          basic = true,
          extra = true,
        },
        pre_hook = function(ctx)
          -- Only calculate commentstring for tsx/jsx files
          if vim.bo.filetype == "typescriptreact" or vim.bo.filetype == "javascriptreact" or vim.bo.filetype == "vue" then
            local U = require("Comment.utils")
            
            -- Determine whether to use linewise or blockwise commentstring
            local type = ctx.ctype == U.ctype.linewise and "__default" or "__multiline"
            
            -- Determine the location where to calculate commentstring from
            local location = nil
            if ctx.ctype == U.ctype.blockwise then
              location = require("ts_context_commentstring.utils").get_cursor_location()
            elseif ctx.cmotion == U.cmotion.v or ctx.cmotion == U.cmotion.V then
              location = require("ts_context_commentstring.utils").get_visual_start_location()
            end
            
            return require("ts_context_commentstring.internal").calculate_commentstring({
              key = type,
              location = location,
            })
          end
        end,
        post_hook = nil,
      })
    end,
  },
  
  -- Context-aware commentstring
  {
    "JoosepAlviste/nvim-ts-context-commentstring",
    lazy = true,
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    config = function()
      require("ts_context_commentstring").setup({
        enable_autocmd = false,
        languages = {
          typescript = "// %s",
          css = "/* %s */",
          scss = "/* %s */",
          html = "<!-- %s -->",
          svelte = "<!-- %s -->",
          vue = "<!-- %s -->",
          json = "",
        },
      })
    end,
  },
}