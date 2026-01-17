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
                "json", "yaml", "xml",
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

    -- ── TypeScript utilities ─────────────────────────────────────
    {
        "pmizio/typescript-tools.nvim",
        dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
        ft = { "typescript", "typescriptreact", "javascript", "javascriptreact" },
        opts = {
            settings = {
                expose_as_code_action = "all",
                tsserver_file_preferences = {
                    includeInlayParameterNameHints = "all",
                    includeInlayParameterNameHintsWhenArgumentMatchesName = true,
                    includeInlayFunctionParameterTypeHints = true,
                    includeInlayVariableTypeHints = true,
                    includeInlayPropertyDeclarationTypeHints = true,
                    includeInlayFunctionLikeReturnTypeHints = true,
                    includeInlayEnumMemberValueHints = true,
                },
            },
        },
    },

    -- ── Crates.io integration (Cargo.toml) ──────────────────────
    {
        "saecki/crates.nvim",
        event = { "BufRead Cargo.toml" },
        dependencies = { "nvim-lua/plenary.nvim" },
        config = function()
            require("crates").setup({
                completion = {
                    cmp = { enabled = true },
                },
                lsp = {
                    enabled = true,
                    actions = true,
                    completion = true,
                    hover = true,
                },
            })
        end,
    },

    -- ── Trouble (better diagnostics list) ───────────────────────
    {
        "folke/trouble.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        keys = {
            { "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", desc = "Toggle diagnostics" },
            { "<leader>xd", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", desc = "Buffer diagnostics" },
            { "<leader>xl", "<cmd>Trouble lsp toggle focus=false win.position=right<cr>", desc = "LSP references" },
        },
        opts = {},
    },

    -- ── Better code actions ──────────────────────────────────────
    {
        "aznhe21/actions-preview.nvim",
        keys = {
            {
                "<leader>ca",
                function() require("actions-preview").code_actions() end,
                mode = { "n", "v" },
                desc = "Code actions",
            },
        },
        config = function()
            require("actions-preview").setup({
                telescope = {
                    sorting_strategy = "ascending",
                    layout_strategy = "vertical",
                    layout_config = {
                        width = 0.8,
                        height = 0.9,
                        prompt_position = "top",
                        preview_cutoff = 20,
                        preview_height = function(_, _, max_lines)
                            return max_lines - 15
                        end,
                    },
                },
            })
        end,
    },

    -- ── Better inlay hints rendering ────────────────────────────
    {
        "lvimuser/lsp-inlayhints.nvim",
        event = "LspAttach",
        config = function()
            require("lsp-inlayhints").setup({
                inlay_hints = {
                    parameter_hints = { prefix = "← " },
                    type_hints = { prefix = "» ", remove_colon_start = true },
                },
            })

            vim.api.nvim_create_autocmd("LspAttach", {
                callback = function(args)
                    local bufnr = args.buf
                    local client = vim.lsp.get_client_by_id(args.data.client_id)
                    if client.server_capabilities.inlayHintProvider then
                        require("lsp-inlayhints").on_attach(client, bufnr)
                    end
                end,
            })

            -- Toggle inlay hints with <leader>th
            vim.keymap.set("n", "<leader>th", function()
                require("lsp-inlayhints").toggle()
            end, { desc = "Toggle inlay hints" })
        end,
    },
}

