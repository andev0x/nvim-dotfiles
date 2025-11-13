-- ~/.config/nvim/lua/anvndev/plugins/misc/git.lua
-- Git integration

return {
	-- Git signs in the gutter
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
				word_diff = false, -- Toggle with `:Gitsigns toggle_word_diff`
				watch_gitdir = {
					follow_files = true,
				},
				attach_to_untracked = true,
				current_line_blame = false, -- Toggle with `:Gitsigns toggle_current_line_blame`
				current_line_blame_opts = {
					virt_text = true,
					virt_text_pos = "eol", -- 'eol' | 'overlay' | 'right_align'
					delay = 1000,
					ignore_whitespace = false,
				},
				current_line_blame_formatter = " <author>, <author_time:%Y-%m-%d> - <summary>",
				sign_priority = 6,
				update_debounce = 100,
				status_formatter = nil, -- Use default
				max_file_length = 40000, -- Disable if file is longer than this (in lines)
				preview_config = {
					-- Options passed to nvim_open_win
					border = "rounded",
					style = "minimal",
					relative = "cursor",
					row = 0,
					col = 1,
				},
				yadm = {
					enable = false,
				},
				on_attach = function(bufnr)
					local gs = package.loaded.gitsigns

					local function map(mode, l, r, opts)
						opts = opts or {}
						opts.buffer = bufnr
						vim.keymap.set(mode, l, r, opts)
					end

					-- Navigation
					map("n", "]c", function()
						if vim.wo.diff then
							return "]c"
						end
						vim.schedule(function()
							gs.next_hunk()
						end)
						return "<Ignore>"
					end, { expr = true, desc = "Next hunk" })

					map("n", "[c", function()
						if vim.wo.diff then
							return "[c"
						end
						vim.schedule(function()
							gs.prev_hunk()
						end)
						return "<Ignore>"
					end, { expr = true, desc = "Previous hunk" })

					-- Actions
					map("n", "<leader>gs", gs.stage_hunk, { desc = "Stage hunk" })
					map("n", "<leader>gr", gs.reset_hunk, { desc = "Reset hunk" })
					map("v", "<leader>gs", function()
						gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
					end, { desc = "Stage selected hunk" })
					map("v", "<leader>gr", function()
						gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
					end, { desc = "Reset selected hunk" })
					map("n", "<leader>gS", gs.stage_buffer, { desc = "Stage buffer" })
					map("n", "<leader>gu", gs.undo_stage_hunk, { desc = "Undo stage hunk" })
					map("n", "<leader>gR", gs.reset_buffer, { desc = "Reset buffer" })
					map("n", "<leader>gp", gs.preview_hunk, { desc = "Preview hunk" })
					map("n", "<leader>gb", function()
						gs.blame_line({ full = true })
					end, { desc = "Blame line" })
					map("n", "<leader>gl", gs.toggle_current_line_blame, { desc = "Toggle line blame" })
					map("n", "<leader>gd", gs.diffthis, { desc = "Diff this" })
					map("n", "<leader>gD", function()
						gs.diffthis("~")
					end, { desc = "Diff this ~" })
					map("n", "<leader>gt", gs.toggle_deleted, { desc = "Toggle deleted" })
				end,
			})
		end,
	},

	-- Git commands
	{
		"tpope/vim-fugitive",
		cmd = { "Git", "Gstatus", "Gblame", "Gpush", "Gpull" },
		keys = {
			{ "<leader>gg", "<cmd>Git<cr>", desc = "Git status" },
			{ "<leader>gb", "<cmd>Git blame<cr>", desc = "Git blame" },
			{ "<leader>gc", "<cmd>Git commit<cr>", desc = "Git commit" },
			{ "<leader>gd", "<cmd>Gdiffsplit<cr>", desc = "Git diff" },
			{ "<leader>gl", "<cmd>Git log<cr>", desc = "Git log" },
			{ "<leader>gp", "<cmd>Git push<cr>", desc = "Git push" },
			{ "<leader>gP", "<cmd>Git pull<cr>", desc = "Git pull" },
		},
	},

	-- LazyGit integration
	{
		"kdheepak/lazygit.nvim",
		cmd = { "LazyGit", "LazyGitConfig", "LazyGitCurrentFile", "LazyGitFilter", "LazyGitFilterCurrentFile" },
		keys = {
			{ "<leader>gg", "<cmd>LazyGit<cr>", desc = "LazyGit" },
		},
		config = function()
			vim.g.lazygit_floating_window_winblend = 0
			vim.g.lazygit_floating_window_scaling_factor = 0.9
			vim.g.lazygit_floating_window_corner_chars = { "╭", "╮", "╰", "╯" }
			vim.g.lazygit_floating_window_use_plenary = 0
			vim.g.lazygit_use_neovim_remote = 0
		end,
	},

	-- GitHub integration
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
				mappings = {
					issue = {
						close_issue = { lhs = "<leader>ic", desc = "close issue" },
						reopen_issue = { lhs = "<leader>io", desc = "reopen issue" },
						list_issues = { lhs = "<leader>il", desc = "list open issues on same repo" },
						reload = { lhs = "<C-r>", desc = "reload issue" },
						open_in_browser = { lhs = "<C-b>", desc = "open issue in browser" },
						copy_url = { lhs = "<C-y>", desc = "copy url to system clipboard" },
						add_assignee = { lhs = "<leader>aa", desc = "add assignee" },
						remove_assignee = { lhs = "<leader>ad", desc = "remove assignee" },
						create_label = { lhs = "<leader>lc", desc = "create label" },
						add_label = { lhs = "<leader>la", desc = "add label" },
						remove_label = { lhs = "<leader>ld", desc = "remove label" },
						goto_issue = { lhs = "<leader>gi", desc = "navigate to a local repo issue" },
						add_comment = { lhs = "<leader>ca", desc = "add comment" },
						delete_comment = { lhs = "<leader>cd", desc = "delete comment" },
						next_comment = { lhs = "]c", desc = "go to next comment" },
						prev_comment = { lhs = "[c", desc = "go to previous comment" },
						react_hooray = { lhs = "<leader>rp", desc = "add/remove 🎉 reaction" },
						react_heart = { lhs = "<leader>rh", desc = "add/remove ❤️ reaction" },
						react_eyes = { lhs = "<leader>re", desc = "add/remove 👀 reaction" },
						react_thumbs_up = { lhs = "<leader>r+", desc = "add/remove 👍 reaction" },
						react_thumbs_down = { lhs = "<leader>r-", desc = "add/remove 👎 reaction" },
						react_rocket = { lhs = "<leader>rr", desc = "add/remove 🚀 reaction" },
						react_laugh = { lhs = "<leader>rl", desc = "add/remove 😄 reaction" },
						react_confused = { lhs = "<leader>rc", desc = "add/remove 😕 reaction" },
					},
					pull_request = {
						checkout_pr = { lhs = "<leader>po", desc = "checkout PR" },
						merge_pr = { lhs = "<leader>pm", desc = "merge commit PR" },
						squash_and_merge_pr = { lhs = "<leader>psm", desc = "squash and merge PR" },
						list_commits = { lhs = "<leader>pc", desc = "list PR commits" },
						list_changed_files = { lhs = "<leader>pf", desc = "list PR changed files" },
						show_pr_diff = { lhs = "<leader>pd", desc = "show PR diff" },
						add_reviewer = { lhs = "<leader>va", desc = "add reviewer" },
						remove_reviewer = { lhs = "<leader>vd", desc = "remove reviewer request" },
						close_pr = { lhs = "<leader>pc", desc = "close PR" },
						reopen_pr = { lhs = "<leader>po", desc = "reopen PR" },
						list_prs = { lhs = "<leader>pl", desc = "list open PRs on same repo" },
						reload = { lhs = "<C-r>", desc = "reload PR" },
						open_in_browser = { lhs = "<C-b>", desc = "open PR in browser" },
						copy_url = { lhs = "<C-y>", desc = "copy url to system clipboard" },
						goto_file = { lhs = "gf", desc = "go to file" },
						add_assignee = { lhs = "<leader>aa", desc = "add assignee" },
						remove_assignee = { lhs = "<leader>ad", desc = "remove assignee" },
						create_label = { lhs = "<leader>lc", desc = "create label" },
						add_label = { lhs = "<leader>la", desc = "add label" },
						remove_label = { lhs = "<leader>ld", desc = "remove label" },
						goto_issue = { lhs = "<leader>gi", desc = "navigate to a local repo issue" },
						add_comment = { lhs = "<leader>ca", desc = "add comment" },
						delete_comment = { lhs = "<leader>cd", desc = "delete comment" },
						next_comment = { lhs = "]c", desc = "go to next comment" },
						prev_comment = { lhs = "[c", desc = "go to previous comment" },
						react_hooray = { lhs = "<leader>rp", desc = "add/remove 🎉 reaction" },
						react_heart = { lhs = "<leader>rh", desc = "add/remove ❤️ reaction" },
						react_eyes = { lhs = "<leader>re", desc = "add/remove 👀 reaction" },
						react_thumbs_up = { lhs = "<leader>r+", desc = "add/remove 👍 reaction" },
						react_thumbs_down = { lhs = "<leader>r-", desc = "add/remove 👎 reaction" },
						react_rocket = { lhs = "<leader>rr", desc = "add/remove 🚀 reaction" },
						react_laugh = { lhs = "<leader>rl", desc = "add/remove 😄 reaction" },
						react_confused = { lhs = "<leader>rc", desc = "add/remove 😕 reaction" },
					},
					review_thread = {
						goto_issue = { lhs = "<leader>gi", desc = "navigate to a local repo issue" },
						add_comment = { lhs = "<leader>ca", desc = "add comment" },
						add_suggestion = { lhs = "<leader>sa", desc = "add suggestion" },
						delete_comment = { lhs = "<leader>cd", desc = "delete comment" },
						next_comment = { lhs = "]c", desc = "go to next comment" },
						prev_comment = { lhs = "[c", desc = "go to previous comment" },
						select_next_entry = { lhs = "]q", desc = "move to previous changed file" },
						select_prev_entry = { lhs = "[q", desc = "move to next changed file" },
						close_review_tab = { lhs = "<C-c>", desc = "close review tab" },
						react_hooray = { lhs = "<leader>rp", desc = "add/remove 🎉 reaction" },
						react_heart = { lhs = "<leader>rh", desc = "add/remove ❤️ reaction" },
						react_eyes = { lhs = "<leader>re", desc = "add/remove 👀 reaction" },
						react_thumbs_up = { lhs = "<leader>r+", desc = "add/remove 👍 reaction" },
						react_thumbs_down = { lhs = "<leader>r-", desc = "add/remove 👎 reaction" },
						react_rocket = { lhs = "<leader>rr", desc = "add/remove 🚀 reaction" },
						react_laugh = { lhs = "<leader>rl", desc = "add/remove 😄 reaction" },
						react_confused = { lhs = "<leader>rc", desc = "add/remove 😕 reaction" },
					},
					submit_win = {
						approve_review = { lhs = "<C-a>", desc = "approve review" },
						comment_review = { lhs = "<C-m>", desc = "comment review" },
						request_changes = { lhs = "<C-r>", desc = "request changes review" },
						close_review_tab = { lhs = "<C-c>", desc = "close review tab" },
					},
					review_diff = {
						add_review_comment = { lhs = "<leader>ca", desc = "add a new review comment" },
						add_review_suggestion = { lhs = "<leader>sa", desc = "add a new review suggestion" },
						focus_files = { lhs = "<leader>e", desc = "move focus to changed file panel" },
						toggle_files = { lhs = "<leader>b", desc = "hide/show changed files panel" },
						next_thread = { lhs = "]t", desc = "move to next thread" },
						prev_thread = { lhs = "[t", desc = "move to previous thread" },
						select_next_entry = { lhs = "]q", desc = "move to previous changed file" },
						select_prev_entry = { lhs = "[q", desc = "move to next changed file" },
						close_review_tab = { lhs = "<C-c>", desc = "close review tab" },
						toggle_viewed = { lhs = "<leader>v", desc = "toggle viewer viewed state" },
						goto_file = { lhs = "gf", desc = "go to file" },
					},
					file_panel = {
						next_entry = { lhs = "j", desc = "move to next changed file" },
						prev_entry = { lhs = "k", desc = "move to previous changed file" },
						select_entry = { lhs = "<cr>", desc = "show selected changed file diffs" },
						refresh_files = { lhs = "R", desc = "refresh changed files panel" },
						focus_files = { lhs = "<leader>e", desc = "move focus to changed file panel" },
						toggle_files = { lhs = "<leader>b", desc = "hide/show changed files panel" },
						select_next_entry = { lhs = "]q", desc = "move to previous changed file" },
						select_prev_entry = { lhs = "[q", desc = "move to next changed file" },
						close_review_tab = { lhs = "<C-c>", desc = "close review tab" },
						toggle_viewed = { lhs = "<leader>v", desc = "toggle viewer viewed state" },
					},
				},
			})
		end,
	},
}

