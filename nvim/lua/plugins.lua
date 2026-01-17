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
                transparent = false,  -- Disabled transparency for better readability
                styles = {
                    sidebars = "dark",
                    floats = "dark",
                },
                on_colors = function(colors)
                    -- Make backgrounds more visible
                    colors.bg_popup = "#1a1b26"
                    colors.bg_float = "#1a1b26"
                end,
                on_highlights = function(hl, colors)
                    -- Popup menu (completion menu) colors
                    hl.Pmenu = { bg = colors.bg_popup, fg = colors.fg }
                    hl.PmenuSel = { bg = colors.blue2, fg = colors.bg_dark, bold = true }
                    hl.PmenuSbar = { bg = colors.bg_popup }
                    hl.PmenuThumb = { bg = colors.fg_gutter }

                    -- CMP specific highlights for better distinction
                    hl.CmpItemAbbrMatch = { fg = colors.blue, bold = true }
                    hl.CmpItemAbbrMatchFuzzy = { fg = colors.blue, bold = true }
                    hl.CmpItemKindVariable = { fg = colors.magenta }
                    hl.CmpItemKindFunction = { fg = colors.blue }
                    hl.CmpItemKindMethod = { fg = colors.blue }
                    hl.CmpItemKindKeyword = { fg = colors.cyan }
                    hl.CmpItemKindProperty = { fg = colors.green1 }
                    hl.CmpItemKindUnit = { fg = colors.orange }
                    hl.CmpItemKindClass = { fg = colors.yellow }
                    hl.CmpItemKindModule = { fg = colors.purple }
                    hl.CmpItemKindStruct = { fg = colors.yellow }
                    hl.CmpItemKindEnum = { fg = colors.yellow }
                    hl.CmpItemKindSnippet = { fg = colors.red }

                    -- Float windows
                    hl.NormalFloat = { bg = colors.bg_popup, fg = colors.fg }
                    hl.FloatBorder = { bg = colors.bg_popup, fg = colors.blue }
                    hl.FloatTitle = { bg = colors.bg_popup, fg = colors.blue, bold = true }

                    -- LSP signature help
                    hl.LspSignatureActiveParameter = { fg = colors.orange, bold = true, underline = true }
                end,
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
        cmd = "Telescope",
        keys = {
            { "<leader>ff", function() require("telescope.builtin").find_files() end, desc = "Find files" },
            { "<leader>fg", function() require("telescope.builtin").live_grep() end, desc = "Live grep" },
            { "<leader>fb", function() require("telescope.builtin").buffers() end, desc = "Buffers" },
            { "<leader>fh", function() require("telescope.builtin").help_tags() end, desc = "Help tags" },
            { "<leader>fr", function() require("telescope.builtin").oldfiles() end, desc = "Recent files" },
        },
        config = function()
            -- Fix for Neovim 0.11+ treesitter API changes
            local ts_utils = require("telescope.previewers.utils")
            local original_highlighter = ts_utils.ts_highlighter
            ts_utils.ts_highlighter = function(bufnr, ft)
                -- Gracefully handle treesitter errors
                local status_ok, _ = pcall(original_highlighter, bufnr, ft)
                if not status_ok then
                    -- Fallback to vim syntax highlighting
                    vim.bo[bufnr].syntax = ft
                end
            end

            require("telescope").setup({
                defaults = {
                    prompt_prefix = " ",
                    selection_caret = " ",
                    path_display = { "truncate" },
                    layout_config = {
                        horizontal = {
                            preview_width = 0.55,
                        },
                    },
                    -- Disable treesitter preview to avoid errors
                    preview = {
                        treesitter = false,
                    },
                },
                pickers = {
                    find_files = {
                        hidden = true,
                        find_command = { "rg", "--files", "--hidden", "--glob", "!.git/*" },
                    },
                },
            })
        end,
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

    -- ── Easy text object selection ───────────────────────────────
    {
        "echasnovski/mini.ai",
        event = "VeryLazy",
        config = function()
            require("mini.ai").setup({
                -- Configuration for custom text objects
                n_lines = 500,
                custom_textobjects = {
                    -- Whole buffer
                    e = function()
                        local from = { line = 1, col = 1 }
                        local to = {
                            line = vim.fn.line("$"),
                            col = math.max(vim.fn.getline("$"):len(), 1),
                        }
                        return { from = from, to = to }
                    end,
                },
            })
        end,
    },

    -- ── Surround text objects ────────────────────────────────────
    {
        "echasnovski/mini.surround",
        event = "VeryLazy",
        config = function()
            require("mini.surround").setup({
                mappings = {
                    add = "sa",            -- Add surrounding in Normal and Visual modes
                    delete = "sd",         -- Delete surrounding
                    find = "sf",           -- Find surrounding (to the right)
                    find_left = "sF",      -- Find surrounding (to the left)
                    highlight = "sh",      -- Highlight surrounding
                    replace = "sr",        -- Replace surrounding
                    update_n_lines = "sn", -- Update `n_lines`
                },
            })
        end,
    },

    -- ── Flash (quick jump to any location) ──────────────────────
    {
        "folke/flash.nvim",
        event = "VeryLazy",
        opts = {
            modes = {
                char = {
                    jump_labels = true,
                },
            },
        },
        keys = {
            {
                "s",
                mode = { "n", "x", "o" },
                function() require("flash").jump() end,
                desc = "Flash jump",
            },
            {
                "S",
                mode = { "n", "x", "o" },
                function() require("flash").treesitter() end,
                desc = "Flash treesitter",
            },
        },
    },

}

