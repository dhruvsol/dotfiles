-- ═══════════════════════════════════════════════════════════════
-- 🌸 Sakura Night - LSP Configuration (Neovim 0.11+)
-- ═══════════════════════════════════════════════════════════════

return {
    -- ── Mason (LSP installer) ────────────────────────────────────
    {
        "williamboman/mason.nvim",
        config = function()
            require("mason").setup({
                ui = {
                    border = "rounded",
                    icons = {
                        package_installed = "✓",
                        package_pending = "→",
                        package_uninstalled = "✗",
                    },
                },
            })
        end,
    },

    -- ── Mason LSPConfig bridge ───────────────────────────────────
    {
        "williamboman/mason-lspconfig.nvim",
        dependencies = {
            "williamboman/mason.nvim",
            "neovim/nvim-lspconfig",
            "hrsh7th/cmp-nvim-lsp",
            "b0o/schemastore.nvim",
        },
        config = function()
            require("mason-lspconfig").setup({
                ensure_installed = {
                    "ts_ls",
                    "html",
                    "cssls",
                    "tailwindcss",
                    "emmet_ls",
                    "marksman",
                    "taplo",
                    "jsonls",
                    "lua_ls",
                },
                automatic_installation = true,
            })

            local capabilities = require("cmp_nvim_lsp").default_capabilities()

            -- ── Configure servers using vim.lsp.config (Neovim 0.11+) ──

            -- TypeScript / JavaScript / React
            vim.lsp.config("ts_ls", {
                capabilities = capabilities,
                settings = {
                    typescript = {
                        inlayHints = {
                            includeInlayParameterNameHints = "all",
                            includeInlayFunctionParameterTypeHints = true,
                        },
                    },
                },
            })

            -- HTML
            vim.lsp.config("html", {
                capabilities = capabilities,
            })

            -- CSS
            vim.lsp.config("cssls", {
                capabilities = capabilities,
            })

            -- Tailwind CSS
            vim.lsp.config("tailwindcss", {
                capabilities = capabilities,
            })

            -- Emmet (HTML/CSS snippets)
            vim.lsp.config("emmet_ls", {
                capabilities = capabilities,
                filetypes = {
                    "html", "css", "scss", "javascript", "javascriptreact",
                    "typescript", "typescriptreact", "vue", "svelte",
                },
            })

            -- Markdown
            vim.lsp.config("marksman", {
                capabilities = capabilities,
            })

            -- TOML
            vim.lsp.config("taplo", {
                capabilities = capabilities,
            })

            -- JSON
            vim.lsp.config("jsonls", {
                capabilities = capabilities,
                settings = {
                    json = {
                        schemas = require("schemastore").schemas(),
                        validate = { enable = true },
                    },
                },
            })

            -- Lua (for Neovim config)
            vim.lsp.config("lua_ls", {
                capabilities = capabilities,
                settings = {
                    Lua = {
                        diagnostics = { globals = { "vim" } },
                        workspace = { checkThirdParty = false },
                        telemetry = { enable = false },
                    },
                },
            })

            -- ── Enable all servers ──
            vim.lsp.enable({
                "ts_ls",
                "html",
                "cssls",
                "tailwindcss",
                "emmet_ls",
                "marksman",
                "taplo",
                "jsonls",
                "lua_ls",
            })
        end,
    },

    -- ── LSP Keymaps (on attach) ──────────────────────────────────
    {
        "neovim/nvim-lspconfig",
        config = function()
            -- Keymaps applied when LSP attaches to buffer
            vim.api.nvim_create_autocmd("LspAttach", {
                callback = function(args)
                    local bufnr = args.buf
                    local map = function(keys, func, desc)
                        vim.keymap.set("n", keys, func, { buffer = bufnr, desc = desc })
                    end

                    map("gd", vim.lsp.buf.definition, "Go to definition")
                    map("gD", vim.lsp.buf.declaration, "Go to declaration")
                    map("gr", vim.lsp.buf.references, "Go to references")
                    map("gi", vim.lsp.buf.implementation, "Go to implementation")
                    map("K", vim.lsp.buf.hover, "Hover documentation")
                    map("<leader>rn", vim.lsp.buf.rename, "Rename symbol")
                    map("<leader>ca", vim.lsp.buf.code_action, "Code action")
                    map("<leader>D", vim.lsp.buf.type_definition, "Type definition")
                    map("<leader>ds", vim.lsp.buf.document_symbol, "Document symbols")
                    map("[d", vim.diagnostic.goto_prev, "Previous diagnostic")
                    map("]d", vim.diagnostic.goto_next, "Next diagnostic")
                    map("<leader>d", vim.diagnostic.open_float, "Show diagnostic")
                end,
            })

            -- Diagnostic signs
            local signs = { Error = " ", Warn = " ", Hint = "󰌵 ", Info = " " }
            for type, icon in pairs(signs) do
                local hl = "DiagnosticSign" .. type
                vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
            end
        end,
    },

    -- ── Autocompletion ───────────────────────────────────────────
    {
        "hrsh7th/nvim-cmp",
        dependencies = {
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
            "L3MON4D3/LuaSnip",
            "saadparwaiz1/cmp_luasnip",
            "rafamadriz/friendly-snippets",
        },
        config = function()
            local cmp = require("cmp")
            local luasnip = require("luasnip")

            require("luasnip.loaders.from_vscode").lazy_load()

            cmp.setup({
                snippet = {
                    expand = function(args)
                        luasnip.lsp_expand(args.body)
                    end,
                },
                mapping = cmp.mapping.preset.insert({
                    ["<C-b>"] = cmp.mapping.scroll_docs(-4),
                    ["<C-f>"] = cmp.mapping.scroll_docs(4),
                    ["<C-Space>"] = cmp.mapping.complete(),
                    ["<C-e>"] = cmp.mapping.abort(),
                    ["<CR>"] = cmp.mapping.confirm({ select = true }),
                    ["<Tab>"] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_next_item()
                        elseif luasnip.expand_or_jumpable() then
                            luasnip.expand_or_jump()
                        else
                            fallback()
                        end
                    end, { "i", "s" }),
                    ["<S-Tab>"] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_prev_item()
                        elseif luasnip.jumpable(-1) then
                            luasnip.jump(-1)
                        else
                            fallback()
                        end
                    end, { "i", "s" }),
                }),
                sources = cmp.config.sources({
                    { name = "nvim_lsp" },
                    { name = "luasnip" },
                    { name = "buffer" },
                    { name = "path" },
                }),
                window = {
                    completion = cmp.config.window.bordered(),
                    documentation = cmp.config.window.bordered(),
                },
            })
        end,
    },

    -- ── Rustacean (enhanced Rust support) ──────────────────────
    -- https://github.com/mrcjkb/rustaceanvim
    {
        "mrcjkb/rustaceanvim",
        version = "^5",
        lazy = false,
        ft = { "rust" },
        init = function()
            vim.g.rustaceanvim = {
                tools = {
                    hover_actions = { replace_builtin_hover = true },
                },
                server = {
                    default_settings = {
                        ["rust-analyzer"] = {
                            checkOnSave = { command = "clippy" },
                            cargo = { allFeatures = true },
                            inlayHints = {
                                closureReturnTypeHints = { enable = "always" },
                                lifetimeElisionHints = { enable = "always" },
                            },
                        },
                    },
                },
            }
        end,
    },
}
