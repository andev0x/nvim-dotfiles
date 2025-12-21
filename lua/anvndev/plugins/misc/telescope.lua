-- ~/.config/nvim/lua/anvndev/plugins/misc/telescope.lua
-- Telescope configuration
-- Author: anvndev

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
		-- Note: Keybindings are defined in lua/anvndev/core/keymaps.lua
		-- Custom keybindings with advanced logic are set in config() below
		config = function()
			local telescope = require("telescope")
			local actions = require("telescope.actions")
			local fb_actions = require("telescope").extensions.file_browser.actions
			local builtin = require("telescope.builtin")

			---------------------------------------------------------------------
			-- Custom source finders (advanced file filtering)
			---------------------------------------------------------------------
			-- Note: These keybindings use vim.keymap.set for custom function logic.
			-- Basic Telescope keybindings are defined in lua/anvndev/core/keymaps.lua

			-- Daily source finder: Go + Rust + Lua + configs
			vim.keymap.set("n", "<leader>ff", function()
				builtin.find_files({
					find_command = {
						"rg",
						"--files",
						"--hidden",

						-- Language sources (file-based, not folder-based)
						"--glob",
						"*.go",
						"--glob",
						"*.rs",
						"--glob",
						"*.lua",

						-- Project configs / docs
						"--glob",
						"*.yml",
						"--glob",
						"*.yaml",
						"--glob",
						"*.toml",
						"--glob",
						"*.json",
						"--glob",
						"*.md",

						-- Entry files
						"--glob",
						"go.mod",
						"--glob",
						"go.sum",
						"--glob",
						"Cargo.toml",
						"--glob",
						"build.rs",
						"--glob",
						"Dockerfile*",
					},
				})
			end, { desc = "Find source (Go + Rust + Lua)" })

			-- Go-only source finder (focused scope)
			vim.keymap.set("n", "<leader>fG", function()
				builtin.find_files({
					find_command = {
						"rg",
						"--files",
						"--hidden",
						"--glob",
						"cmd/**",
						"--glob",
						"internal/**",
						"--glob",
						"configs/**",
						"--glob",
						"deployments/**",
						"--glob",
						"*.go",
						"--glob",
						"go.mod",
						"--glob",
						"go.sum",
						"--glob",
						"Dockerfile*",
					},
				})
			end, { desc = "Find Go source (focused)" })

			-- Panic mode: absolute everything, bypass all ignores
			vim.keymap.set("n", "<leader>fl", function()
				builtin.find_files({
					find_command = {
						"fd",
						"--type",
						"f",
						"--hidden",
						"--no-ignore",
						"--follow",
						"--strip-cwd-prefix",
					},
				})
			end, { desc = "Find ALL files (panic mode)" })

			---------------------------------------------------------------------
			-- Highlight safety helper
			---------------------------------------------------------------------

			-- Ensure Telescope highlight groups exist
			local function ensure_telescope_highlights()
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
					if vim.fn.hlexists(group) == 0 then
						pcall(vim.cmd, string.format("highlight link %s %s", group, link))
					end
				end
			end

			-- Apply highlights on startup
			ensure_telescope_highlights()

			---------------------------------------------------------------------
			-- Telescope setup
			---------------------------------------------------------------------

			telescope.setup({
				defaults = {
					attach_mappings = function()
						ensure_telescope_highlights()
						return true
					end,
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
						vertical = { mirror = false },
						width = 0.87,
						height = 0.80,
						preview_cutoff = 120,
					},
					file_ignore_patterns = {
						"^.git/",
						"^node_modules/",
						"^dist/",
						"^bin/",
						"%.exe$",
					},
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
							["<CR>"] = actions.select_default,
							["<C-x>"] = actions.select_horizontal,
							["<C-v>"] = actions.select_vertical,
							["<C-t>"] = actions.select_tab,
							["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
							["<C-_>"] = actions.which_key,
						},
						n = {
							["<esc>"] = actions.close,
							["<CR>"] = actions.select_default,
							["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
							["j"] = actions.move_selection_next,
							["k"] = actions.move_selection_previous,
							["?"] = actions.which_key,
						},
					},
				},
				pickers = {
					find_files = {
						hidden = true,
						find_command = { "fd", "--type", "f", "--strip-cwd-prefix" },
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
					},
					buffers = {
						show_all_buffers = true,
						sort_lastused = true,
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
							i = {
								["<C-h>"] = fb_actions.goto_parent_dir,
								["<C-e>"] = fb_actions.create,
								["<C-d>"] = fb_actions.remove,
								["<C-r>"] = fb_actions.rename,
								["<C-s>"] = fb_actions.toggle_hidden,
								["<C-a>"] = fb_actions.toggle_all,
							},
							n = {
								["h"] = fb_actions.goto_parent_dir,
								["e"] = fb_actions.create,
								["d"] = fb_actions.remove,
								["r"] = fb_actions.rename,
								["s"] = fb_actions.toggle_hidden,
								["a"] = fb_actions.toggle_all,
							},
						},
					},
					["ui-select"] = require("telescope.themes").get_dropdown(),
				},
			})

			---------------------------------------------------------------------
			-- Load extensions
			---------------------------------------------------------------------

			telescope.load_extension("fzf")
			telescope.load_extension("file_browser")
			telescope.load_extension("ui-select")
			telescope.load_extension("project")
			telescope.load_extension("dap")
		end,
	},
}
