return {
    {
        'VonHeikemen/lsp-zero.nvim',
        branch = 'v3.x',
        lazy = true,
        config = false,
        init = function()
            -- Disable automatic setup, we are doing it manually
            vim.g.lsp_zero_extend_cmp = 0
            vim.g.lsp_zero_extend_lspconfig = 0
        end,
    },
    {
        'williamboman/mason.nvim',
        lazy = false,
        config = true,
    },

    -- Autocompletion
    {
        'hrsh7th/nvim-cmp',
        event = 'InsertEnter',
        dependencies = {
            {'L3MON4D3/LuaSnip'},
        },
        config = function()
            local lsp_zero = require('lsp-zero')
            lsp_zero.extend_cmp()

            local cmp = require('cmp')
            local cmp_action = lsp_zero.cmp_action()

            cmp.setup({
                formatting = lsp_zero.cmp_format({details = true}),
                mapping = cmp.mapping.preset.insert({
                    ['<CR>'] = cmp.mapping.confirm({select = false}),
                    ['<C-Space>'] = cmp.mapping.complete(),
                    ['<C-u>'] = cmp.mapping.scroll_docs(-4),
                    ['<C-d>'] = cmp.mapping.scroll_docs(4),
                    ['<C-e>'] = cmp.mapping.close(),
                }),
                snippet = {
                    expand = function(args)
                        require('luasnip').lsp_expand(args.body)
                    end,
                },
            })
        end
    },

    -- LSP
    {
        'neovim/nvim-lspconfig',
        cmd = {'LspInfo', 'LspInstall', 'LspStart'},
        event = {'BufReadPre', 'BufNewFile'},
        dependencies = {
            {'hrsh7th/cmp-nvim-lsp'},
            {'williamboman/mason-lspconfig.nvim'},
        },
        config = function()
            local lsp_zero = require('lsp-zero')
            lsp_zero.extend_lspconfig()

            require('mason-lspconfig').setup({
                ensure_installed = {'angularls','tsserver','html', 'eslint','cssls', 'csharp_ls'},
                handlers = {
                    function(server_name)
                        require('lspconfig')[server_name].setup({})
                    end,
                    -- lua
                    lua_ls = function()
                        local lua_opts = lsp_zero.nvim_lua_ls()
                        require('lspconfig').lua_ls.setup(lua_opts)
                    end,
                    angularls = function()
                        local lsp_util = require('lspconfig.util');
                        require('lspconfig').angularls.setup({
                            root_dir = lsp_util.root_pattern('angular.json')
                        })
                    end,
                    -- typescript
                    tsserver = function()
                        local lsp_util = require('lspconfig.util');
                        
                        -- organize imports
                        local function organize_imports()
                            local params = {
                                command = "_typescript.organizeImports",
                                arguments = {vim.api.nvim_buf_get_name(0)},
                                title = ""
                            }
                            vim.lsp.buf.execute_command(params)
                        end

                        require('lspconfig').tsserver.setup({
                            init_options = {
                                preferences = {
                                    organizeImportsIgnoreCase = true,
                                    importModuleSpecifierPreference = 'project-relative',
                                }
                            },
                            on_attach = function(client, bufnr)
                                -- organize imports on save
                                vim.api.nvim_create_autocmd("BufWritePre", {
                                    callback = organize_imports,
                                })

                                -- keymaps for imports
                                vim.keymap.set('n', '<leader>ro', function()
                                    organize_imports()
                                end, { buffer = bufnr, remap = false, desc = "Organize Imports"})

                                vim.keymap.set('n', '<leader>ri', function()
                                    vim.lsp.buf.code_action({
                                        apply = true,
                                        context = {
                                            only = { 'source.addMissingImports.ts' },
                                            diagnostics = {},
                                        },
                                    })
                                end, { buffer = bufnr, remap = false, desc = "Add missing Imports"})

                            end
                        })
                    end
                }
            })
        end
    }
}
