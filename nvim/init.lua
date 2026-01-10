-- ═══════════════════════════════════════════════════════════════
-- 🌸 Sakura Night - Neovim Configuration
-- ═══════════════════════════════════════════════════════════════

-- Leader key (must be set before plugins)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Load modules
require("set")      -- Options
require("remap")    -- Keymaps

-- ── Bootstrap lazy.nvim ──────────────────────────────────────
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

-- Load plugins (merge plugins.lua and lsp.lua)
local plugins = require("plugins")
local lsp = require("lsp")

-- Combine both tables
for _, plugin in ipairs(lsp) do
    table.insert(plugins, plugin)
end

require("lazy").setup(plugins)
