#!/usr/bin/env bash
set -e

echo "────────────────────────────────────"
echo " Neovim Treesitter Environment Check"
echo "────────────────────────────────────"

# -------------------------------------------------
# OS + ARCH
# -------------------------------------------------
OS="$(uname -s)"
ARCH="$(uname -m)"

echo "OS      : $OS"
echo "ARCH    : $ARCH"

case "$OS" in
  Darwin) PLATFORM="macOS" ;;
  Linux)  PLATFORM="Linux" ;;
  *)      echo "❌ Unsupported OS"; exit 1 ;;
esac

echo "Platform: $PLATFORM"
echo

# -------------------------------------------------
# Neovim
# -------------------------------------------------
if ! command -v nvim >/dev/null; then
  echo "❌ Neovim not found"
  exit 1
fi

NVIM_VERSION=$(nvim --version | head -n1)
echo "Neovim : $NVIM_VERSION"

if ! nvim --version | grep -q "v0.1[0-9]"; then
  echo "❌ Neovim >= 0.10 required"
  exit 1
fi

echo "✅ Neovim version OK"
echo

# -------------------------------------------------
# Compiler check
# -------------------------------------------------
echo "Checking C compiler..."

COMPILER=""

for c in clang gcc cc; do
  if command -v $c >/dev/null; then
    COMPILER="$c"
    break
  fi
done

if [ -z "$COMPILER" ]; then
  echo "❌ No C compiler found"
  echo "Treesitter parsers cannot be built"
  exit 1
fi

echo "✅ Compiler found: $COMPILER"
echo

# -------------------------------------------------
# Homebrew hint
# -------------------------------------------------
if [[ "$PLATFORM" == "macOS" ]]; then
  if ! command -v brew >/dev/null; then
    echo "⚠️  Homebrew not found"
    echo "   Recommended:"
    echo '   /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"'
    echo
  fi
fi

# -------------------------------------------------
# Treesitter runtime test
# -------------------------------------------------
echo "Testing Treesitter runtime..."

if nvim --headless +"lua require('nvim-treesitter.configs')" +q 2>/tmp/ts_err.log; then
  echo "✅ Treesitter module load OK"
else
  echo "❌ Treesitter failed to load"
  echo "---- error ----"
  cat /tmp/ts_err.log
  exit 1
fi

echo
echo "🎉 Environment looks good"
echo "Safe to run this Neovim config on this machine"
