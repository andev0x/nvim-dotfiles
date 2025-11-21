-- ~/.config/nvim/lua/anvndev/core/options.lua
-- ==================================================
-- Core Neovim settings for anvndev setup
-- ==================================================

local opt = vim.opt
local g = vim.g

-- General ---------------------------------------------------
opt.number = true -- Show absolute line numbers
opt.relativenumber = true -- Show relative line numbers
opt.mouse = "a" -- Enable mouse support
opt.clipboard = "unnamedplus" -- Sync with system clipboard
opt.swapfile = false -- Disable swap files
opt.backup = false -- Disable backups
opt.undofile = true -- Persistent undo history
opt.encoding = "utf-8" -- Set UTF-8 encoding
opt.termguicolors = true -- Enable 24-bit color
opt.hidden = true -- Allow hidden unsaved buffers
opt.signcolumn = "yes" -- Always show sign column
opt.cursorline = true -- Highlight current line
opt.scrolloff = 8 -- Keep cursor centered
opt.sidescrolloff = 8
opt.wrap = false -- Disable line wrap
opt.updatetime = 300 -- Faster CursorHold update time
opt.timeoutlen = 500 -- Faster key sequence timeout
opt.splitbelow = true -- Horizontal splits below
opt.splitright = true -- Vertical splits to the right
opt.ignorecase = true -- Ignore case in searches
opt.smartcase = true -- But respect case if typed
opt.incsearch = true -- Show matches while typing
opt.hlsearch = true -- Highlight search matches

-- Tabs & Indentation ----------------------------------------
opt.expandtab = true -- Use spaces instead of tabs
opt.tabstop = 4 -- Number of spaces per tab
opt.shiftwidth = 4 -- Indentation size
opt.smartindent = true -- Auto-indent new lines

-- UI & Appearance -------------------------------------------
opt.laststatus = 3 -- Global statusline
opt.showmode = false -- Hide "-- INSERT --" message
opt.cmdheight = 1
opt.fillchars:append({ eob = " " }) -- Hide ~ at end of buffer
opt.conceallevel = 2 -- Conceal markdown syntax

-- Performance -----------------------------------------------
opt.lazyredraw = true
opt.synmaxcol = 300 -- Limit syntax highlight width

-- Disable some built-in plugins ------------------------------
g.loaded_netrw = 1
g.loaded_netrwPlugin = 1

-- ==================================================
-- 🧠 End of options.lua
-- ==================================================
