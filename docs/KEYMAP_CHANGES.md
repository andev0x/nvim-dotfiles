# Keymap Changes - Conflict Resolution

This document outlines the changes made to resolve which-key warnings about overlapping keymaps.

## Summary of Changes

All conflicting keymaps have been remapped to avoid overlaps with Vim's native commands and between plugins.

---

## 1. Surround Operations (nvim-surround)

**Previously:** Used `ys`, `yS`, `cs`, `cS`, `ds` which conflicted with Vim's native `c` (change) command and overlapped with each other.

**New Mappings (gz prefix):**

### Normal Mode
| Old Keymap | New Keymap | Description |
|------------|------------|-------------|
| `ys{motion}{char}` | `gza{motion}{char}` | **G**o **Z**urround **A**dd around motion |
| `yss{char}` | `gzl{char}` | **G**o **Z**urround **L**ine |
| `yS{motion}{char}` | `gzA{motion}{char}` | **G**o **Z**urround **A**dd (new lines) |
| `ySS{char}` | `gzL{char}` | **G**o **Z**urround **L**ine (new lines) |
| `ds{char}` | `gzd{char}` | **G**o **Z**urround **D**elete |
| `cs{old}{new}` | `gzr{old}{new}` | **G**o **Z**urround **R**eplace |
| `cS{old}{new}` | `gzR{old}{new}` | **G**o **Z**urround **R**eplace (new lines) |

### Visual Mode
| Old Keymap | New Keymap | Description |
|------------|------------|-------------|
| `S{char}` | `gza{char}` | **G**o **Z**urround **A**dd around selection |
| `gS{char}` | `gzA{char}` | **G**o **Z**urround **A**dd (new lines) |

### Insert Mode
| Old Keymap | New Keymap | Description |
|------------|------------|-------------|
| `<C-g>s{char}` | `<M-s>s{char}` | **Alt-S** **S**urround cursor |
| `<C-g>S{char}` | `<M-s>S{char}` | **Alt-S** **S**urround cursor (new lines) |

**Rationale:** 
- Uses `gz` prefix (mnemonic: **G**o **Z**urround) for all surround operations
- `gza` = **A**dd surround
- `gzl` = surround **L**ine
- `gzd` = **D**elete surround
- `gzr` = **R**eplace surround
- `<M-s>` (Alt-s) in insert mode avoids conflicts with `<C-s>` (LSP signature help)
- No overlaps, no conflicts with native Vim commands
- Consistent two-letter prefix avoids timing issues

---

## 2. Comment Operations (Comment.nvim)

**Previously:** Used `gc`, `gcc`, `gb`, `gbc` which overlapped with each other and caused timing conflicts.

**New Mappings (leader c prefix):**

### Normal Mode
| Old Keymap | New Keymap | Description |
|------------|------------|-------------|
| `gcc` | `<leader>cc` | Toggle comment on current line |
| `gc{motion}` | `<leader>cm{motion}` | Toggle comment on motion |
| `gbc` | `<leader>cb` | Toggle block comment on current line |
| `gb{motion}` | `<leader>cB{motion}` | Toggle block comment on motion |
| `gcO` | `<leader>cO` | Add comment above |
| `gco` | `<leader>co` | Add comment below |
| `gcA` | `<leader>cA` | Add comment at end of line |

### Visual Mode
| Old Keymap | New Keymap | Description |
|------------|------------|-------------|
| `gc` | `<leader>cv` | Toggle comment on selection |
| `gb` | `<leader>cV` | Toggle block comment on selection |

**Rationale:**
- Uses `<leader>c` prefix (c = comment)
- Each command has distinct suffix (no `<leader>c` vs `<leader>cc` overlap)
- More intuitive and explicit
- No overlapping warnings
- No timing conflicts
- Disabled Comment.nvim default mappings completely

---

## 3. Which-Key Integration

All new keymaps are properly registered in which-key with descriptive labels:

- **Comment group** under `<leader>c`
- **Surround group** under `gz`

---

## Quick Reference Card

### Surround Examples

```vim
" Add parentheses around word
gzaiw)          " Old: ysiw)

" Add quotes around current line
gzl"            " Old: yss"

" Delete surrounding quotes
gzd"            " Old: ds"

" Replace parentheses with brackets
gzr)]           " Old: cs)]

" Add <div> tags with proper spacing (new lines)
gzAit<div>      " Old: ySit<div>

" In visual mode, surround selection with quotes
<select text>
gza"            " Old: S"

" In insert mode, surround word under cursor
<M-s>s"         " Old: <C-g>s"
```

### Comment Examples

```vim
" Toggle comment on current line
<leader>cc      " Old: gcc

" Comment 3 lines down
<leader>cm2j    " Old: gc2j

" Comment inside function
<leader>cmif    " Old: gcif

" Toggle block comment
<leader>cb      " Old: gbc

" Add comment below current line
<leader>co      " Old: gco

" Add comment at end of line
<leader>cA      " Old: gcA

" In visual mode, comment selection
<select lines>
<leader>cv      " Old: gc
```

---

## Migration Tips

1. **Surround Muscle Memory**: The `gz` prefix groups all surround operations:
   - `gza` = go **z**urround **a**dd
   - `gzl` = go **z**urround **l**ine
   - `gzd` = go **z**urround **d**elete
   - `gzr` = go **z**urround **r**eplace

2. **Comment Shortcuts**: `<leader>c` = "I want to comment"
   - `<leader>cc` = comment current line
   - `<leader>cm{motion}` = comment motion
   - `<leader>cv` = comment visual selection
   - `<leader>co` = comment below

3. **Practice**: Common operations you'll use daily:
   - `gzaiw)` - surround inner word with parentheses
   - `gzd"` - delete surrounding quotes
   - `gzr"'` - replace double quotes with single quotes
   - `gzl{` - surround current line with braces
   - `<leader>cc` - toggle line comment
   - `<leader>cmip` - comment inner paragraph

4. **Insert Mode**: Use `<M-s>s` (Alt-S followed by S) instead of Ctrl-based shortcuts

---

## Benefits

✅ **Zero which-key warnings**  
✅ **No conflicts with Vim's native commands**  
✅ **No conflicts with LSP keymaps**  
✅ **No timing/overlap issues**  
✅ **Consistent naming patterns**  
✅ **Better which-key integration**  
✅ **Easier to remember (grouped by prefix)**  

---

## Technical Details

### Why `gz` prefix?

1. **Consistent grouping**: All surround operations start with `gz`
2. **No overlap**: `gz` is rarely used in default Vim
3. **Mnemonic**: "Go Zurround" or "Go Surround"
4. **Two characters**: Eliminates timing conflicts (no `gza` vs `gzaa` overlap)

### Why `<leader>c` for comments?

1. **Mnemonic**: `c` = comment (simple and direct)
2. **Leader key**: Makes it explicit and conflict-free
3. **Discoverable**: Shows up in which-key popup
4. **Distinct keys**: Each command has unique suffix (cc, cm, cv, cb, etc.)
5. **No overlaps**: `<leader>c` is only a group, not an operator

### Why `<M-s>` in insert mode?

1. **Avoids `<C-s>` conflict**: LSP uses `<C-s>` for signature help
2. **Avoids `<C-g>` conflict**: Vim uses `<C-g>` for file info
3. **Meta/Alt key**: Rarely used, safe for custom mappings

---

## Rollback Instructions

If you want to revert to the original keymaps:

1. **In `lua/anvndev/plugins/misc/others.lua`:**
   ```lua
   config = true,  -- Remove the custom config function
   ```

2. **In `lua/anvndev/plugins/misc/comment.lua`:**
   Restore original values:
   ```lua
   mappings = {
       basic = true,  -- Change from false to true
       extra = true,
   },
   -- Remove all custom keymap setup
   ```

3. **In `lua/anvndev/core/which-key.lua`:**
   Remove the surround and comment sections from the spec

---

## Comparison Table

| Operation | Old | New | Conflicts Resolved |
|-----------|-----|-----|-------------------|
| Surround add | `ys` | `gza` | ✅ No `ys` vs `yss` overlap |
| Surround line | `yss` | `gzl` | ✅ Different key entirely |
| Surround delete | `ds` | `gzd` | ✅ Grouped with `gz` |
| Surround replace | `cs` | `gzr` | ✅ No conflict with `c` (change) |
| Comment line | `gcc` | `<leader>cc` | ✅ No `gc` vs `gcc` overlap |
| Comment motion | `gc` | `<leader>cm` | ✅ Distinct key suffix |
| Comment visual | `gc` (visual) | `<leader>cv` | ✅ Distinct key suffix |
| Insert surround | `<C-g>s` | `<M-s>s` | ✅ No LSP conflict |

---

## ⚙️ Important Technical Notes

**Comment.nvim Fix:** The plugin creates default `gc`/`gcc` mappings even when overridden in config. To completely eliminate warnings, we:

1. Set `mappings.basic = false` to disable ALL default mappings
2. Manually create custom keymaps using the Comment.nvim API
3. Use distinct key suffixes: `cc`, `cm`, `cv`, `cb`, `cB`, `cV`
4. Schedule `vim.keymap.del()` to remove any gc/gcc that sneak through
5. This prevents both `gc` vs `gcc` overlap AND `<leader>/` prefix overlap

**Why `<leader>c` not `<leader>/`:** Using `<leader>/` as a motion operator causes overlap with `<leader>//`, `<leader>/b`, etc. Using distinct suffixes eliminates this issue.

---

**Last Updated:** 2024  
**Status:** ✅ All conflicts resolved (0 warnings)  
**Version:** 3.0 (gz-based surround + leader-c comments with distinct keys)