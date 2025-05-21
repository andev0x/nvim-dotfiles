-- ~/.config/nvim/lua/anvndev/core/keymaps.lua
-- Global key mappings

local utils = require("anvndev.utils")
local keymap = utils.keymap

-- Clear search highlights
keymap("n", "<Esc>", ":nohl<CR>", { desc = "Clear search highlights" })

-- Window navigation
keymap("n", "<C-h>", "<C-w>h", { desc = "Navigate to left window" })
keymap("n", "<C-j>", "<C-w>j", { desc = "Navigate to bottom window" })
keymap("n", "<C-k>", "<C-w>k", { desc = "Navigate to top window" })
keymap("n", "<C-l>", "<C-w>l", { desc = "Navigate to right window" })

-- Resize windows
keymap("n", "<C-Up>", ":resize -2<CR>", { desc = "Decrease window height" })
keymap("n", "<C-Down>", ":resize +2<CR>", { desc = "Increase window height" })
keymap("n", "<C-Left>", ":vertical resize -2<CR>", { desc = "Decrease window width" })
keymap("n", "<C-Right>", ":vertical resize +2<CR>", { desc = "Increase window width" })

-- Buffer navigation
keymap("n", "<S-l>", ":bnext<CR>", { desc = "Next buffer" })
keymap("n", "<S-h>", ":bprevious<CR>", { desc = "Previous buffer" })
keymap("n", "<leader>bd", ":bdelete<CR>", { desc = "Delete buffer" })

-- Move text up and down
keymap("n", "<A-j>", ":m .+1<CR>==", { desc = "Move line down" })
keymap("n", "<A-k>", ":m .-2<CR>==", { desc = "Move line up" })
keymap("v", "<A-j>", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
keymap("v", "<A-k>", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })

-- Stay in indent mode when indenting in visual mode
keymap("v", "<", "<gv", { desc = "Decrease indent and stay in visual mode" })
keymap("v", ">", ">gv", { desc = "Increase indent and stay in visual mode" })

-- Don't yank on delete char
keymap("n", "x", '"_x', { desc = "Delete character without yanking" })

-- Don't yank on visual paste
keymap("v", "p", '"_dP', { desc = "Paste without yanking" })

-- File explorer
keymap("n", "<leader>e", ":NvimTreeToggle<CR>", { desc = "Toggle file explorer" })

-- Telescope
keymap("n", "<leader>ff", ":Telescope find_files<CR>", { desc = "Find files" })
keymap("n", "<leader>fg", ":Telescope live_grep<CR>", { desc = "Live grep" })
keymap("n", "<leader>fb", ":Telescope buffers<CR>", { desc = "Find buffers" })
keymap("n", "<leader>fh", ":Telescope help_tags<CR>", { desc = "Help tags" })
keymap("n", "<leader>fc", ":Telescope commands<CR>", { desc = "Commands" })
keymap("n", "<leader>fr", ":Telescope oldfiles<CR>", { desc = "Recent files" })
keymap("n", "<leader>fk", ":Telescope keymaps<CR>", { desc = "Keymaps" })

-- LSP
keymap("n", "<leader>ld", vim.diagnostic.open_float, { desc = "Line diagnostics" })
keymap("n", "[d", vim.diagnostic.goto_prev, { desc = "Previous diagnostic" })
keymap("n", "]d", vim.diagnostic.goto_next, { desc = "Next diagnostic" })
keymap("n", "<leader>lq", vim.diagnostic.setloclist, { desc = "Diagnostics list" })

-- Git
keymap("n", "<leader>gg", ":LazyGit<CR>", { desc = "LazyGit" })
keymap("n", "<leader>gj", ":Gitsigns next_hunk<CR>", { desc = "Next git hunk" })
keymap("n", "<leader>gk", ":Gitsigns prev_hunk<CR>", { desc = "Previous git hunk" })
keymap("n", "<leader>gl", ":Gitsigns blame_line<CR>", { desc = "Git blame line" })
keymap("n", "<leader>gp", ":Gitsigns preview_hunk<CR>", { desc = "Preview git hunk" })
keymap("n", "<leader>gr", ":Gitsigns reset_hunk<CR>", { desc = "Reset git hunk" })
keymap("n", "<leader>gs", ":Gitsigns stage_hunk<CR>", { desc = "Stage git hunk" })
keymap("n", "<leader>gu", ":Gitsigns undo_stage_hunk<CR>", { desc = "Undo stage git hunk" })

-- Debugging
keymap("n", "<leader>db", ":lua require'dap'.toggle_breakpoint()<CR>", { desc = "Toggle breakpoint" })
keymap("n", "<leader>dc", ":lua require'dap'.continue()<CR>", { desc = "Continue" })
keymap("n", "<leader>di", ":lua require'dap'.step_into()<CR>", { desc = "Step into" })
keymap("n", "<leader>do", ":lua require'dap'.step_over()<CR>", { desc = "Step over" })
keymap("n", "<leader>dO", ":lua require'dap'.step_out()<CR>", { desc = "Step out" })
keymap("n", "<leader>dr", ":lua require'dap'.repl.toggle()<CR>", { desc = "Toggle REPL" })
keymap("n", "<leader>dl", ":lua require'dap'.run_last()<CR>", { desc = "Run last" })
keymap("n", "<leader>du", ":lua require'dapui'.toggle()<CR>", { desc = "Toggle DAP UI" })
keymap("n", "<leader>dt", ":lua require'dap'.terminate()<CR>", { desc = "Terminate" })

-- Terminal
keymap("n", "<leader>t", ":ToggleTerm<CR>", { desc = "Toggle terminal" })
keymap("t", "<Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

-- Lazygit
keymap("n", "<leader>gg", ":LazyGit<CR>", { desc = "LazyGit" })