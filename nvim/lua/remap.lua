-- ═══════════════════════════════════════════════════════════════
-- 🌸 Sakura Night - Keymaps (mirrors tmux with Leader)
-- ═══════════════════════════════════════════════════════════════

local map = vim.keymap.set

-- ── General ──────────────────────────────────────────────────
map("i", "jk", "<Esc>", { desc = "Exit insert mode" })
map("n", "<Esc>", ":nohlsearch<CR>", { silent = true })

-- ── Splits (like tmux) ───────────────────────────────────────
map("n", "<leader>E", ":vsplit<CR>", { desc = "Split vertical" })
map("n", "<leader>W", ":split<CR>", { desc = "Split horizontal" })
map("n", "<leader>x", ":close<CR>", { desc = "Close split" })

-- ── Window navigation (like tmux h/j/k/l) ────────────────────
map("n", "<leader>h", "<C-w>h", { desc = "Move left" })
map("n", "<leader>j", "<C-w>j", { desc = "Move down" })
map("n", "<leader>k", "<C-w>k", { desc = "Move up" })
map("n", "<leader>l", "<C-w>l", { desc = "Move right" })

-- ── Window resize (like tmux H/J/K/L) ────────────────────────
map("n", "<leader>H", ":vertical resize -5<CR>", { desc = "Resize left", silent = true })
map("n", "<leader>J", ":resize -5<CR>", { desc = "Resize down", silent = true })
map("n", "<leader>K", ":resize +5<CR>", { desc = "Resize up", silent = true })
map("n", "<leader>L", ":vertical resize +5<CR>", { desc = "Resize right", silent = true })

-- ── Tabs (like tmux windows) ─────────────────────────────────
map("n", "<leader>c", ":tabnew<CR>", { desc = "New tab" })
map("n", "<leader>t", ":tabnext<CR>", { desc = "Next tab" })
map("n", "<leader>T", ":tabprev<CR>", { desc = "Previous tab" })
map("n", "<leader>1", "1gt", { desc = "Tab 1" })
map("n", "<leader>2", "2gt", { desc = "Tab 2" })
map("n", "<leader>3", "3gt", { desc = "Tab 3" })
map("n", "<leader>4", "4gt", { desc = "Tab 4" })
map("n", "<leader>5", "5gt", { desc = "Tab 5" })

-- Rename tab
map("n", "<leader>,", function()
    vim.ui.input({ prompt = "Tab name: " }, function(name)
        if name and name ~= "" then
            vim.cmd("TabRename " .. name)
        end
    end)
end, { desc = "Rename tab" })

-- ── Save & Quit ──────────────────────────────────────────────
map("n", "<leader>s", ":w<CR>", { desc = "Save" })
map("n", "<leader>q", ":q<CR>", { desc = "Quit" })
map("n", "<leader>Q", ":qa!<CR>", { desc = "Quit all" })

-- ── Move lines/blocks ───────────────────────────────────────
-- Visual mode: move selected lines up/down
map("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
map("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })

-- Normal mode: move current line up/down with Alt+j/k
map("n", "<A-j>", ":m .+1<CR>==", { desc = "Move line down" })
map("n", "<A-k>", ":m .-2<CR>==", { desc = "Move line up" })

-- Visual mode: alternative with Alt+j/k
map("v", "<A-j>", ":m '>+1<CR>gv=gv", { desc = "Move block down" })
map("v", "<A-k>", ":m '<-2<CR>gv=gv", { desc = "Move block up" })

-- ── Better indenting ─────────────────────────────────────────
-- Stay in visual mode after indenting
map("v", "<", "<gv", { desc = "Indent left" })
map("v", ">", ">gv", { desc = "Indent right" })

-- ── Duplicate lines/blocks ───────────────────────────────────
map("n", "<leader>d", "yyp", { desc = "Duplicate line" })
map("v", "<leader>d", "y`>p", { desc = "Duplicate selection" })

-- ── Quick selections ──────────────────────────────────────────
-- Select entire line (without newline)
map("n", "vv", "^v$h", { desc = "Select line content" })

-- Select entire buffer
map("n", "<leader>a", "ggVG", { desc = "Select all" })

-- Expand selection incrementally (like VSCode Ctrl+D)
map("v", "v", "<Plug>(expand_region_expand)", { desc = "Expand selection" })
map("v", "<C-v>", "<Plug>(expand_region_shrink)", { desc = "Shrink selection" })

