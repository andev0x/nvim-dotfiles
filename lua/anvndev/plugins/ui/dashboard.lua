-- ~/.config/nvim/lua/anvndev/plugins/ui/dashboard.lua
-- Dashboard configuration

return {
	{
		"goolord/alpha-nvim",
		event = "VimEnter",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			local alpha = require("alpha")
			local dashboard = require("alpha.themes.dashboard")

			-- Custom header
			dashboard.section.header.val = {
				[[                                                                       ]],
				[[                                                                       ]],
				[[    █████╗ ███╗   ██╗██╗   ██╗███╗   ██╗██████╗ ███████╗██╗   ██╗     ]],
				[[   ██╔══██╗████╗  ██║██║   ██║████╗  ██║██╔══██╗██╔════╝██║   ██║     ]],
				[[   ███████║██╔██╗ ██║██║   ██║██╔██╗ ██║██║  ██║█████╗  ██║   ██║     ]],
				[[   ██╔══██║██║╚██╗██║╚██╗ ██╔╝██║╚██╗██║██║  ██║██╔══╝  ╚██╗ ██╔╝     ]],
				[[   ██║  ██║██║ ╚████║ ╚████╔╝ ██║ ╚████║██████╔╝███████╗ ╚████╔╝      ]],
				[[   ╚═╝  ╚═╝╚═╝  ╚═══╝  ╚═══╝  ╚═╝  ╚═══╝╚═════╝ ╚══════╝  ╚═══╝       ]],
				[[                                                                       ]],
				[[                     ⟦ Backend Development ⟧                           ]],
				[[                                                                       ]],
			}

			-- Menu options
			dashboard.section.buttons.val = {
				dashboard.button("f", "  👀 Find file", ":Telescope find_files <CR>"),
				dashboard.button("e", "  📄 New file", ":ene <BAR> startinsert <CR>"),
				dashboard.button("r", "  🕙 Recent files", ":Telescope oldfiles <CR>"),
				dashboard.button("t", "  🔍 Find text", ":Telescope live_grep <CR>"),
				dashboard.button("o", "  📂 Open folder", ":NvimTreeToggle<CR>"),
				dashboard.button("c", "  🔗 Configuration", ":e $MYVIMRC <CR>"),
				dashboard.button("p", "  🧰 Plugins", ":Lazy<CR>"),
				dashboard.button("q", "  ⛔ Quit Neovim", ":qa<CR>"),
			}

			-- Footer
			local function footer()
				local stats = require("lazy").stats()
				local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
				return "⚡ Neovim loaded " .. stats.count .. " plugins in " .. ms .. "ms"
			end

			dashboard.section.footer.val = footer()
			dashboard.section.footer.opts.hl = "Type"
			dashboard.section.header.opts.hl = "Include"
			dashboard.section.buttons.opts.hl = "Keyword"

			dashboard.opts.opts.noautocmd = true
			alpha.setup(dashboard.opts)

			-- Auto start Alpha when no arguments and no buffers
			vim.api.nvim_create_autocmd("User", {
				pattern = "LazyVimStarted",
				callback = function()
					local stats = require("lazy").stats()
					local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
					dashboard.section.footer.val = "⚡ Neovim loaded " .. stats.count .. " plugins in " .. ms .. "ms"
					pcall(vim.cmd.AlphaRedraw)
				end,
			})
		end,
	},
}

