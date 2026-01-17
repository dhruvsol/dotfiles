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
                    "rust_analyzer",
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
                            includeInlayParameterNameTypeHints = true,
                            includeInlayFunctionParameterTypeHints = true,
                            includeInlayVariableTypeHints = true,
                            includeInlayPropertyDeclarationTypeHints = true,
                            includeInlayFunctionLikeReturnTypeHints = true,
                            includeInlayEnumMemberValueHints = true,
                        },
                        suggest = {
                            completeFunctionCalls = true,
                        },
                        preferences = {
                            importModuleSpecifier = "relative",
                        },
                    },
                    javascript = {
                        inlayHints = {
                            includeInlayParameterNameHints = "all",
                            includeInlayParameterNameTypeHints = true,
                            includeInlayFunctionParameterTypeHints = true,
                            includeInlayVariableTypeHints = true,
                            includeInlayPropertyDeclarationTypeHints = true,
                            includeInlayFunctionLikeReturnTypeHints = true,
                            includeInlayEnumMemberValueHints = true,
                        },
                        suggest = {
                            completeFunctionCalls = true,
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
            local schemastore_ok, schemastore = pcall(require, "schemastore")
            vim.lsp.config("jsonls", {
                capabilities = capabilities,
                settings = {
                    json = {
                        schemas = schemastore_ok and schemastore.json.schemas() or {},
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

            -- ── Enable all servers (except rust_analyzer, handled by rustaceanvim) ──
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
                    local client = vim.lsp.get_client_by_id(args.data.client_id)
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

                    -- Enable inlay hints if supported (Neovim 0.10+)
                    if client and client.server_capabilities.inlayHintProvider then
                        vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })

                        -- Toggle inlay hints with <leader>th
                        map("<leader>th", function()
                            vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr }), { bufnr = bufnr })
                        end, "Toggle inlay hints")
                    end
                end,
            })

            -- Diagnostic configuration
            vim.diagnostic.config({
                virtual_text = {
                    prefix = "●",
                    spacing = 4,
                },
                signs = true,
                underline = true,
                update_in_insert = false,
                severity_sort = true,
                float = {
                    border = "rounded",
                    source = "always",
                    header = "",
                    prefix = "",
                    focusable = false,
                },
            })

            -- Diagnostic signs
            local signs = { Error = " ", Warn = " ", Hint = "󰌵 ", Info = " " }
            for type, icon in pairs(signs) do
                local hl = "DiagnosticSign" .. type
                vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
            end

            -- Set rounded borders for LSP windows
            local handlers = {
                ["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded" }),
                ["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = "rounded" }),
            }
            vim.lsp.handlers["textDocument/hover"] = handlers["textDocument/hover"]
            vim.lsp.handlers["textDocument/signatureHelp"] = handlers["textDocument/signatureHelp"]
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
            "onsails/lspkind.nvim",
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

                    -- Use Ctrl+j/k to navigate completion items
                    ["<C-j>"] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_next_item()
                        elseif luasnip.expand_or_jumpable() then
                            luasnip.expand_or_jump()
                        else
                            fallback()
                        end
                    end, { "i", "s" }),
                    ["<C-k>"] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_prev_item()
                        elseif luasnip.jumpable(-1) then
                            luasnip.jump(-1)
                        else
                            fallback()
                        end
                    end, { "i", "s" }),

                    -- Keep Tab/Shift-Tab as alternative
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
                    { name = "nvim_lsp", priority = 1000 },
                    { name = "luasnip", priority = 750 },
                    { name = "crates", priority = 800 },
                    { name = "buffer", priority = 500 },
                    { name = "path", priority = 250 },
                }),
                formatting = {
                    fields = { "kind", "abbr", "menu" },
                    format = function(entry, vim_item)
                        local kind_icons = {
                            Text = "󰉿",
                            Method = "󰆧",
                            Function = "󰊕",
                            Constructor = "",
                            Field = "󰜢",
                            Variable = "󰀫",
                            Class = "󰠱",
                            Interface = "",
                            Module = "",
                            Property = "󰜢",
                            Unit = "󰑭",
                            Value = "󰎠",
                            Enum = "",
                            Keyword = "󰌋",
                            Snippet = "",
                            Color = "󰏘",
                            File = "󰈙",
                            Reference = "󰈇",
                            Folder = "󰉋",
                            EnumMember = "",
                            Constant = "󰏿",
                            Struct = "󰙅",
                            Event = "",
                            Operator = "󰆕",
                            TypeParameter = "",
                        }
                        -- Kind with icon
                        vim_item.kind = string.format("%s %s", kind_icons[vim_item.kind] or "", vim_item.kind)

                        -- Source
                        vim_item.menu = ({
                            nvim_lsp = "[LSP]",
                            luasnip = "[Snippet]",
                            crates = "[Crate]",
                            buffer = "[Buffer]",
                            path = "[Path]",
                        })[entry.source.name]

                        return vim_item
                    end,
                },
                window = {
                    completion = cmp.config.window.bordered({
                        border = "rounded",
                        winhighlight = "Normal:Normal,FloatBorder:FloatBorder,CursorLine:PmenuSel,Search:None",
                    }),
                    documentation = cmp.config.window.bordered({
                        border = "rounded",
                        winhighlight = "Normal:Normal,FloatBorder:FloatBorder",
                    }),
                },
                experimental = {
                    ghost_text = {
                        hl_group = "Comment",
                    },
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
                    float_win_config = {
                        border = "rounded",
                    },
                },
                server = {
                    on_attach = function(_, bufnr)
                        -- Rust-specific keymaps
                        local map = function(keys, func, desc)
                            vim.keymap.set("n", keys, func, { buffer = bufnr, desc = desc })
                        end

                        map("<leader>rd", "<cmd>RustLsp debuggables<cr>", "Rust debuggables")
                        map("<leader>rr", "<cmd>RustLsp runnables<cr>", "Rust runnables")
                        map("<leader>rt", "<cmd>RustLsp testables<cr>", "Rust testables")
                        map("<leader>re", "<cmd>RustLsp expandMacro<cr>", "Expand macro")
                        map("<leader>rc", "<cmd>RustLsp openCargo<cr>", "Open Cargo.toml")
                        map("<leader>rp", "<cmd>RustLsp parentModule<cr>", "Parent module")
                        map("<leader>rj", "<cmd>RustLsp joinLines<cr>", "Join lines")
                        map("K", "<cmd>RustLsp hover actions<cr>", "Hover actions")
                    end,
                    default_settings = {
                        ["rust-analyzer"] = {
                            checkOnSave = {
                                command = "clippy",
                                extraArgs = { "--all", "--", "-W", "clippy::all" },
                            },
                            cargo = {
                                allFeatures = true,
                                loadOutDirsFromCheck = true,
                                buildScripts = { enable = true },
                            },
                            procMacro = {
                                enable = true,
                                ignored = {
                                    ["async-trait"] = { "async_trait" },
                                    ["napi-derive"] = { "napi" },
                                    ["async-recursion"] = { "async_recursion" },
                                },
                            },
                            diagnostics = {
                                enable = true,
                                experimental = { enable = true },
                                disabled = { "unresolved-proc-macro" },
                            },
                            inlayHints = {
                                bindingModeHints = { enable = true },
                                chainingHints = { enable = true },
                                closingBraceHints = { minLines = 10 },
                                closureReturnTypeHints = { enable = "always" },
                                lifetimeElisionHints = {
                                    enable = "always",
                                    useParameterNames = true,
                                },
                                parameterHints = { enable = true },
                                reborrowHints = { enable = "always" },
                                renderColons = true,
                                typeHints = {
                                    enable = true,
                                    hideClosureInitialization = false,
                                    hideNamedConstructor = false,
                                },
                            },
                            hover = {
                                actions = { enable = true },
                                documentation = { enable = true },
                            },
                            completion = {
                                callable = { snippets = "fill_arguments" },
                                postfix = { enable = true },
                                autoimport = { enable = true },
                            },
                        },
                    },
                },
            }
        end,
    },
}
