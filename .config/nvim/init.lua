-- vim:foldmethod=marker
-- Lazy conf is quite huge, so keep it in another file
require("lazy-conf")

-- Settings {{{
local set = vim.opt
-- Better leader ('\' is actually good on us keyboard)
vim.g.mapleader = ' '
-- Enable foldmethod=marker on every file
set.foldmethod = "marker"
set.foldlevelstart = 99
-- Search
set.ignorecase = true
-- Tabs
set.tabstop = 4
set.softtabstop = 4
set.shiftwidth = 4
set.expandtab = true
set.smarttab = true
-- Line-column information
set.colorcolumn = "80,120"
set.number = true
set.relativenumber = false
set.scrolloff = 8
set.signcolumn = 'yes'
-- Long undo instead of swapfile
set.swapfile = false
set.backup = false
set.undodir = os.getenv('HOME') .. '/.vim/undodir'
set.undofile = true
-- attempt autoformatting on save using default LSP
vim.cmd [[autocmd BufWritePre * lua vim.lsp.buf.format()]]

-- Diagnostic {{{
-- -- Opt:
-- Show diagnostic as virtual text on the right (red text)
vim.diagnostic.config({
    virtual_text = true
})
-- -- Opt:
-- Diagnostic as floating window
-- -- https://stackoverflow.com/questions/69290794/nvim-lsp-change-lspconfig-diagnostic-message-location)
-- vim.diagnostic.config({
--     virtual_text = false
-- })
-- -- Show line diagnostics automatically in hover window
-- vim.o.updatetime = 250
-- vim.cmd [[autocmd CursorHold,CursorHoldI * lua vim.diagnostic.open_float(nil, {focus=false})]]
-- }}}

-- Show tabs and trailing characters
set.list = true
set.listchars = {
  tab = '» ',
  trail = '·',
  extends = '›',
  precedes = '‹',
  nbsp = '␣',
}
vim.api.nvim_set_hl(0, "Whitespace", { link = "DiagnosticError", force = true })
-- Autocommand for selected extensions: enable spell checker
vim.api.nvim_create_autocmd("FileType", {
    pattern = {"tex", "md"
    },
    callback = function()
        vim.opt_local.spell = true
        vim.opt_local.spelllang = { "en_us" }
    end,
})
-- Make spell checker matches more visible
vim.api.nvim_set_hl(0, "SpellBad",   { fg = "#ffffff", bg = "#880000", bold = true })
vim.api.nvim_set_hl(0, "SpellCap",   { fg = "#ffffff", bg = "#000088", bold = true })
vim.api.nvim_set_hl(0, "SpellRare",  { fg = "#ffffff", bg = "#CCCC00", bold = true })
vim.api.nvim_set_hl(0, "SpellLocal", { fg = "#ffffff", bg = "#008800", bold = true })
-- }}}

-- Mappings {{{
local map = vim.keymap.set
-- Normal mode
map('n', '<leader>pv', vim.cmd.Ex)
map('n', '<Tab>', vim.cmd.tabn)
map('n', '<S-Tab>', vim.cmd.tabp)
map('n', '<Esc>', vim.cmd.noh)
map('n', 'Q', ':q<CR>')
-- Insert mode
map('i', '<C-h>', '<Left>')
map('i', '<C-j>', '<Down>')
map('i', '<C-k>', '<Up>')
map('i', '<C-l>', '<Right>')
-- Copy/cut in sys clip
map('n', '<leader>y', '"+y')
map('v', '<leader>y', '"+y')
map('n', '<leader>d', '"_d')
map('v', '<leader>d', '"_d')
-- Telescope
local telescope = require('telescope.builtin')
map('n', '<leader>ff', telescope.find_files)
map('n', '<leader>fp', telescope.git_files)
map('n', '<leader>fg', telescope.live_grep)
map('n', '<leader>fb', telescope.buffers)
map('n', '<leader>fh', telescope.help_tags)
map('n', '<leader>fm', telescope.marks)
-- Harpoon
local ui = require('harpoon.ui')
map('n', '<leader>a', require('harpoon.mark').add_file)
map('n', '<C-e>', ui.toggle_quick_menu)
map('n', '<C-h>', function() ui.nav_file(1) end)
map('n', '<C-j>', function() ui.nav_file(2) end)
map('n', '<C-k>', function() ui.nav_file(3) end)
map('n', '<C-l>', function() ui.nav_file(4) end)
-- UndoTree
map('n', '<leader>u', vim.cmd.UndotreeToggle)
-- Vim-fugitive
map('n', '<leader>gs', vim.cmd.Git)
-- Neogen
map('n', '<leader>nf', function() require('neogen').generate() end)
-- }}}
