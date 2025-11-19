-- ~/.config/nvim/lua/anvndev/plugins/misc/telescope.lua
-- Telescope configuration

return {
  {
    "nvim-telescope/telescope.nvim",
    cmd = "Telescope",
    version = false,
    dependencies = {
      "nvim-lua/plenary.nvim",
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make",
        enabled = vim.fn.executable("make") == 1,
      },
      "nvim-telescope/telescope-ui-select.nvim",
      "nvim-telescope/telescope-file-browser.nvim",
      "nvim-telescope/telescope-project.nvim",
      "nvim-telescope/telescope-dap.nvim",
    },
    keys = {
      { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find files" },
      { "<leader>fg", "<cmd>Telescope live_grep<cr>", desc = "Live grep" },
      { "<leader>fb", "<cmd>Telescope buffers<cr>", desc = "Find buffers" },
      { "<leader>fh", "<cmd>Telescope help_tags<cr>", desc = "Help tags" },
      { "<leader>fc", "<cmd>Telescope commands<cr>", desc = "Commands" },
      { "<leader>fr", "<cmd>Telescope oldfiles<cr>", desc = "Recent files" },
      { "<leader>fk", "<cmd>Telescope keymaps<cr>", desc = "Keymaps" },
      { "<leader>fs", "<cmd>Telescope lsp_document_symbols<cr>", desc = "Document symbols" },
      { "<leader>fS", "<cmd>Telescope lsp_workspace_symbols<cr>", desc = "Workspace symbols" },
      { "<leader>fd", "<cmd>Telescope diagnostics<cr>", desc = "Diagnostics" },
      { "<leader>fp", "<cmd>Telescope projects<cr>", desc = "Projects" },
      { "<leader>fe", "<cmd>Telescope file_browser<cr>", desc = "File browser" },
      { "<leader>gc", "<cmd>Telescope git_commits<cr>", desc = "Git commits" },
      { "<leader>gs", "<cmd>Telescope git_status<cr>", desc = "Git status" },
      { "<leader>gb", "<cmd>Telescope git_branches<cr>", desc = "Git branches" },
    },
    config = function()
      local telescope = require("telescope")
      local actions = require("telescope.actions")
      local fb_actions = require("telescope").extensions.file_browser.actions

      local previewers = require("telescope.previewers")
      local custom_previewer = previewers.new_buffer_previewer {
        define_preview = function(self, entry)
          local filepath = entry.value
          if not filepath or vim.fn.isdirectory(filepath) == 1 then
            return
          end

          if vim.fn.executable("bat") == 1 then
            local cmd = { "bat", "--style=numbers,changes", "--color=always", filepath }
            vim.api.nvim_buf_set_lines(self.state.bufnr, 0, -1, false, {})
            vim.fn.jobstart(cmd, {
              stdout_buffered = true,
              on_stdout = function(_, data)
                if data then
                  vim.api.nvim_buf_set_lines(self.state.bufnr, -1, -1, false, data)
                end
              end,
            })
          else
            -- Fallback to simple file read
            vim.api.nvim_buf_set_lines(self.state.bufnr, 0, -1, false, vim.fn.readfile(filepath))
          end
        end,
      }
      
      telescope.setup({
        defaults = {
          prompt_prefix = " ",
          selection_caret = " ",
          path_display = { "truncate" },
          selection_strategy = "reset",
          sorting_strategy = "ascending",
          layout_strategy = "horizontal",
          layout_config = {
            horizontal = {
              prompt_position = "top",
              preview_width = 0.55,
              results_width = 0.8,
            },
            vertical = {
              mirror = false,
            },
            width = 0.87,
            height = 0.80,
            preview_cutoff = 120,
          },
          file_sorter = require("telescope.sorters").get_fuzzy_file,
          file_ignore_patterns = { "node_modules", ".git/", "dist/", "build/", "target/" },
          generic_sorter = require("telescope.sorters").get_generic_fuzzy_sorter,
          winblend = 0,
          border = {},
          borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
          color_devicons = true,
          set_env = { ["COLORTERM"] = "truecolor" },
          mappings = {
            i = {
              ["<C-n>"] = actions.cycle_history_next,
              ["<C-p>"] = actions.cycle_history_prev,
              ["<C-j>"] = actions.move_selection_next,
              ["<C-k>"] = actions.move_selection_previous,
              ["<C-c>"] = actions.close,
              ["<Down>"] = actions.move_selection_next,
              ["<Up>"] = actions.move_selection_previous,
              ["<CR>"] = actions.select_default,
              ["<C-x>"] = actions.select_horizontal,
              ["<C-v>"] = actions.select_vertical,
              ["<C-t>"] = actions.select_tab,
              ["<C-u>"] = actions.preview_scrolling_up,
              ["<C-d>"] = actions.preview_scrolling_down,
              ["<PageUp>"] = actions.results_scrolling_up,
              ["<PageDown>"] = actions.results_scrolling_down,
              ["<Tab>"] = actions.toggle_selection + actions.move_selection_worse,
              ["<S-Tab>"] = actions.toggle_selection + actions.move_selection_better,
              ["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
              ["<M-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
              ["<C-l>"] = actions.complete_tag,
              ["<C-_>"] = actions.which_key, -- keys from pressing <C-/>
            },
            n = {
              ["<esc>"] = actions.close,
              ["<CR>"] = actions.select_default,
              ["<C-x>"] = actions.select_horizontal,
              ["<C-v>"] = actions.select_vertical,
              ["<C-t>"] = actions.select_tab,
              ["<Tab>"] = actions.toggle_selection + actions.move_selection_worse,
              ["<S-Tab>"] = actions.toggle_selection + actions.move_selection_better,
              ["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
              ["<M-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
              ["j"] = actions.move_selection_next,
              ["k"] = actions.move_selection_previous,
              ["H"] = actions.move_to_top,
              ["M"] = actions.move_to_middle,
              ["L"] = actions.move_to_bottom,
              ["<Down>"] = actions.move_selection_next,
              ["<Up>"] = actions.move_selection_previous,
              ["gg"] = actions.move_to_top,
              ["G"] = actions.move_to_bottom,
              ["<C-u>"] = actions.preview_scrolling_up,
              ["<C-d>"] = actions.preview_scrolling_down,
              ["<PageUp>"] = actions.results_scrolling_up,
              ["<PageDown>"] = actions.results_scrolling_down,
              ["?"] = actions.which_key,
            },
          },
        },
        pickers = {
          find_files = {
            hidden = true,
            find_command = { "fd", "--type", "f", "--strip-cwd-prefix" },
            previewer = custom_previewer,
          },
          live_grep = {
            vimgrep_arguments = {
              "rg",
              "--color=never",
              "--no-heading",
              "--with-filename",
              "--line-number",
              "--column",
              "--smart-case",
              "--hidden",
              "-g",
              "!.git/",
            },
            additional_args = function(opts)
              return { "--hidden" }
            end,
          },
          buffers = {
            show_all_buffers = true,
            sort_lastused = true,
            mappings = {
              i = {
                ["<c-d>"] = actions.delete_buffer,
              },
              n = {
                ["dd"] = actions.delete_buffer,
              },
            },
          },
        },
        extensions = {
          fzf = {
            fuzzy = true,
            override_generic_sorter = true,
            override_file_sorter = true,
            case_mode = "smart_case",
          },
          file_browser = {
            theme = "dropdown",
            hijack_netrw = true,
            mappings = {
              ["i"] = {
                ["<C-w>"] = function()
                  vim.cmd("normal vbd")
                end,
                ["<C-h>"] = fb_actions.goto_parent_dir,
                ["<C-e>"] = fb_actions.create,
                ["<C-y>"] = fb_actions.copy,
                ["<C-m>"] = fb_actions.move,
                ["<C-d>"] = fb_actions.remove,
                ["<C-r>"] = fb_actions.rename,
                ["<C-o>"] = fb_actions.open,
                ["<C-g>"] = fb_actions.goto_cwd,
                ["<C-f>"] = fb_actions.toggle_browser,
                ["<C-s>"] = fb_actions.toggle_hidden,
                ["<C-a>"] = fb_actions.toggle_all,
              },
              ["n"] = {
                ["h"] = fb_actions.goto_parent_dir,
                ["e"] = fb_actions.create,
                ["y"] = fb_actions.copy,
                ["m"] = fb_actions.move,
                ["d"] = fb_actions.remove,
                ["r"] = fb_actions.rename,
                ["o"] = fb_actions.open,
                ["g"] = fb_actions.goto_cwd,
                ["f"] = fb_actions.toggle_browser,
                ["s"] = fb_actions.toggle_hidden,
                ["a"] = fb_actions.toggle_all,
              },
            },
          },
          ["ui-select"] = {
            require("telescope.themes").get_dropdown({
              -- even more opts
            }),
          },
        },
      })
      
      -- Ensure common Telescope highlight groups exist to avoid runtime errors
      -- (some themes or load-order issues may not define them). Link missing
      -- groups to sensible defaults.
      do
        local safe_links = {
          TelescopeBorder = "Normal",
          TelescopeNormal = "Normal",
          TelescopePromptNormal = "Normal",
          TelescopePromptBorder = "Normal",
          TelescopePreviewBorder = "Normal",
          TelescopeResultsBorder = "Normal",
          TelescopePromptPrefix = "Question",
          TelescopeSelection = "PmenuSel",
          TelescopeSelectionCaret = "PmenuSel",
          TelescopeMatching = "Search",
          TelescopeMultiSelection = "PmenuSel",
        }

        for group, link in pairs(safe_links) do
          -- Use hlexists() which is robust across Neovim versions to check for
          -- highlight group existence. If missing, create a link to a sensible
          -- default group.
          local exists = vim.fn.hlexists(group)
          if exists == 0 then
            pcall(vim.cmd, string.format("highlight link %s %s", group, link))
          end
        end
      end

      -- Load extensions
      telescope.load_extension("fzf")
      telescope.load_extension("file_browser")
      telescope.load_extension("ui-select")
      telescope.load_extension("project")
      telescope.load_extension("dap")
    end,
  },
}
