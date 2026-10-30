-- Bro, for the love of god, read the F-ing
-- https://github.com/folke/lazy.nvim

local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        'git',
        'clone',
        '--filter=blob:none',
        'https://github.com/folke/lazy.nvim.git',
        '--branch=stable', -- latest stable release
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

require('lazy').setup({
    { 'catppuccin/nvim', name = 'catppuccin', priority = 1000 },
    { 'tpope/vim-fugitive' },
    { 'mbbill/undotree' },
    { 'ThePrimeagen/harpoon', dependencies = { 'nvim-lua/plenary.nvim' } },
    -- Telescope {{{
    {
        'nvim-telescope/telescope.nvim',
        tag = '0.1.5',
        dependencies = { 'sharkdp/fd', 'nvim-lua/plenary.nvim' }
    },
    -- }}}
    -- TreeSitter {{{
    {
        'nvim-treesitter/nvim-treesitter',
        init = function()
            require('nvim-treesitter').setup {
                ensure_installed = {
                    'lua', 'vim', 'vimdoc', 'Latex', 'python', 'comment', 'go', 'c', 'markdown'
                },
                sync_install = false,
                auto_install = true,
                highlight = {
                    enable = true,
                    additional_vim_regex_highlighting = false,
                },
            }
        end
    },
    -- }}}
    -- Neogen (Docstring generation) {{{
    {
        'danymat/neogen',
        config = true,
        version = '*'
    },
    -- }}}
    -- CMP {{{
    { 'L3MON4D3/LuaSnip' },
    { 'hrsh7th/cmp-nvim-lsp' },
    {
        'hrsh7th/nvim-cmp',
        config = function()
            local cmp = require('cmp')
            local cmp_select = { behavior = cmp.SelectBehavior.Select }
            local luasnip = require('luasnip')
            cmp.setup({
                snippet = {
                    expand = function(args)
                        luasnip.lsp_expand(args.body)
                    end,
                },
                mapping = cmp.mapping.preset.insert({
                    ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
                    ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
                    ['<C-y>'] = cmp.mapping.confirm({ select = true }),
                    ['<Tab>'] = cmp.mapping.confirm({ select = true }),
                    ['<C-space>'] = cmp.mapping.complete(),
                }),
                sources = {
                    { name = "nvim_lsp" },
                    { name = "luasnip" },
                }
            })
        end,
    },
    -- }}}
    -- LSPzero {{{
    {
        'VonHeikemen/lsp-zero.nvim', branch = 'v3.x',
        config = function()
            local lsp_zero = require('lsp-zero')
            lsp_zero.extend_lspconfig()
            lsp_zero.on_attach(function(_, bufnr)
                lsp_zero.default_keymaps({ buffer = bufnr })
            end)
        end,
    },
    -- }}}
    -- LSP {{{
    {
        'neovim/nvim-lspconfig',
        dependencies = {
            'williamboman/mason.nvim',
            'williamboman/mason-lspconfig.nvim',
            { 'VonHeikemen/lsp-zero.nvim', branch = 'v3.x' },
            'hrsh7th/cmp-nvim-lsp',
            'hrsh7th/nvim-cmp',
            'L3MON4D3/LuaSnip',
        },
        config = function()
            -- Lua language server
            vim.lsp.config('lua_ls', {
                settings = {Lua = {diagnostics = {globals = { 'vim' },},},},
            })
            -- Rust language server
            vim.lsp.config('rust_analyzer', {
                cargo = {
                    allFeatures = true,
                },
                checkOnSave = {
                    command = 'clippy',
                },
                diagnostics = {
                    enable = true,
                    experimental = {
                        enable = true,
                    },
                },
            })
            -- Clang language server
            vim.lsp.config('clangd', {
                cmd = {
                    'clangd',
                    '--compile-commands-dir=.',
                    -- '--query-driver=/path/to/toolchain/arch-*'
                },
            })
            -- Enable language servers
            vim.lsp.enable({
                'clangd',
                'lua_ls',
                'pyright',
                'rust_analyzer',
                'texlab',
            })
        end,
    },
    -- }}}
    -- Mason {{{
    {
        'mason-org/mason.nvim',
        opts = {},
    },
    {
        'mason-org/mason-lspconfig.nvim',
        dependencies = {
            'mason-org/mason.nvim',
            'neovim/nvim-lspconfig',
        },
        opts = {
            ensure_installed = {
                -- clangd: use system binary
                'lua_ls',
                'pyright',
                'rust_analyzer',
                'texlab',
            },
        },
    },
    -- }}}
})
