-- ~/.config/nvim/lua/anvndev/plugins/misc/git.lua
-- Git Integration Configuration
-- Author: anvndev
-- NOTE: This file consolidates configurations for Gitsigns, Fugitive, and LazyGit.

return {
	-- 1. Gitsigns: UI signs in the gutter and inline diffs
	{
		"lewis6991/gitsigns.nvim",
		event = { "BufReadPre", "BufNewFile" },
		config = function()
			require("gitsigns").setup({
				signs = {
					add = { text = "│" },
					change = { text = "│" },
					delete = { text = "_" },
					topdelete = { text = "‾" },
					changedelete = { text = "~" },
					untracked = { text = "┆" },
				},
				signcolumn = true, -- Toggle with `:Gitsigns toggle_signs`
				numhl = false, -- Toggle with `:Gitsigns toggle_numhl`
				linehl = false, -- Toggle with `:Gitsigns toggle_linehl`

				-- Word Diff: Disabled by default to reduce visual clutter.
				-- Use the keymap <leader>gw to toggle it when granular inspection is needed.
				word_diff = false,

				watch_gitdir = {
					follow_files = true,
				},
				-- Do not attach to untracked files automatically to prevent accidental actions
				attach_to_untracked = false,

				-- Current Line Blame: Shows who modified the line (ghost text)
				current_line_blame = false, -- Toggle with <leader>tb
				current_line_blame_opts = {
					virt_text = true,
					virt_text_pos = "eol", -- 'eol' | 'overlay' | 'right_align'
					delay = 1000,
					ignore_whitespace = false,
				},
				current_line_blame_formatter = " <author>, <author_time:%Y-%m-%d> - <summary>",
				sign_priority = 6,
				update_debounce = 150,
				status_formatter = nil, -- Use default
				max_file_length = 40000, -- Disable if file is longer than this (lines)

				-- Preview Options: Styling for floating windows (e.g., preview hunk)
				preview_config = {
					border = "rounded",
					style = "minimal",
					relative = "cursor",
					row = 0,
					col = 1,
					winblend = 0,
					max_width = 120,
					max_height = 30,
					wrap = false,
				},

				on_attach = function(bufnr)
					local gs = package.loaded.gitsigns

					local function map(mode, l, r, opts)
						opts = opts or {}
						opts.buffer = bufnr
						vim.keymap.set(mode, l, r, opts)
					end

					-- Navigation (Hunk jumping)
					map("n", "]c", function()
						if vim.wo.diff then
							return "]c"
						end
						vim.schedule(function()
							gs.next_hunk()
						end)
						return "<Ignore>"
					end, { expr = true, desc = "Next git hunk" })

					map("n", "[c", function()
						if vim.wo.diff then
							return "[c"
						end
						vim.schedule(function()
							gs.prev_hunk()
						end)
						return "<Ignore>"
					end, { expr = true, desc = "Previous git hunk" })

					-- Actions: Hunk Management
					map("n", "<leader>gs", gs.stage_hunk, { desc = "Stage hunk" })
					map("n", "<leader>gr", gs.reset_hunk, { desc = "Reset hunk" })

					-- Visual mode actions
					map("v", "<leader>gs", function()
						gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
					end, { desc = "Stage selected hunk" })
					map("v", "<leader>gr", function()
						gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
					end, { desc = "Reset selected hunk" })

					-- Buffer Management
					map("n", "<leader>gS", gs.stage_buffer, { desc = "Stage buffer" })
					map("n", "<leader>gu", gs.undo_stage_hunk, { desc = "Undo stage hunk" })
					map("n", "<leader>gR", gs.reset_buffer, { desc = "Reset buffer" })

					-- Previews
					map("n", "<leader>gp", gs.preview_hunk, { desc = "Preview hunk" })
					map("n", "<leader>gb", function()
						gs.blame_line({ full = true })
					end, { desc = "Blame line (full)" })

					-- Toggles
					map("n", "<leader>tb", gs.toggle_current_line_blame, { desc = "Toggle git blame line" })
					map("n", "<leader>gw", gs.toggle_word_diff, { desc = "Toggle word diff" }) -- Added: Toggle word diff
					map("n", "<leader>td", gs.toggle_deleted, { desc = "Toggle deleted lines" })

					-- Diff View
					map("n", "<leader>gd", gs.diffthis, { desc = "Diff against index" })
					map("n", "<leader>gD", function()
						gs.diffthis("~")
					end, { desc = "Diff against last commit" })
				end,
			})
		end,
	},

	-- 2. Vim-Fugitive: Git wrapper commands
	{
		"tpope/vim-fugitive",
		cmd = { "Git", "Gstatus", "Gblame", "Gpush", "Gpull" },
		keys = {
			{ "<leader>gg", "<cmd>Git<cr>", desc = "Git status (Fugitive)" },
			{ "<leader>gB", "<cmd>Git blame<cr>", desc = "Git blame (Fugitive)" },
			{ "<leader>gc", "<cmd>Git commit<cr>", desc = "Git commit" },
			{ "<leader>gL", "<cmd>Git log<cr>", desc = "Git log" },
			{ "<leader>gP", "<cmd>Git push<cr>", desc = "Git push" },
			-- CHANGED: Use gU (Update) for pull to avoid overlap with gp (preview)
			{ "<leader>gU", "<cmd>Git pull<cr>", desc = "Git pull" },
		},
	},

	-- 3. LazyGit: Terminal UI for Git
	{
		"kdheepak/lazygit.nvim",
		cmd = { "LazyGit", "LazyGitConfig", "LazyGitCurrentFile", "LazyGitFilter", "LazyGitFilterCurrentFile" },
		keys = {
			-- CHANGED: Use lg to avoid conflict with fugitive's gg (status)
			{ "<leader>lg", "<cmd>LazyGit<cr>", desc = "Open LazyGit" },
		},
		config = function()
			-- Visual adjustments for the floating window
			vim.g.lazygit_floating_window_winblend = 0
			vim.g.lazygit_floating_window_scaling_factor = 0.9
			vim.g.lazygit_floating_window_corner_chars = { "╭", "╮", "╰", "╯" }
			vim.g.lazygit_floating_window_use_plenary = 0
			vim.g.lazygit_use_neovim_remote = 0
		end,
	},

	-- 4. Octo.nvim: GitHub integration (Issues & PRs)
	{
		"pwntester/octo.nvim",
		cmd = "Octo",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-telescope/telescope.nvim",
			"nvim-tree/nvim-web-devicons",
		},
		config = function()
			require("octo").setup({
				use_local_fs = false,
				default_remote = { "upstream", "origin" },
				ssh_aliases = {},
				reaction_viewer_hint_icon = "",
				user_icon = " ",
				timeline_marker = "",
				timeline_indent = "2",
				right_bubble_delimiter = "",
				left_bubble_delimiter = "",
				github_hostname = "",
				snippet_context_lines = 4,
				file_panel = {
					size = 10,
					use_icons = true,
				},
				-- Key mappings for Octo buffers (Issues/PRs)
				mappings = {
					issue = {
						close_issue = { lhs = "<leader>ic", desc = "Close issue" },
						reopen_issue = { lhs = "<leader>io", desc = "Reopen issue" },
						list_issues = { lhs = "<leader>il", desc = "List open issues" },
						reload = { lhs = "<C-r>", desc = "Reload issue" },
						open_in_browser = { lhs = "<C-b>", desc = "Open in browser" },
						copy_url = { lhs = "<C-y>", desc = "Copy URL" },
						add_assignee = { lhs = "<leader>gha", desc = "Add assignee" },
						remove_assignee = { lhs = "<leader>ad", desc = "Remove assignee" },
						create_label = { lhs = "<leader>lc", desc = "Create label" },
						add_label = { lhs = "<leader>la", desc = "Add label" },
						remove_label = { lhs = "<leader>ld", desc = "Remove label" },
						goto_issue = { lhs = "<leader>gi", desc = "Go to local issue" },
						add_comment = { lhs = "<leader>ca", desc = "Add comment" },
						delete_comment = { lhs = "<leader>cd", desc = "Delete comment" },
						next_comment = { lhs = "]c", desc = "Next comment" },
						prev_comment = { lhs = "[c", desc = "Previous comment" },
						react_hooray = { lhs = "<leader>rp", desc = "React 🎉" },
						react_heart = { lhs = "<leader>rh", desc = "React ❤️" },
						react_eyes = { lhs = "<leader>re", desc = "React 👀" },
						react_thumbs_up = { lhs = "<leader>r+", desc = "React 👍" },
						react_thumbs_down = { lhs = "<leader>r-", desc = "React 👎" },
						react_rocket = { lhs = "<leader>rr", desc = "React 🚀" },
						react_laugh = { lhs = "<leader>rl", desc = "React 😄" },
						react_confused = { lhs = "<leader>rc", desc = "React 😕" },
					},
					pull_request = {
						checkout_pr = { lhs = "<leader>po", desc = "Checkout PR" },
						merge_pr = { lhs = "<leader>pm", desc = "Merge PR" },
						squash_and_merge_pr = { lhs = "<leader>psm", desc = "Squash & Merge PR" },
						list_commits = { lhs = "<leader>pc", desc = "List PR commits" },
						list_changed_files = { lhs = "<leader>pf", desc = "List changed files" },
						show_pr_diff = { lhs = "<leader>pd", desc = "Show PR diff" },
						add_reviewer = { lhs = "<leader>va", desc = "Add reviewer" },
						remove_reviewer = { lhs = "<leader>vd", desc = "Remove reviewer" },
						close_pr = { lhs = "<leader>pc", desc = "Close PR" },
						reopen_pr = { lhs = "<leader>po", desc = "Reopen PR" },
						list_prs = { lhs = "<leader>pl", desc = "List open PRs" },
						reload = { lhs = "<C-r>", desc = "Reload PR" },
						open_in_browser = { lhs = "<C-b>", desc = "Open in browser" },
						copy_url = { lhs = "<C-y>", desc = "Copy URL" },
						goto_file = { lhs = "gf", desc = "Go to file" },
						add_assignee = { lhs = "<leader>gha", desc = "Add assignee" },
						remove_assignee = { lhs = "<leader>ghd", desc = "Remove assignee" },
						create_label = { lhs = "<leader>lc", desc = "Create label" },
						add_label = { lhs = "<leader>la", desc = "Add label" },
						remove_label = { lhs = "<leader>ld", desc = "Remove label" },
						goto_issue = { lhs = "<leader>gi", desc = "Go to local issue" },
						add_comment = { lhs = "<leader>ca", desc = "Add comment" },
						delete_comment = { lhs = "<leader>cd", desc = "Delete comment" },
						next_comment = { lhs = "]c", desc = "Next comment" },
						prev_comment = { lhs = "[c", desc = "Previous comment" },
						react_hooray = { lhs = "<leader>rp", desc = "React 🎉" },
						react_heart = { lhs = "<leader>rh", desc = "React ❤️" },
						react_eyes = { lhs = "<leader>re", desc = "React 👀" },
						react_thumbs_up = { lhs = "<leader>r+", desc = "React 👍" },
						react_thumbs_down = { lhs = "<leader>r-", desc = "React 👎" },
						react_rocket = { lhs = "<leader>rr", desc = "React 🚀" },
						react_laugh = { lhs = "<leader>rl", desc = "React 😄" },
						react_confused = { lhs = "<leader>rc", desc = "React 😕" },
					},
					review_thread = {
						goto_issue = { lhs = "<leader>gi", desc = "Go to local issue" },
						add_comment = { lhs = "<leader>ca", desc = "Add comment" },
						add_suggestion = { lhs = "<leader>sa", desc = "Add suggestion" },
						delete_comment = { lhs = "<leader>cd", desc = "Delete comment" },
						next_comment = { lhs = "]c", desc = "Next comment" },
						prev_comment = { lhs = "[c", desc = "Previous comment" },
						select_next_entry = { lhs = "]q", desc = "Next changed file" },
						select_prev_entry = { lhs = "[q", desc = "Previous changed file" },
						close_review_tab = { lhs = "<C-c>", desc = "Close review tab" },
						react_hooray = { lhs = "<leader>rp", desc = "React 🎉" },
						react_heart = { lhs = "<leader>rh", desc = "React ❤️" },
						react_eyes = { lhs = "<leader>re", desc = "React 👀" },
						react_thumbs_up = { lhs = "<leader>r+", desc = "React 👍" },
						react_thumbs_down = { lhs = "<leader>r-", desc = "React 👎" },
						react_rocket = { lhs = "<leader>rr", desc = "React 🚀" },
						react_laugh = { lhs = "<leader>rl", desc = "React 😄" },
						react_confused = { lhs = "<leader>rc", desc = "React 😕" },
					},
					submit_win = {
						approve_review = { lhs = "<C-a>", desc = "Approve review" },
						comment_review = { lhs = "<C-m>", desc = "Submit comment" },
						request_changes = { lhs = "<C-r>", desc = "Request changes" },
						close_review_tab = { lhs = "<C-c>", desc = "Close review tab" },
					},
					review_diff = {
						add_review_comment = { lhs = "<leader>ca", desc = "Add review comment" },
						add_review_suggestion = { lhs = "<leader>sa", desc = "Add review suggestion" },
						focus_files = { lhs = "<leader>e", desc = "Focus file panel" },
						toggle_files = { lhs = "<leader>b", desc = "Toggle file panel" },
						next_thread = { lhs = "]t", desc = "Next thread" },
						prev_thread = { lhs = "[t", desc = "Previous thread" },
						select_next_entry = { lhs = "]q", desc = "Next changed file" },
						select_prev_entry = { lhs = "[q", desc = "Previous changed file" },
						close_review_tab = { lhs = "<C-c>", desc = "Close review tab" },
						toggle_viewed = { lhs = "<leader>v", desc = "Toggle viewed status" },
						goto_file = { lhs = "gf", desc = "Go to file" },
					},
					file_panel = {
						next_entry = { lhs = "j", desc = "Next file" },
						prev_entry = { lhs = "k", desc = "Previous file" },
						select_entry = { lhs = "<cr>", desc = "Show file diffs" },
						refresh_files = { lhs = "R", desc = "Refresh files" },
						focus_files = { lhs = "<leader>e", desc = "Focus file panel" },
						toggle_files = { lhs = "<leader>b", desc = "Toggle file panel" },
						select_next_entry = { lhs = "]q", desc = "Next changed file" },
						select_prev_entry = { lhs = "[q", desc = "Previous changed file" },
						close_review_tab = { lhs = "<C-c>", desc = "Close review tab" },
						toggle_viewed = { lhs = "<leader>v", desc = "Toggle viewed status" },
					},
				},
			})
		end,
	},
}
