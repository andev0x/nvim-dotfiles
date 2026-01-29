
<div align="center">

<h1>Neovim Configuration</h1>


![License](https://img.shields.io/badge/License-MIT-green.svg)
![Neovim](https://img.shields.io/badge/Neovim-%3E=0.9.0-blueviolet?logo=neovim)
![Status](https://img.shields.io/badge/status-active-success.svg)

Professional Neovim configuration optimized for modern development workflows across multiple languages.

[📸 Screenshots](#screenshots) • [🚀 Quick Start](#quick-start) • [📋 Features](#features) • [🏗️ Architecture](#architecture)

</div>

---

## Overview

A fully-featured Neovim configuration with language server support, debugging capabilities, and advanced editing tools. Built for developers who demand both productivity and extensibility.

### Core Technologies

- **Plugin Manager**: [lazy.nvim](https://github.com/folke/lazy.nvim) - Fast, efficient lazy loading
- **LSP Framework**: Native LSP with full language server support
- **Fuzzy Finder**: [Telescope](https://github.com/nvim-telescope/telescope.nvim) - Advanced search and navigation
- **Syntax Parsing**: [Treesitter](https://github.com/nvim-treesitter/nvim-treesitter) - Precise syntax highlighting and code understanding
- **Debugging**: [nvim-dap](https://github.com/mfussenegger/nvim-dap) - Multi-language debugging
- **Code Completion**: LSP + snippet integration

## Screenshots

<p align="center">
  <img src="https://raw.githubusercontent.com/andev0x/description-image-archive/refs/heads/main/nvim-dotfies/p5.png" width="350" />
  <img src="https://raw.githubusercontent.com/andev0x/description-image-archive/refs/heads/main/nvim-dotfies/p6.png" width="350" />
</p>

## Features

### Language Support
- **Go** - Full LSP with gopls, debugging
- **Rust** - rust-analyzer integration, clippy linting
- **C/C++** - clangd support, debugging
- **Python** - pyright/pylance integration
- **SQL** - Schema-aware completion

### Development Features
- Full LSP protocol implementation
- Real-time diagnostic display
- Code formatting and linting
- Multi-language debugging via DAP
- Git integration and workflow tools
- Smart code completion with snippets
- Treesitter-powered code navigation

## Requirements

| Component | Version |
|-----------|---------|
| Neovim | 0.9.0+ |
| Git | Any |
| Font | Nerd Font (for icons) |
| CLI Tools | `fd`, `ripgrep` |

## Quick Start

### Installation

```bash
git clone https://github.com/andev0x/nvim-dotfiles.git ~/.config/nvim
```

### First Launch

```bash
nvim
```

The configuration will automatically install all plugins on first launch via lazy.nvim.

### Environment Verification

```bash
chmod +x scripts/check-nvim-env.sh
./scripts/check-nvim-env.sh
```

### Arch Linux

Install required tools:
```bash
sudo pacman -S fd ripgrep
```

## Architecture

### Directory Structure

```
~/.config/nvim/
├── init.lua                    # Entry point
├── lua/
│   └── anvndev/
│       ├── core/              # Core editor settings
│       │   ├── settings.lua    # Base Neovim configuration
│       │   └── keymaps.lua     # Key bindings
│       ├── plugins/            # Plugin specifications
│       │   ├── lsp.lua         # LSP configuration
│       │   ├── completion.lua  # Code completion
│       │   ├── ui.lua          # UI enhancements
│       │   └── tools.lua       # Development tools
│       └── utils/              # Helper functions
└── after/                      # Post-initialization overrides
```

### Plugin Management

Configuration uses lazy.nvim for efficient plugin loading. Plugins are specified in `lua/anvndev/plugins/` with lazy-loading rules to minimize startup time.

### LSP Integration

Language servers are automatically configured per-language in respective plugin modules. Each language has:
- Server initialization
- Diagnostic filtering
- Custom key bindings
- Formatting configuration

## Customization

### Adding Language Support

1. Create a new plugin module in `lua/anvndev/plugins/`
2. Specify the language server configuration
3. Add formatting/linting preferences
4. Reload Neovim

### Extending Keybindings

Edit `lua/anvndev/core/keymaps.lua` to add custom mappings. Use `vim.keymap.set()` for consistency.

### Theme Customization

Theme settings are centralized in `lua/anvndev/plugins/ui.lua`. Modify highlight groups and colors as needed.

## Development

### Running Tests

```bash
./scripts/check-nvim-env.sh
```

### Contributing

This is a personal configuration. For questions or suggestions, see the main repository.

## License

[MIT License](LICENSE)

## Author
[andev0x](github.com/andev0x)
