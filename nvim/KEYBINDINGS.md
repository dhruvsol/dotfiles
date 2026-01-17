# Neovim Keybindings Reference

## General Leader Key
- Leader key: `<Space>`

## Moving Code Blocks

### In Visual Mode (select text first with `v` or `V`)
- `J` - Move selected lines down
- `K` - Move selected lines up
- `Alt+j` - Move block down (alternative)
- `Alt+k` - Move block up (alternative)

### In Normal Mode
- `Alt+j` - Move current line down
- `Alt+k` - Move current line up

### Indenting Code
- `>` (visual mode) - Indent right (stays in visual mode)
- `<` (visual mode) - Indent left (stays in visual mode)
- `>>` (normal mode) - Indent current line right
- `<<` (normal mode) - Indent current line left

### Duplicating Code
- `<leader>d` (normal mode) - Duplicate current line
- `<leader>d` (visual mode) - Duplicate selected block

## Smart Selection & Text Objects

### Quick Selections
- `vv` (normal mode) - Select entire line content (without newline)
- `<leader>a` - Select entire buffer
- `s` - Flash jump to any word/location (type the character(s) to jump)
- `S` - Flash select by treesitter node (functions, blocks, etc.)

### Built-in Text Objects (use with `v`, `d`, `c`, `y`)
- `iw` / `aw` - Inside/around word
- `i"` / `a"` - Inside/around double quotes
- `i'` / `a'` - Inside/around single quotes
- `i(` / `a(` - Inside/around parentheses
- `i{` / `a{` - Inside/around braces
- `i[` / `a[` - Inside/around brackets
- `it` / `at` - Inside/around HTML/XML tags
- `ip` / `ap` - Inside/around paragraph
- `ie` - Entire buffer (custom)

### Surround Operations (mini.surround)
- `sa` + motion + char - Add surrounding (e.g., `saiw"` adds quotes around word)
- `sd` + char - Delete surrounding (e.g., `sd"` removes quotes)
- `sr` + old + new - Replace surrounding (e.g., `sr"'` changes " to ')
- `sh` + char - Highlight surrounding

### Examples
- `vi"` - Select inside quotes
- `va{` - Select including braces
- `saiw)` - Surround word with parentheses
- `sd"` - Delete surrounding quotes
- `sr"'` - Change double quotes to single quotes
- `s` then type `word` - Jump to "word" anywhere on screen

## LSP (Language Server) - All Languages

### Navigation
- `gd` - Go to definition
- `gD` - Go to declaration
- `gr` - Go to references
- `gi` - Go to implementation
- `<leader>D` - Type definition
- `<leader>ds` - Document symbols

### Code Actions
- `<leader>ca` - Code action (with preview)
- `<leader>rn` - Rename symbol
- `K` - Hover documentation

### Diagnostics
- `[d` - Previous diagnostic
- `]d` - Next diagnostic
- `<leader>d` - Show diagnostic float
- `<leader>xx` - Toggle all diagnostics (Trouble)
- `<leader>xd` - Buffer diagnostics (Trouble)
- `<leader>xl` - LSP references panel (Trouble)

### Inlay Hints
- `<leader>th` - Toggle inlay hints

## Rust-Specific Keybindings

### Cargo & Running
- `<leader>rr` - Rust runnables (run main, examples, etc.)
- `<leader>rt` - Rust testables (run tests)
- `<leader>rd` - Rust debuggables (debug targets)
- `<leader>rc` - Open Cargo.toml

### Code Navigation & Refactoring
- `<leader>rp` - Go to parent module
- `<leader>re` - Expand macro under cursor
- `<leader>rj` - Join lines (smart Rust joining)
- `K` - Hover actions (enhanced for Rust with quick actions)

### Cargo.toml (crates.nvim)
When in Cargo.toml:
- Hover over crate name to see info
- Code actions available for updating dependencies

## File Navigation (Telescope)
- `<leader>ff` - Find files
- `<leader>fg` - Live grep (search in files)
- `<leader>fb` - Buffers
- `<leader>fh` - Help tags
- `<leader>fr` - Recent files

## File Explorer
- `<leader>e` - Toggle file explorer (nvim-tree)

## Comments
- `gcc` - Comment/uncomment line (normal mode)
- `gc` - Comment/uncomment selection (visual mode)

## Completion (Insert Mode)
- `<C-Space>` - Trigger completion
- `<CR>` - Confirm completion
- `<Tab>` - Next item / expand snippet
- `<S-Tab>` - Previous item / jump back in snippet
- `<C-b>` - Scroll docs up
- `<C-f>` - Scroll docs down
- `<C-e>` - Abort completion

## Rust Features Enabled
- ✓ Clippy on save with all warnings
- ✓ All cargo features enabled
- ✓ Comprehensive inlay hints (types, lifetimes, parameters, etc.)
- ✓ Auto-complete function parameters
- ✓ Postfix completions
- ✓ Auto-imports
- ✓ Proc macro support

## TypeScript Features Enabled
- ✓ Comprehensive inlay hints
- ✓ Auto-complete function calls with parameters
- ✓ Relative import paths
- ✓ TypeScript-specific code actions
- ✓ Organize imports, fix all, etc.

## Tips
1. Use `<leader>ca` for quick fixes and refactorings
2. Use `<leader>xx` to see all errors/warnings in your project
3. In Rust, `K` on a symbol shows quick actions like "View HIR", "View MIR", etc.
4. Use `<leader>rt` to quickly run tests under cursor
5. Toggle inlay hints with `<leader>th` if they feel cluttered
