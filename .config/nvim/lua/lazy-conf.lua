-- Bro, for the love of god, read the F-ing
-- https://github.com/folke/lazy.nvim

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

require('lazy').setup({
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
                    "lua", "vim", "vimdoc", "Latex", "python", "comment", "go", "c", "markdown"
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
    --Neogen (Docstring generation) {{{
    {
        "danymat/neogen",
        config = function ()
            require('neogen').setup {}
        end,
	tag = "*"
    },
    -- }}}
    -- LSP {{{
    {
        -- package {{{
        'neovim/nvim-lspconfig',
        dependencies = {
            -- Uncomment the two plugins below if you want to manage the
            -- language servers from neovim
            'williamboman/mason.nvim',
	    "williamboman/nvim-lsp-installer",
            'williamboman/mason-lspconfig.nvim',
            'hrsh7th/cmp-nvim-lsp',
            'hrsh7th/nvim-cmp',
            'L3MON4D3/LuaSnip',
            { 'VonHeikemen/lsp-zero.nvim', branch = 'v3.x' },
        },
        -- }}}
        init = function()
            -- lsp-zero {{{
            local lsp_zero = require('lsp-zero')
            lsp_zero.extend_lspconfig()
            -- When Language Server is active in the current file enable
            -- keybindings
            lsp_zero.on_attach(function(_, bufnr)
                -- see :help lsp-zero-keybindings
                -- to learn the available actions
                lsp_zero.default_keymaps({ buffer = bufnr })
            end)
            -- }}}
            -- cmp {{{
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
            -- }}}
            -- mason {{{
            -- leave to mason the burden to manage language servers
            require('mason').setup({})
            require('mason-lspconfig').setup({
                ensure_installed = { 'rust_analyzer', 'lua_ls', 'texlab', 'pyright', 'clangd', 'html' },
                -- Language server configuration
                -- https://lsp-zero.netlify.app/v3.x/guide/integrate-with-mason-nvim.html#configure-a-language-server
                handlers = {
                    lsp_zero.default_setup,
                    lua_ls = function()
                        require('lspconfig').lua_ls.setup({
                            settings = {
                                -- Prevent warning "Undefined global 'vim'"
                                Lua = { diagnostics = { globals = { 'vim' } } },
                            },
                        })
                    end,
                    rust_analyzer = function()
                        require('lspconfig').rust_analyzer.setup({
                            cargo = {
                                allFeatures = true,
                            },
                            checkOnSave = {
                                command = 'clippy'
                            },
                            diagnostics = {
                                enable = true,
                                experimental = {
                                    enable = true,
                                }
                            },
                        })
                    end,
                    clangd = function()
                        require('lspconfig').clangd.setup({
                            cmd = {
                                "clangd",
                                -- Look for compile_commands.json in the current dir
                                "--compile-commands-dir=.",
                                -- "--query-driver=/path/to/toolchain/arch-*"
                            }
                        })
                    end
                },
            })
            -- }}}
        end,
    },
    -- }}}
})
