-- ═══════════════════════════════════════════════════════════════
-- 🌸 Sakura Night - Plugins
-- ═══════════════════════════════════════════════════════════════

return {
    -- ── Colorscheme ──────────────────────────────────────────────
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

    -- ── Icons ───────────────────────────────────────────────────
    {
        "nvim-tree/nvim-web-devicons",
        lazy = false,
        config = function()
            require("nvim-web-devicons").setup()
        end,
    },

    -- ── Statusline ───────────────────────────────────────────────
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

    -- ── Syntax highlighting (nvim-treesitter rewrite for 0.11+) ──
    {
        "nvim-treesitter/nvim-treesitter",
        lazy = false,
        build = ":TSUpdate",
        config = function()
            -- Install parsers
            require("nvim-treesitter").install({
                -- Core
                "lua", "vim", "vimdoc", "bash", "regex",
                -- Rust
                "rust", "toml",
                -- Web / Frontend
                "javascript", "typescript", "tsx", "html", "css", "scss",
                -- Data
                "json", "jsonc", "yaml", "xml",
                -- Docs
                "markdown", "markdown_inline",
                -- Other
                "python", "go", "c", "cpp",
                -- Git
                "gitcommit", "gitignore", "diff",
            })

            -- Enable treesitter highlighting for all filetypes
            vim.api.nvim_create_autocmd("FileType", {
                callback = function()
                    pcall(vim.treesitter.start)
                end,
            })

            -- Enable treesitter-based folding
            vim.api.nvim_create_autocmd("FileType", {
                callback = function()
                    vim.wo[0][0].foldexpr = "v:lua.vim.treesitter.foldexpr()"
                    vim.wo[0][0].foldmethod = "expr"
                    vim.wo[0][0].foldenable = false  -- Start with folds open
                end,
            })

            -- Enable treesitter-based indentation
            vim.api.nvim_create_autocmd("FileType", {
                callback = function()
                    vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
                end,
            })
        end,
    },

    -- ── Fuzzy finder ─────────────────────────────────────────────
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

    -- ── File explorer ────────────────────────────────────────────
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

    -- ── Git signs ────────────────────────────────────────────────
    {
        "lewis6991/gitsigns.nvim",
        config = function()
            require("gitsigns").setup()
        end,
    },

    -- ── Auto pairs ───────────────────────────────────────────────
    {
        "windwp/nvim-autopairs",
        event = "InsertEnter",
        config = true,
    },

    -- ── Comments ─────────────────────────────────────────────────
    {
        "numToStr/Comment.nvim",
        keys = {
            { "gcc", mode = "n", desc = "Comment line" },
            { "gc", mode = "v", desc = "Comment selection" },
        },
        config = true,
    },

    -- ── Which key ────────────────────────────────────────────────
    {
        "folke/which-key.nvim",
        event = "VeryLazy",
        config = function()
            require("which-key").setup()
        end,
    },

    -- ── Indent guides ────────────────────────────────────────────
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
}

