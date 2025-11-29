# Quick Reference Card - Optimized Keymaps

> **Zero Conflicts** | **Zero Warnings** | **Easy to Remember**

---

## 🎯 Surround Operations (gz prefix)

All surround operations start with **`gz`** (Go Zurround)

### Basic Operations

```vim
gza{motion}{char}    " Add surrounding around motion
gzl{char}            " Add surrounding around Line
gzd{char}            " Delete surrounding
gzr{old}{new}        " Replace surrounding
```

### Common Examples

```vim
gzaiw)               " Add () around inner word
gzaiw"               " Add "" around inner word
gzl'                 " Add '' around current line
gzd"                 " Delete surrounding ""
gzr"'                " Replace "" with ''
gzr)]                " Replace () with []
gzait<div>           " Add <div></div> around inner tag

" With new lines
gzAiw{               " Add {} around word with spacing
gzLt<section>        " Add <section> around line with new lines
```

### Visual Mode

```vim
<select text>
gza"                 " Surround selection with ""
gzA{                 " Surround with {} on new lines
```

### Insert Mode

```vim
<M-s>s"              " Alt-s s " - Surround word under cursor
<M-s>S{              " Alt-s S { - Surround with new lines
```

---

## 💬 Comment Operations (leader c prefix)

All comment operations start with **`<leader>c`** (c = comment)

### Basic Operations

```vim
<leader>cc           " Toggle comment on current line
<leader>cm{motion}   " Toggle comment on motion
<leader>cv           " Toggle comment on visual selection
<leader>cb           " Toggle block comment on current line
<leader>cB{motion}   " Toggle block comment on motion
<leader>cV           " Toggle block comment on visual selection
```

### Extra Operations

```vim
<leader>cO           " Add comment above current line
<leader>co           " Add comment below current line
<leader>cA           " Add comment at end of line
```

### Common Examples

```vim
<leader>cc           " Comment current line
<leader>cm3j         " Comment current + 3 lines down
<leader>cmip         " Comment inner paragraph
<leader>cmif         " Comment inner function
<leader>cmit         " Comment inner tag/block
<leader>co           " Add comment line below
```

### Visual Mode

```vim
<select lines>
<leader>cv           " Toggle comment on selection
<leader>cV           " Toggle block comment on selection
```

---

## 📋 Cheat Sheet

### Surround Mnemonics

| Key | Meaning | Example |
|-----|---------|---------|
| `gza` | Go Zurround Add | `gzaiw)` |
| `gzl` | Go Zurround Line | `gzl"` |
| `gzd` | Go Zurround Delete | `gzd'` |
| `gzr` | Go Zurround Replace | `gzr"'` |
| `gzA` | Add (new lines) | `gzAiw{` |
| `gzL` | Line (new lines) | `gzL<div>` |
| `gzR` | Replace (new lines) | `gzR)]` |

### Comment Mnemonics

| Key | Meaning |
|-----|---------|
| `<leader>cc` | Comment Current line |
| `<leader>cm` | Comment Motion |
| `<leader>cv` | Comment Visual selection |
| `<leader>cb` | Comment Block (line) |
| `<leader>cB` | Comment Block (motion) |
| `<leader>cV` | Comment Visual (block) |
| `<leader>co` | Comment below (lowercase o) |
| `<leader>cO` | Comment above (uppercase O) |
| `<leader>cA` | Comment at end (Append) |

---

## 🔄 Migration from Old Keymaps

| Old | New | Memory Aid |
|-----|-----|------------|
| `ysiw)` | `gzaiw)` | **gz**a = go zurround add |
| `yss"` | `gzl"` | **gz**l = go zurround line |
| `ds"` | `gzd"` | **gz**d = go zurround delete |
| `cs"'` | `gzr"'` | **gz**r = go zurround replace |
| `gcc` | `<leader>cc` | **c**omment **c**urrent line |
| `gc3j` | `<leader>cm3j` | **c**omment **m**otion |
| `gc` (visual) | `<leader>cv` | **c**omment **v**isual |
| `gco` | `<leader>co` | **c**omment bel**o**w |
| `<C-g>s"` | `<M-s>s"` | Alt-s instead of Ctrl-g |

---

## 💡 Pro Tips

1. **Surround workflow:**
   - `gza` for adding around motion
   - `gzl` for adding around line
   - `gzd` for deleting
   - `gzr` for replacing

2. **Comment workflow:**
   - `<leader>cc` for quick line toggle
   - `<leader>cm{motion}` for commenting blocks
   - `<leader>co` for adding comment lines
   - `<leader>cv` in visual mode

3. **Common patterns:**
   ```vim
   gzaiw"           " Quote word
   gzl{             " Wrap line in braces
   gzr'"`           " Change quotes ' to backticks
   gzd)             " Remove parentheses
   <leader>cmip     " Comment paragraph
   <leader>cc       " Comment line
   ```

4. **Visual mode shortcuts:**
   ```vim
   Select text then:
   gza"             " Wrap in quotes
   <leader>cv       " Comment selection
   ```

---

## 🎨 What Changed & Why

### ✅ Fixed Issues

1. **`c` conflict** - `cs` overlapped with Vim's `c` (change)
   - **Solution:** Use `gzr` (go zurround replace)

2. **`ys` overlap** - `ys` vs `yss` timing conflict
   - **Solution:** Use `gza` and `gzl` (different keys)

3. **`gc` overlap** - `gc` vs `gcc` timing conflict  
   - **Solution:** Use `<leader>cc` for line, `<leader>cm` for motion

4. **`<leader>/` overlap** - `<leader>/` overlapped with `<leader>//`, etc.
   - **Solution:** Use distinct keys: `<leader>cc`, `<leader>cm`, `<leader>cv`

5. **Insert mode conflict** - `<C-s>` used by LSP
   - **Solution:** Use `<M-s>` (Alt-s)

### 📊 Results

- **Before:** 5 warnings
- **After:** 0 warnings ✅
- **No conflicts** with Vim native commands ✅
- **No timing issues** between similar keymaps ✅
- **No overlapping prefixes** ✅

---

## 🚀 Most Useful Commands

### Daily Essentials

```vim
" Surround
gzaiw"               " Quote word
gzaiw)               " Parenthesize word
gzl{                 " Wrap line in braces
gzd"                 " Remove quotes
gzr"'                " Change quote type

" Comment
<leader>cc           " Toggle line comment
<leader>cmip         " Comment paragraph
<leader>cmif         " Comment function
<leader>co           " Add comment below

" In visual mode
gza"                 " Quote selection
<leader>cv           " Comment selection
```

---

## 📖 Keymap Philosophy

### Surround: `gz` prefix
- **Mnemonic:** "Go Zurround" or "Go Surround"
- **Pattern:** `gz` + action + motion
- **Examples:** `gza` (add), `gzd` (delete), `gzr` (replace)

### Comment: `<leader>c` prefix
- **Mnemonic:** "Comment"
- **Pattern:** `<leader>c` + target
- **Examples:** `cc` (current), `cm` (motion), `cv` (visual)
- **No overlaps:** Each command has distinct suffix

---

## 🎯 Command Breakdown

### Comment Commands Explained

```vim
<leader>cc    " c + c = Comment Current line
<leader>cm    " c + m = Comment Motion (waits for motion like ip, if, 3j)
<leader>cv    " c + v = Comment Visual selection (use in visual mode)
<leader>cb    " c + b = Comment Block (current line, block style)
<leader>cB    " c + B = Comment Block Motion (waits for motion)
<leader>cV    " c + V = Comment Visual block (visual mode, block style)
<leader>co    " c + o = Comment below (insert new comment line)
<leader>cO    " c + O = Comment above (insert new comment line)
<leader>cA    " c + A = Comment Append (at end of line)
```

### Surround Commands Explained

```vim
gza{motion}   " Go Zurround Add (around motion)
gzl           " Go Zurround Line (current line)
gzA{motion}   " Go Zurround Add with new lines
gzL           " Go Zurround Line with new lines
gzd           " Go Zurround Delete
gzr           " Go Zurround Replace
gzR           " Go Zurround Replace with new lines
```

---

**Print this page for desk reference!**

Last Updated: 2024 | Version 3.0 (Zero overlaps)