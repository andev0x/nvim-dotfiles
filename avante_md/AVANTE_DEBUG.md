# Avante Debugging & Troubleshooting Guide

## Quick Diagnostics

Run these commands to diagnose Avante issues:

### 1. Check Avante Status
```vim
:AvanteStatus
```
Shows the safety guide and all keymaps.

### 2. Check Plugin Health
```vim
:checkhealth copilot
:checkhealth avante
```
Displays Copilot and Avante status.

### 3. See Loaded Plugins
```vim
:Lazy show avante
:Lazy show copilot
```
Verify plugins are loaded.

### 4. View Messages
```vim
:messages
```
Check for error messages or warnings.

---

## Common Issues & Fixes

### Issue 1: Avante Sidebar Won't Open

**Symptoms**: Pressing `<leader>av` does nothing

**Diagnosis**:
```vim
:Lazy show avante          " Check if loaded
:Lazy sync                 " Update plugins
:checkhealth copilot       " Check Copilot
```

**Solutions**:
1. Update all plugins:
   ```vim
   :Lazy sync
   :Lazy reload avante
   ```

2. Restart Neovim completely:
   ```bash
   # Exit with :qa
   # Re-enter nvim
   nvim
   ```

3. Check if Copilot is authenticated:
   ```vim
   :Copilot auth
   ```

---

### Issue 2: Diff View Not Showing

**Symptoms**: No side-by-side comparison visible

**Diagnosis**:
```vim
<leader>ad                 " Try toggling diff
:AvanteShowDiff           " Explicit command
```

**Solutions**:
1. Toggle diff view:
   ```vim
   <leader>ad
   ```

2. Check if diffview plugin is installed:
   ```vim
   :Lazy show diffview
   ```

3. Check window layout:
   ```vim
   :Avante                " Close and reopen
   ```

---

### Issue 3: Code Auto-Applied (Shouldn't Happen)

**Symptoms**: Changes applied without pressing `<leader>aa`

**Emergency Response**:
```vim
Ctrl-Z                    " UNDO IMMEDIATELY
:AvanteStatus            " Review keymaps
```

**Diagnosis**:
```vim
:edit ~/.config/nvim/lua/anvndev/plugins/misc/avante.lua
" Check for auto_suggestions = false
" Check for auto_apply_suggestion_to_current_buffer = false
```

**Fix**:
1. Verify these settings in avante.lua:
   ```lua
   auto_suggestions = false,
   auto_apply_suggestion_to_current_buffer = false,
   ```

2. Reload the configuration:
   ```vim
   :Lazy reload avante
   ```

---

### Issue 4: Copilot Authentication Failed

**Symptoms**: "Not authenticated" error message

**Diagnosis**:
```vim
:Copilot status
```

**Solution**:
1. Start authentication:
   ```vim
   :Copilot auth
   ```

2. Follow the prompts:
   - A device code will appear
   - Go to https://github.com/login/device
   - Enter the device code
   - Authorize Neovim
   - Return to Neovim

3. Restart Neovim after authentication completes

---

### Issue 5: Avante Responses Are Slow

**Symptoms**: Takes 10+ seconds for suggestions

**Diagnosis**:
- Check internet connection
- GitHub Copilot service might be busy
- Your network might have latency

**Solutions**:
1. Check internet connection:
   ```bash
   ping github.com
   ```

2. Wait and retry:
   ```vim
   <leader>af              " Refresh suggestion
   ```

3. Try a simpler request

4. Check Copilot status:
   ```vim
   :Copilot status
   ```

---

### Issue 6: Keymaps Not Working

**Symptoms**: `<leader>aa`, `<leader>ar`, etc. do nothing

**Diagnosis**:
```vim
:Telescope keymaps search=avante
" Or check mapping status
:nmap <leader>aa
:nmap <leader>ar
```

**Solutions**:
1. Verify keymaps are set:
   ```vim
   :nmap <leader>aa
   " Should show Avante: Accept suggestion
   ```

2. Check for conflicts:
   ```vim
   :nmap <leader>a*
   " View all <leader>a keymaps
   ```

3. Reload keymaps:
   ```vim
   :Lazy reload avante
   :source ~/.config/nvim/lua/anvndev/core/keymaps.lua
   ```

---

### Issue 7: Avante Crashes or Freezes

**Symptoms**: Neovim becomes unresponsive

**Emergency Recovery**:
```bash
# Force quit Neovim
pkill -9 nvim

# Restart
nvim
```

**Diagnosis & Fix**:
1. Disable Avante temporarily:
   ```vim
   :Lazy unload avante
   ```

2. Restart Neovim

3. Check for plugin conflicts:
   ```vim
   :Lazy show
   " Look for plugins with warnings
   ```

4. Update all plugins:
   ```vim
   :Lazy sync
   ```

---

### Issue 8: "Provider not configured" Error

**Symptoms**: Avante shows error about missing provider

**Diagnosis**:
```vim
:messages
" Look for provider-related errors
```

**Solutions**:
1. Verify Copilot is installed:
   ```vim
   :Lazy show copilot
   ```

2. Force update Copilot:
   ```vim
   :Lazy sync
   :Lazy reload copilot
   ```

3. Re-authenticate:
   ```vim
   :Copilot auth
   ```

---

## Advanced Debugging

### Enable Verbose Logging

```vim
" Increase verbosity
:set verbose=9

" Run Avante
<leader>av

" Check messages
:messages

" Reset verbosity
:set verbose=0
```

### Check Configuration Syntax

```bash
# Validate Lua syntax
cd ~/.config/nvim
luacheck lua/anvndev/plugins/misc/avante.lua
```

### View Loaded Configuration

```vim
" Show Avante config
:lua print(vim.inspect(require("avante.config")))

" Show Copilot config
:lua print(vim.inspect(require("copilot").config))
```

### Debug Key Presses

```vim
" Show what key sequence is being sent
:verbose nmap <leader>aa
```

---

## Performance Optimization

### Profile Neovim Startup

```bash
# Check startup time
nvim --startuptime startup.log

# View results
cat startup.log | sort -k2 -nr | head -20
```

### Reduce Context Size

Large files slow down Avante. Keep selections focused:

```vim
" Instead of selecting entire file
v
G
" Select just the function you need
v
5j
" Then ask Avante
<leader>av
```

### Disable Unnecessary Features

```vim
" In avante.lua, set:
behaviour = {
  auto_set_keymaps = true,
  auto_suggestions = false,      -- Already disabled
  minimize_diff = true,           -- Reduce visual overhead
}
```

---

## Network Issues

### Test GitHub Copilot API

```bash
# Check if GitHub is reachable
curl -I https://api.github.com

# Check Copilot service status
curl -I https://copilot-api.github.com
```

### Firewall/Proxy Issues

If behind a corporate firewall:

1. Check proxy settings:
   ```bash
   echo $HTTP_PROXY
   echo $HTTPS_PROXY
   ```

2. Configure Git proxy (Copilot uses Git):
   ```bash
   git config --global https.proxy [proxy-url]
   ```

3. Test connection:
   ```bash
   git ls-remote https://github.com/yetone/avante.nvim.git
   ```

---

## Plugin Conflicts

### Identify Conflicting Plugins

```vim
" Temporarily disable plugins one by one
:Lazy unload copilot
" Test Avante
<leader>av

" If it works, copilot was conflicting
" Then re-enable:
:Lazy load copilot
```

### Common Conflicts

**With copilot.vim** (old Copilot plugin):
- Use `copilot.lua` (newer, faster)
- Remove copilot.vim if installed

**With cmp** (autocomplete):
- Avante may interfere with completion
- Check cmp keymaps don't conflict:
  ```vim
  :imap <Tab>
  ```

**With other AI plugins**:
- Don't run multiple AI plugins simultaneously
- Pick one: Avante, Codeium, or ChatGPT

---

## Recovery Procedures

### Full Reset

If everything is broken:

```bash
# Backup current config
cp -r ~/.config/nvim ~/.config/nvim.backup

# Clear plugin cache
rm -rf ~/.local/share/nvim/lazy

# Restart Neovim (will reinstall plugins)
nvim

# In Neovim:
:Lazy sync
:Copilot auth
```

### Restore from Backup

```bash
# If reset didn't work
rm -rf ~/.local/share/nvim
cp -r ~/.config/nvim.backup ~/.config/nvim
nvim
```

### Manual Plugin Installation

If Lazy.nvim is broken:

```bash
# Install lazy.nvim manually
mkdir -p ~/.local/share/nvim/site/pack/packer/start
cd ~/.local/share/nvim/site/pack/packer/start
git clone https://github.com/folke/lazy.nvim.git
```

---

## Verification Checklist

Use this checklist to verify everything is working:

- [ ] Neovim starts without errors
- [ ] `:AvanteStatus` displays help
- [ ] `:Copilot status` shows authenticated
- [ ] `:Lazy show avante` shows "loaded"
- [ ] `:Lazy show copilot` shows "loaded"
- [ ] `<leader>av` opens Avante sidebar
- [ ] Diff view appears on the right
- [ ] `<leader>aa` accepts suggestions
- [ ] `<leader>ar` rejects suggestions
- [ ] `<leader>ad` toggles diff
- [ ] Changes require manual approval (not auto-applied)

If all checkmarks pass ✓, Avante is properly configured!

---

## Getting Help

### Useful Information to Share

When reporting issues, include:

1. **Neovim version**:
   ```bash
   nvim --version
   ```

2. **Avante version**:
   ```vim
   :Lazy show avante
   ```

3. **Error messages**:
   ```vim
   :messages
   ```

4. **Your config**:
   ```
   ~/.config/nvim/lua/anvndev/plugins/misc/avante.lua
   ```

5. **Full startup log**:
   ```bash
   nvim --startuptime log.txt
   cat log.txt
   ```

### Support Resources

- **Avante Issues**: https://github.com/yetone/avante.nvim/issues
- **Copilot Issues**: https://github.com/github/copilot.vim/issues
- **Neovim Help**: `:help lua-guide`
- **Copilot Auth Help**: https://github.com/github/copilot.vim#authentication

---

## Quick Reference Commands

```vim
" Safety & Status
:AvanteStatus              Show help and keymaps
:AvanteCreateBackup        Create timestamped backup

" Diagnostics
:checkhealth copilot       Check Copilot health
:checkhealth avante        Check Avante health
:messages                  View all messages
:Lazy show avante          Check plugin status
:Lazy show copilot         Check plugin status

" Control
:Avante                    Toggle Avante sidebar
:AvanteRefresh             Restart Avante
:Copilot auth              Authenticate with GitHub

" Debug
:set verbose=9             Enable verbose logging
:nmap <leader>aa           Show keymap details
:lua print(vim.inspect(...)) Inspect configuration
```

---

## Emergency Contact

If you get stuck:

1. Run `:AvanteStatus` for quick help
2. Check this file for your specific issue
3. Visit GitHub issues with error output
4. Use `:checkhealth` commands to gather diagnostics

**Remember**: Always use `Ctrl-Z` to undo if something goes wrong!

---

**Last Updated**: 2024
**Version**: 1.0
**Status**: Quick Reference Guide
