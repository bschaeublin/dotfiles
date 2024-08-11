return {
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
            local cmp = require('cmp')

            cmp.setup({
                sources = {
                    {name = 'nvim_lsp'},
                },
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

            local lsp_capabilities = require('cmp_nvim_lsp').default_capabilities()

            local default_setup = function(server)
                require('lspconfig')[server].setup({
                    capabilities = lsp_capabilities,
                })
            end

            require('mason-lspconfig').setup({
                ensure_installed = {'angularls', 'html', 'lua_ls', 'eslint','cssls', 'csharp_ls'},
                handlers = {
                    default_setup,
                    -- lua
                    lua_ls = function()
                        require('lspconfig').lua_ls.setup({ capabilities = lsp_capabilities })
                    end,
                    eslint = function()
                        require('lspconfig').eslint.setup({
                            capabilities = lsp_capabilities,
                            filetypes = {
                                'javascript',
                                'javascriptreact',
                                'javascript.jsx',
                                'typescript',
                                'typescriptreact',
                                'typescript.tsx',
                                'vue',
                                'svelte',
                                'astro',
                                'html'
                            },
                        })
                    end,
                    -- angular
                    angularls = function()
                        local lsp_util = require('lspconfig.util');
                        require('lspconfig').angularls.setup({
                            capabilities = lsp_capabilities,
                            root_dir = lsp_util.root_pattern('angular.json')
                        })
                    end
                }
            })
        end
    },
    -- TypeScript
    {
        "pmizio/typescript-tools.nvim",
        dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
        ft = { "typescript", "typescriptreact" },
        event = { "BufReadPre", "BufNewFile" },
        config = function()
            require("typescript-tools").setup({
                capabilities = lsp_capabilities,
                on_attach = function(_, bufnr)
                    vim.keymap.set("n", "<leader>ro", "<cmd>TSToolsOrganizeImports<cr>", { buffer = bufnr, remap = false, desc = "Organize Imports" })
                    vim.keymap.set("n", "<leader>ri", "<cmd>TSToolsAddMissingImports<cr>", { buffer = bufnr, remap = false, desc = "Add Missing Imports" })

                    vim.api.nvim_create_autocmd("BufWritePre", {
                        pattern = "*.ts*",
                        command = ":TSToolsOrganizeImports sync",
                    })
                end,
                 settings = {
                    tsserver_file_preferences = {
                        organizeImportsIgnoreCase = true,
                        importModuleSpecifierPreference = 'project-relative',
                    },
                },
            })
       end,
    }
}
