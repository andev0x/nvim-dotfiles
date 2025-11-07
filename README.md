# Neovim Configuration

This is my personal Neovim configuration, built with a focus on modern development features and a clean, efficient workflow.

----

<p align="center">
  <img src="https://raw.githubusercontent.com/andev0x/description-image-archive/refs/heads/main/nvim-dotfies/p5.png" width="350" />
  <img src="https://raw.githubusercontent.com/andev0x/description-image-archive/refs/heads/main/nvim-dotfies/p6.png" width="350" />
</p>

<div align="center">

# nvim-dotfiles by andev0x

 [![License: MIT](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE) [![Neovim](https://img.shields.io/badge/Neovim-%3E=0.9.0-blueviolet?logo=neovim)](https://neovim.io/) [![Neovim](https://img.shields.io/badge/my%20blog-andev0x-blue)](https://andev0x.github.io/)

</div>

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
  - Sql

## Requirements

- Neovim 0.9.0 or higher
- Git
- A Nerd Font (for icons)

## Installation

1. Clone this repository:
```bash
git clone https://github.com/andev0x/nvim-dotfiles.git ~/.config/nvim
```

2. Start Neovim and let the plugins install:
```bash
nvim
```

## Structure

```
~/.config/nvim/
├── init.lua             # Main entry point
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

MIT [License](LICENSE)

