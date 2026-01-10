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

-- ── Move lines ───────────────────────────────────────────────
map("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move line down" })
map("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move line up" })

-- ── Better indenting ─────────────────────────────────────────
map("v", "<", "<gv")
map("v", ">", ">gv")

