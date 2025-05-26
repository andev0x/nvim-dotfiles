# Neovim Configuration

This is my personal Neovim configuration, built with a focus on modern development features and a clean, efficient workflow.

----

<p float="left">
  <img src="https://raw.githubusercontent.com/andevgo/description-image-archive/refs/heads/main/nvim-dotfies/p3.png" width="450" />
  <img src="https://raw.githubusercontent.com/andevgo/description-image-archive/refs/heads/main/nvim-dotfies/p4.png" width="450" />
</p>

## Features

- 🎨 Modern UI with custom theme
- 📦 Plugin management with lazy.nvim
- 🔍 Advanced search with Telescope
- 🧩 LSP support for multiple languages
- 🐛 Debugging capabilities with nvim-dap
- 📝 Enhanced editing with Treesitter
- 🎯 Language-specific configurations for:
  - Go
  - Rust
  - C/C++
  - Python

## Requirements

- Neovim 0.9.0 or higher
- Git
- A Nerd Font (for icons)

## Installation

1. Clone this repository:
```bash
git clone https://github.com/andevgo/nvim-dotfiles.git ~/.config/nvim
```

2. Start Neovim and let the plugins install:
```bash
nvim
```

## Structure

```
~/.config/nvim/
├── init.lua              # Main entry point
├── lua/
│   └── anvndev/         # Main configuration directory
│       ├── core/        # Core settings
│       ├── plugins/     # Plugin configurations
│       └── utils/       # Utility functions
└── after/               # After directory for overrides
```

## Key Features

- **Plugin Management**: Uses lazy.nvim for efficient plugin loading
- **LSP Integration**: Full language server protocol support
- **Debugging**: Integrated debugging with nvim-dap
- **File Navigation**: Enhanced file tree and fuzzy finding
- **Git Integration**: Git workflow improvements
- **Code Completion**: Intelligent code completion and snippets

## License

MIT [License](https://github.com/andevgo/nvim-dotfiles?tab=License-1-ov-file#readme) 