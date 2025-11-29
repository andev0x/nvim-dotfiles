# Verification Checklist ✅

This document helps you verify that all keymap conflicts have been resolved.

---

## 🎯 Quick Verification

After restarting Neovim, run:

```vim
:checkhealth which-key
```

**Expected Result:**
```
checking for overlapping keymaps ~
- ✅ OK Overlapping keymaps are only reported for informational purposes.
```

**You should see:** `0 ⚠️` warnings

---

## 📋 Manual Testing Checklist

### Surround Operations (gz prefix)

Test these commands to ensure they work:

- [ ] `gzaiw)` - Add parentheses around word
- [ ] `gzl"` - Add quotes around current line  
- [ ] `gzd"` - Delete surrounding quotes
- [ ] `gzr"'` - Replace double quotes with single quotes
- [ ] Visual mode: Select text → `gza{` - Surround with braces
- [ ] Insert mode: `<M-s>s"` (Alt-s then s then ") - Surround word

**Test Text:**
```
hello world
"test string"
(parentheses)
```

**Expected behaviors:**
- `gzaiw)` on "hello" → `(hello)` world
- `gzd"` on "test string" → test string
- `gzr")]` on "(parentheses)" → [parentheses]

---

### Comment Operations (leader / prefix)

Test these commands:

- [ ] `<leader>//` - Toggle comment on current line
- [ ] `<leader>/2j` - Comment current line + 2 lines below
- [ ] `<leader>/ip` - Comment inside paragraph
- [ ] `<leader>/o` - Add comment below
- [ ] `<leader>/O` - Add comment above
- [ ] `<leader>/A` - Add comment at end of line
- [ ] Visual mode: Select lines → `<leader>/` - Comment selection

**Test Code:**
```javascript
function test() {
  const x = 1;
  const y = 2;
  return x + y;
}
```

**Expected behaviors:**
- `<leader>//` on line 2 → `// const x = 1;`
- `<leader>/ip` → All lines commented
- `<leader>/o` → New comment line below cursor

---

## 🔍 Conflict Verification

### Test 1: No `gc` vs `gcc` overlap

1. In normal mode, type `gc` (don't press Enter)
2. Wait for which-key popup (should appear after ~200ms)
3. **Should NOT show:** `gcc` as an option
4. **Should show:** Nothing (or timeout)

**If you see `gc` or `gcc`:** The conflict still exists! ❌

### Test 2: No `c` vs `cs` overlap

1. In normal mode, type `c`
2. Wait for which-key popup
3. **Should show:** Vim's native change commands only
4. **Should NOT show:** Any surround-related commands

**If you see `cs` or `cS`:** The conflict still exists! ❌

### Test 3: No `ys` vs `yss` overlap

1. In normal mode, type `ys`
2. Wait for which-key popup
3. **Should show:** Nothing (these keys don't exist anymore)

**If you see `ys` or `yss`:** Old config still active! ❌

### Test 4: No `<C-s>` conflict in insert mode

1. Enter insert mode
2. Press `<C-s>`
3. **Should trigger:** LSP signature help (if available)
4. **Should NOT trigger:** Surround operation

**If surround activates:** The conflict still exists! ❌

---

## 🎨 Which-Key Popup Verification

### Test: `gz` shows surround options

1. In normal mode, type `gz`
2. Wait for which-key popup
3. **Should show:**
   - `gza` - Add surrounding
   - `gzl` - Add surrounding (current line)
   - `gzA` - Add surrounding (new lines)
   - `gzL` - Add surrounding (current line, new lines)
   - `gzd` - Delete surrounding
   - `gzr` - Replace surrounding
   - `gzR` - Replace surrounding (new lines)

### Test: `<leader>/` shows comment options

1. In normal mode, type `<leader>/`
2. Wait for which-key popup
3. **Should show:**
   - `<leader>//` - Toggle comment line
   - `<leader>/b` - Toggle block comment
   - `<leader>/B` - Toggle block comment (operator)
   - `<leader>/O` - Comment above
   - `<leader>/o` - Comment below
   - `<leader>/A` - Comment at end of line

---

## 🐛 Troubleshooting

### If you still see warnings:

1. **Completely restart Neovim**
   ```bash
   # Close all Neovim instances
   killall nvim
   
   # Restart Neovim
   nvim
   ```

2. **Clear plugin cache**
   ```vim
   :Lazy clean
   :Lazy sync
   ```

3. **Check for conflicting configs**
   ```vim
   :verbose map gc
   :verbose map ys
   :verbose map cs
   ```
   
   These should show NO mappings or only `<leader>/` based ones.

4. **Verify files were updated**
   ```bash
   # Check surround config
   grep -n "gza" ~/.config/nvim/lua/anvndev/plugins/misc/others.lua
   
   # Check comment config  
   grep -n "mappings.*false" ~/.config/nvim/lua/anvndev/plugins/misc/comment.lua
   ```

---

## ✅ Success Criteria

You have successfully resolved all conflicts when:

- [ ] `:checkhealth which-key` shows `0 ⚠️`
- [ ] No `gc` vs `gcc` warning
- [ ] No `c` vs `cs` warning
- [ ] No `ys` vs `yss` warning
- [ ] No `<C-s>` vs `<C-s>s` warning
- [ ] `gz` prefix works for surround operations
- [ ] `<leader>/` prefix works for comments
- [ ] Which-key shows correct groups for `gz` and `<leader>/`
- [ ] All manual tests pass

---

## 📊 Before & After Comparison

### Before
```
checking for overlapping keymaps ~
- ⚠️ WARNING In mode `n`, <c> overlaps with <cS>, <cs>
- ⚠️ WARNING In mode `n`, <ys> overlaps with <yss>
- ⚠️ WARNING In mode `n`, <yS> overlaps with <ySS>
- ⚠️ WARNING In mode `n`, <gc> overlaps with <gcc>
- ⚠️ WARNING In mode `i`, <<C-G>> overlaps with <<C-G>S>, <<C-G>s>

Total: 5 ⚠️ warnings
```

### After (Expected)
```
checking for overlapping keymaps ~
- ✅ OK Overlapping keymaps are only reported for informational purposes.
  This doesn't necessarily mean there is a problem with your config.

Total: 0 ⚠️ warnings
```

---

## 🎓 Understanding the Fix

**Why these changes work:**

1. **`gz` prefix for surround** - Uses a two-character prefix that groups all operations together. No overlap between `gza` and `gzl` because they're completely different keys.

2. **`<leader>/` for comments** - Explicitly uses leader key, making it discoverable and conflict-free. `<leader>/` and `<leader>//` don't overlap because they're distinct sequences.

3. **Disabled default Comment.nvim mappings** - Set `mappings.basic = false` and manually created keymaps using the plugin's API, ensuring no `gc`/`gcc` are ever created.

4. **`<M-s>` for insert mode** - Uses Alt key instead of Ctrl to avoid LSP signature help conflict.

---

**Last Updated:** 2024  
**Status:** Ready for verification  
**Expected Result:** 0 warnings ✅