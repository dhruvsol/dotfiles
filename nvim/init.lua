-- ═══════════════════════════════════════════════════════════════
-- 🌸 Sakura Night - Neovim Configuration
-- ═══════════════════════════════════════════════════════════════

-- ── Options ────────────────────────────────────────────────────
vim.g.mapleader = " "
vim.g.maplocalleader = " "

local opt = vim.opt

-- Line numbers
opt.number = true
opt.relativenumber = true

-- Tabs & indentation
opt.tabstop = 4
opt.shiftwidth = 4
opt.expandtab = true
opt.autoindent = true
opt.smartindent = true

-- Line wrapping
opt.wrap = false

-- Search
opt.ignorecase = true
opt.smartcase = true
opt.hlsearch = true
opt.incsearch = true

-- Appearance
opt.termguicolors = true
opt.signcolumn = "yes"
opt.cursorline = true
opt.scrolloff = 8
opt.sidescrolloff = 8

-- Clipboard
opt.clipboard = "unnamedplus"

-- Split behavior
opt.splitright = true
opt.splitbelow = true

-- Misc
opt.mouse = "a"
opt.undofile = true
opt.swapfile = false
opt.updatetime = 250
opt.timeoutlen = 300

-- ── Keymaps (mirrors tmux: Leader instead of Alt) ─────────────
local map = vim.keymap.set

-- Better escape
map("i", "jk", "<Esc>", { desc = "Exit insert mode" })

-- Clear search highlight
map("n", "<Esc>", ":nohlsearch<CR>", { silent = true })

-- ── Splits (like tmux) ────────────────────────────────────────
map("n", "<leader>E", ":vsplit<CR>", { desc = "Split vertical" })
map("n", "<leader>W", ":split<CR>", { desc = "Split horizontal" })
map("n", "<leader>x", ":close<CR>", { desc = "Close split" })

-- ── Window navigation (like tmux h/j/k/l) ─────────────────────
map("n", "<leader>h", "<C-w>h", { desc = "Move left" })
map("n", "<leader>j", "<C-w>j", { desc = "Move down" })
map("n", "<leader>k", "<C-w>k", { desc = "Move up" })
map("n", "<leader>l", "<C-w>l", { desc = "Move right" })

-- ── Window resize (like tmux H/J/K/L) ─────────────────────────
map("n", "<leader>H", ":vertical resize -5<CR>", { desc = "Resize left", silent = true })
map("n", "<leader>J", ":resize -5<CR>", { desc = "Resize down", silent = true })
map("n", "<leader>K", ":resize +5<CR>", { desc = "Resize up", silent = true })
map("n", "<leader>L", ":vertical resize +5<CR>", { desc = "Resize right", silent = true })

-- ── Tabs/Buffers (like tmux windows) ──────────────────────────
map("n", "<leader>c", ":tabnew<CR>", { desc = "New tab" })
map("n", "<leader>t", ":tabnext<CR>", { desc = "Next tab" })
map("n", "<leader>T", ":tabprev<CR>", { desc = "Previous tab" })
map("n", "<leader>1", "1gt", { desc = "Tab 1" })
map("n", "<leader>2", "2gt", { desc = "Tab 2" })
map("n", "<leader>3", "3gt", { desc = "Tab 3" })
map("n", "<leader>4", "4gt", { desc = "Tab 4" })
map("n", "<leader>5", "5gt", { desc = "Tab 5" })

-- ── Save & Quit ───────────────────────────────────────────────
map("n", "<leader>s", ":w<CR>", { desc = "Save" })
map("n", "<leader>q", ":q<CR>", { desc = "Quit" })
map("n", "<leader>Q", ":qa!<CR>", { desc = "Quit all" })

-- ── Move lines ────────────────────────────────────────────────
map("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move line down" })
map("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move line up" })

-- Better indenting
map("v", "<", "<gv")
map("v", ">", ">gv")

-- ── Bootstrap lazy.nvim ────────────────────────────────────────
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable",
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

-- ── Plugins ────────────────────────────────────────────────────
require("lazy").setup({
    -- Colorscheme (Tokyo Night - matches Sakura Night theme)
    {
        "folke/tokyonight.nvim",
        lazy = false,
        priority = 1000,
        config = function()
            require("tokyonight").setup({
                style = "night",
                transparent = true,
                styles = {
                    sidebars = "transparent",
                    floats = "transparent",
                },
            })
            vim.cmd.colorscheme("tokyonight-night")
        end,
    },

    -- Statusline
    {
        "nvim-lualine/lualine.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        config = function()
            require("lualine").setup({
                options = {
                    theme = "tokyonight",
                    component_separators = { left = "", right = "" },
                    section_separators = { left = "", right = "" },
                },
            })
        end,
    },

    -- Syntax highlighting
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        config = function()
            require("nvim-treesitter.configs").setup({
                ensure_installed = { "lua", "vim", "vimdoc", "bash", "python", "javascript", "typescript", "json", "yaml", "markdown" },
                auto_install = true,
                highlight = { enable = true },
                indent = { enable = true },
            })
        end,
    },

    -- Fuzzy finder
    {
        "nvim-telescope/telescope.nvim",
        branch = "0.1.x",
        dependencies = { "nvim-lua/plenary.nvim" },
        keys = {
            { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find files" },
            { "<leader>fg", "<cmd>Telescope live_grep<cr>", desc = "Live grep" },
            { "<leader>fb", "<cmd>Telescope buffers<cr>", desc = "Buffers" },
            { "<leader>fh", "<cmd>Telescope help_tags<cr>", desc = "Help tags" },
            { "<leader>fr", "<cmd>Telescope oldfiles<cr>", desc = "Recent files" },
        },
    },

    -- File explorer
    {
        "nvim-tree/nvim-tree.lua",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        keys = {
            { "<leader>e", "<cmd>NvimTreeToggle<cr>", desc = "Toggle file explorer" },
        },
        config = function()
            require("nvim-tree").setup({
                view = { width = 30 },
                renderer = { icons = { show = { folder_arrow = false } } },
            })
        end,
    },

    -- Git signs
    {
        "lewis6991/gitsigns.nvim",
        config = function()
            require("gitsigns").setup()
        end,
    },

    -- Auto pairs
    {
        "windwp/nvim-autopairs",
        event = "InsertEnter",
        config = true,
    },

    -- Comments
    {
        "numToStr/Comment.nvim",
        keys = {
            { "gcc", mode = "n", desc = "Comment line" },
            { "gc", mode = "v", desc = "Comment selection" },
        },
        config = true,
    },

    -- Which key (shows keybindings)
    {
        "folke/which-key.nvim",
        event = "VeryLazy",
        config = function()
            require("which-key").setup()
        end,
    },

    -- Indent guides
    {
        "lukas-reineke/indent-blankline.nvim",
        main = "ibl",
        config = function()
            require("ibl").setup({
                indent = { char = "│" },
                scope = { enabled = false },
            })
        end,
    },
})

