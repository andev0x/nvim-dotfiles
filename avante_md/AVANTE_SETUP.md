# Avante Neovim Setup & Usage Guide

## Overview

Avante is an AI-powered code assistant integrated into Neovim that helps you:
- Generate code suggestions
- Refactor existing code
- Write tests and documentation
- Debug problems
- Learn and improve your coding

**IMPORTANT**: This setup prioritizes **safety and control**. Code changes require your explicit approval before being applied.

---

## Installation & Setup

### Prerequisites

1. **Neovim** (v0.9+)
   ```bash
   nvim --version
   ```

2. **GitHub Copilot** (recommended AI provider)
   - Sign up at https://github.com/copilot
   - Authenticate in Neovim: `:Copilot auth`

3. **Dependencies** (installed automatically via lazy.nvim)
   - nvim-treesitter
   - plenary.nvim
   - nui.nvim
   - dressing.nvim
   - render-markdown.nvim

### Quick Start

1. **Start Neovim**
   ```bash
   nvim
   ```

2. **Verify Avante loaded**
   ```vim
   :AvanteStatus
   ```
   You should see the safety guide with keymaps.

3. **Test it**
   ```vim
   <leader>av  " Ask Avante a question
   ```

---

## Keymaps (Quick Reference)

| Keymap | Action | Description |
|--------|--------|-------------|
| `<leader>av` | Ask | Open Avante and ask a question |
| `<leader>aa` | Accept | **APPROVE** the suggestion and apply changes |
| `<leader>ar` | Reject | **DISCARD** the suggestion |
| `<leader>af` | Refresh | Regenerate the suggestion (try again) |
| `<leader>ad` | Diff | Toggle diff view on/off |
| `<leader>ae` | Edit | Modify your question/prompt |

---

## Typical Workflow

### Scenario 1: Refactor a Function

**Goal**: Improve the `calculateTotal()` function

**Steps**:

1. Open the file with the function
   ```vim
   :e src/math.js
   ```

2. Select or position cursor on the function
   ```vim
   " Click on the function or use motion to select it
   ```

3. Ask Avante to refactor it
   ```vim
   <leader>av
   " Type: "Refactor this function to be more efficient and add error handling"
   ```

4. **WAIT** - Avante processes your request (takes 3-5 seconds)

5. **REVIEW** - Look at the right sidebar showing the diff
   - Green highlights = code being added
   - Red highlights = code being removed
   - Check the logic carefully

6. **APPROVE** or **REJECT**
   ```vim
   <leader>aa  " YES, apply these changes
   <leader>ar  " NO, discard these changes
   ```

7. **VERIFY** - Test the changes
   ```bash
   npm test     # Run your tests
   npm run dev  # Run the code
   ```

8. **COMMIT** - If satisfied
   ```bash
   git add src/math.js
   git commit -m "Refactor: Improve calculateTotal() efficiency"
   ```

---

### Scenario 2: Add Tests

**Goal**: Write unit tests for a function

**Steps**:

1. Position cursor on the function to test

2. Ask Avante
   ```vim
   <leader>av
   " Type: "Write comprehensive unit tests for this function"
   ```

3. Review the generated test code in the diff view

4. Accept or reject
   ```vim
   <leader>aa  " Accept the tests
   ```

5. The tests are inserted into your test file

6. Run the tests to verify they work
   ```bash
   npm test
   ```

---

### Scenario 3: Debug an Error

**Goal**: Fix a bug in your code

**Steps**:

1. Copy the error message and relevant code

2. Ask Avante
   ```vim
   <leader>av
   " Paste: Error message and code snippet
   " Type: "What's wrong with this code? How do I fix it?"
   ```

3. Review Avante's analysis

4. If the fix looks good, accept it
   ```vim
   <leader>aa
   ```

5. Test to confirm the bug is fixed

---

## Understanding Diffs

The diff view (right sidebar) shows:

```
BEFORE (Current Code):          AFTER (Avante's Suggestion):
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

function add(a, b) {     ▶︎      function add(a, b) {
  return a + b;         ▶︎        // Add type validation
}                        ▶︎        if (typeof a !== 'number' || 
                         ▶︎            typeof b !== 'number') {
                         ▶︎          throw new Error('Invalid input');
                         ▶︎        }
                         ▶︎        return a + b;
                         ▶︎      }

Red = Removed            Green = Added
```

**Always review the diff carefully** before accepting!

---

## Safety Features

This Avante setup includes multiple safety layers:

### 1. Explicit Approval Required
- Code changes **NEVER** happen automatically
- You must press `<leader>aa` to apply changes
- Use `<leader>ar` to reject changes

### 2. Diff View Always Visible
- Compare before/after side-by-side
- Spot mistakes before they happen
- Review line-by-line changes

### 3. Undo is Always Available
```vim
Ctrl-Z          " Undo the last change
Ctrl-Shift-Z    " Redo if you undo too much
```

### 4. Backup Command
Before accepting a large change, create a backup:
```vim
:AvanteCreateBackup
```
This creates a timestamped backup of your file.

### 5. Version Control
Always use git to track your changes:
```bash
git add .
git commit -m "My changes"
git diff HEAD~1          # Review what changed
```

---

## Best Practices

### ✓ DO These Things

- **Be specific** - "Add TypeScript types and error handling" (good) vs "Fix it" (bad)
- **Provide context** - Include related code or error messages
- **Review diffs carefully** - Never blindly accept suggestions
- **Test after changes** - Run tests to verify correctness
- **Use git** - Commit frequently so you can revert if needed
- **Ask follow-up questions** - Refine suggestions until they're perfect
- **Read explanations** - Understand WHY Avante suggested each change

### ✗ DON'T Do These Things

- ✗ Accept suggestions without reviewing the diff
- ✗ Make multiple major changes without committing
- ✗ Trust Avante 100% - always verify code works
- ✗ Ask vague questions - "Make it better" is unclear
- ✗ Ignore error messages - they contain important context
- ✗ Apply Avante changes to production without testing
- ✗ Give Avante access to sensitive code/secrets

---

## Troubleshooting

### Problem: Avante sidebar doesn't appear

**Solution**:
```vim
<leader>av          " This should open the sidebar
" or try:
:Avante
```

If it still doesn't work, restart Neovim:
```bash
# Exit Neovim
:qa
# Restart
nvim
```

---

### Problem: Diff view is not showing

**Solution**:
```vim
<leader>ad          " Toggle diff view on
" or
:AvanteShowDiff
```

---

### Problem: "Code was applied but I didn't approve it"

**Solution** (IMMEDIATELY):
```vim
Ctrl-Z              " Undo the change
```

Then report this issue. This shouldn't happen with proper configuration.

---

### Problem: Avante suggestions look wrong

**Solution**:
1. Press `<leader>ar` to reject the suggestion
2. Press `<leader>ae` to edit your prompt with more specific instructions
3. Ask Avante to try again with better guidelines
4. Example: "Use snake_case for variables, add JSDoc comments, follow the existing code style"

---

### Problem: Avante is very slow

**Solution**:
- Check your internet connection (Copilot needs API access)
- Try again - the AI service might be busy
- Consider using a different provider (Claude, OpenAI, etc.)

---

### Problem: "Copilot authentication failed"

**Solution**:
```vim
:Copilot auth       " Re-authenticate with GitHub
" Follow the prompts
" Restart Neovim after
```

---

## Advanced Usage

### Using Avante for Code Review

Paste another person's code and ask Avante to review it:
```vim
<leader>av
" Type: "Please review this code for:
" 1. Performance issues
" 2. Security vulnerabilities
" 3. Code style improvements
" 4. Missing error handling"
```

---

### Refactoring Large Functions

For complex functions, break the refactoring into steps:

**Step 1**: Extract helper functions
```vim
<leader>av
" Type: "Extract 'validation' and 'calculation' into separate functions"
```

**Step 2**: Add types/documentation
```vim
<leader>av
" Type: "Add TypeScript types and JSDoc comments to this function"
```

**Step 3**: Add tests
```vim
<leader>av
" Type: "Write unit tests covering edge cases"
```

---

### Context-Aware Questions

Select code first, then ask Avante:
```vim
" Visually select code in V mode
v
j j j          " Select multiple lines

" Then ask
<leader>av
" Type: "How can I optimize this code?"
```

Avante uses the selected code as context.

---

## Commands Reference

```vim
" Safety & Help
:AvanteStatus         " Show safety guide and keymaps
:AvanteCreateBackup   " Create timestamped backup of current file

" Avante Control
:Avante              " Open/close Avante sidebar
:AvanteRefresh       " Refresh Avante (if stuck)
:AvanteToggle        " Show/hide sidebar
:AvanteShowDiff      " Explicitly show diff view

" Copilot Management
:Copilot auth        " Authenticate with GitHub Copilot
:Copilot status      " Check Copilot status
```

---

## Configuration

Your Avante configuration is in:
```
~/.config/nvim/lua/anvndev/plugins/misc/avante.lua
```

Key settings:
- `auto_suggestions = false` - No auto-apply (safety)
- `diff_view.enabled = true` - Always show diff
- `provider = "copilot"` - Using GitHub Copilot as AI

To change providers (Claude, OpenAI, etc.), edit this file and restart Neovim.

---

## Getting Help

1. **Quick reminder of keymaps**
   ```vim
   :AvanteStatus
   ```

2. **Check Avante documentation**
   - GitHub: https://github.com/yetone/avante.nvim
   - Issues: https://github.com/yetone/avante.nvim/issues

3. **Check Copilot status**
   ```vim
   :Copilot status
   ```

4. **See all keymaps in Neovim**
   ```vim
   :Telescope keymaps
   " Then search for 'Avante' or 'avante'
   ```

---

## Example: Complete Workflow

Let's say you want to refactor `src/utils.js`:

```bash
# 1. Open the file
nvim src/utils.js

# 2. In Neovim, position your cursor on the function
# (or visually select it in visual mode)

# 3. Ask Avante
<leader>av

# 4. Type your request
"Refactor this function to:
 - Use modern async/await syntax
 - Add proper TypeScript types
 - Include error handling
 - Add JSDoc comments"

# 5. WAIT for Avante to process

# 6. REVIEW the diff on the right side
# - Check the logic
# - Verify it matches your request
# - Look for any issues

# 7. ACCEPT if it looks good
<leader>aa

# 8. Test the changes
<esc>
:!npm test

# 9. Commit your work
:!git add src/utils.js
:!git commit -m "Refactor: Modernize utils.js with async/await and types"

# Done!
```

---

## Performance Tips

1. **Use specific requests** - Vague requests take longer
2. **Provide context** - Include related code snippets
3. **Test incrementally** - Make small changes, test, then commit
4. **Close unused files** - Reduces context for Avante to process
5. **Use sections** - Work on one function at a time

---

## Privacy & Security

- Avante sends your code to GitHub Copilot's servers
- Don't use Avante for sensitive/confidential code
- Check Copilot's privacy policy: https://github.com/features/copilot/privacy
- Consider using local LLMs (Ollama) for private code

---

## FAQ

**Q: Will Avante delete my code without permission?**  
A: No. Changes require explicit approval with `<leader>aa`.

**Q: Can I undo Avante changes?**  
A: Yes, press `Ctrl-Z` to undo immediately.

**Q: What if I disagree with Avante's suggestion?**  
A: Press `<leader>ar` to reject it, or `<leader>ae` to refine your request.

**Q: Is Avante free?**  
A: GitHub Copilot is paid (~$10-20/month). Some free alternatives exist.

**Q: How do I turn off Avante?**  
A: In your Neovim config, set `lazy = true` in avante.lua and restart.

**Q: Can I use a different AI provider?**  
A: Yes, edit `~/.config/nvim/lua/anvndev/plugins/misc/avante.lua` and change the `provider` option.

---

## Support & Issues

- **Bug reports**: https://github.com/yetone/avante.nvim/issues
- **Feature requests**: https://github.com/yetone/avante.nvim/discussions
- **Copilot issues**: https://github.com/github-copilot/discussions

---

## Summary

| Aspect | Status |
|--------|--------|
| **Auto-apply** | ✓ DISABLED (safe) |
| **Diff view** | ✓ ENABLED (always visible) |
| **Approval required** | ✓ YES (manual control) |
| **Undo support** | ✓ YES (Ctrl-Z) |
| **Version control friendly** | ✓ YES (git compatible) |
| **Workflow** | ✓ OPTIMIZED for safety |

---

**Last Updated**: 2024  
**Configuration Version**: 1.0  
**Status**: ✓ Production Ready with Safety Enabled