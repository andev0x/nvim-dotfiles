-- ~/.config/nvim/lua/anvndev/core/options.lua
-- General Neovim options and settings

local opt = vim.opt
local g = vim.g

-- Line numbers
opt.number = true
opt.relativenumber = true

-- Tabs & Indentation
opt.tabstop = 2
opt.shiftwidth = 2
opt.expandtab = true
opt.autoindent = true
opt.smartindent = true

-- Line wrapping
opt.wrap = false

-- Search settings
opt.ignorecase = true
opt.smartcase = true
opt.hlsearch = true
opt.incsearch = true

-- Cursor line
opt.cursorline = true

-- Appearance
opt.termguicolors = true
opt.background = "dark"
opt.signcolumn = "yes"
opt.scrolloff = 8
opt.sidescrolloff = 8
opt.cmdheight = 1
opt.pumheight = 10
opt.showmode = false

-- Backspace
opt.backspace = "indent,eol,start"

-- Clipboard
opt.clipboard:append("unnamedplus")

-- Split windows
opt.splitright = true
opt.splitbelow = true

-- Considered as part of a word
opt.iskeyword:append("-")

-- Disable swap and backup files
opt.swapfile = false
opt.backup = false
opt.writebackup = false

-- Persistent undo
opt.undofile = true
opt.undodir = vim.fn.stdpath("data") .. "/undodir"

-- Update time
opt.updatetime = 50 -- Faster update time for better responsiveness
opt.timeout = true
opt.timeoutlen = 300

-- Performance optimizations
opt.lazyredraw = true -- Don't redraw while executing macros
opt.ttyfast = true -- Faster terminal rendering
opt.ttimeoutlen = 10 -- Reduce key code delay

-- Completion
opt.completeopt = "menu,menuone,noselect"

-- Wild menu
opt.wildmenu = true
opt.wildmode = "longest:full,full"

-- Fold settings (using nvim-ufo)
opt.foldlevel = 99
opt.foldlevelstart = 99
opt.foldenable = true
opt.fillchars = [[eob: ,fold: ,foldopen: ,foldsep: ,foldclose: ]]

-- Keymaps
vim.keymap.set("n", "zc", "zc", { desc = "Close fold" })
vim.keymap.set("n", "zo", "zo", { desc = "Open fold" })
vim.keymap.set("n", "za", "za", { desc = "Toggle fold" })
vim.keymap.set("n", "<leader>zR", "zR", { desc = "Open all folds" })
vim.keymap.set("n", "<leader>zM", "zM", { desc = "Close all folds" })

-- iTerm2 specific settings
opt.mouse = "a" -- Enable mouse support

-- Disable providers we don't use
g.loaded_python3_provider = 0
g.loaded_ruby_provider = 0
g.loaded_perl_provider = 0
g.loaded_node_provider = 0

-- Disable builtin plugins
g.loaded_netrw = 1
g.loaded_netrwPlugin = 1

-- Additional useful options
opt.list = false -- Don't show invisible characters by default
opt.listchars = {
	tab = "→ ",
	extends = "⟩",
	precedes = "⟨",
	trail = "·",
	nbsp = "␣",
}
opt.breakindent = true -- Preserve indentation in wrapped lines
opt.showbreak = "↪ " -- Show wrapped line prefix
opt.inccommand = "split" -- Show effects of command incrementally

