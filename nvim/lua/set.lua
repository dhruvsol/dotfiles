-- ═══════════════════════════════════════════════════════════════
-- 🌸 Sakura Night - Options
-- ═══════════════════════════════════════════════════════════════

local opt = vim.opt

-- ── Line numbers ─────────────────────────────────────────────
opt.number = true
opt.relativenumber = true

-- ── Tabs & indentation ───────────────────────────────────────
opt.tabstop = 4
opt.shiftwidth = 4
opt.expandtab = true
opt.autoindent = true
opt.smartindent = true

-- ── Line wrapping ────────────────────────────────────────────
opt.wrap = false

-- ── Search ───────────────────────────────────────────────────
opt.ignorecase = true
opt.smartcase = true
opt.hlsearch = true
opt.incsearch = true

-- ── Appearance ───────────────────────────────────────────────
opt.termguicolors = true
opt.signcolumn = "yes"
opt.cursorline = true
opt.scrolloff = 8
opt.sidescrolloff = 8

-- ── Clipboard ────────────────────────────────────────────────
opt.clipboard = "unnamedplus"

-- ── Split behavior ───────────────────────────────────────────
opt.splitright = true
opt.splitbelow = true

-- ── Misc ─────────────────────────────────────────────────────
opt.mouse = "a"
opt.undofile = true
opt.swapfile = false
opt.updatetime = 250
opt.timeoutlen = 300

-- ── Tabline ──────────────────────────────────────────────────
vim.g.tab_names = {}

vim.api.nvim_create_user_command("TabRename", function(opts)
    vim.g.tab_names[vim.api.nvim_get_current_tabpage()] = opts.args
    vim.cmd("redrawtabline")
end, { nargs = 1 })

function _G.custom_tabline()
    local s = ""
    for i = 1, vim.fn.tabpagenr("$") do
        local tabid = vim.api.nvim_list_tabpages()[i]
        local is_current = i == vim.fn.tabpagenr()
        s = s .. (is_current and "%#TabLineSel#" or "%#TabLine#")
        s = s .. " " .. i .. ":"
        local name = vim.g.tab_names[tabid]
        if not name or name == "" then
            local buflist = vim.fn.tabpagebuflist(i)
            local bufname = vim.fn.bufname(buflist[1])
            name = vim.fn.fnamemodify(bufname, ":t")
            if name == "" then name = "[No Name]" end
        end
        s = s .. name .. " "
    end
    s = s .. "%#TabLineFill#"
    return s
end

vim.o.tabline = "%!v:lua.custom_tabline()"
vim.o.showtabline = 2

