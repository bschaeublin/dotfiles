return {
    {
        'williamboman/mason.nvim',
        lazy = false,
        config = function()
            require('mason').setup({
                registries = {
                    'github:mason-org/mason-registry',
                    'github:Crashdummyy/mason-registry',
                },
            })
        end,
    },
    {
        'williamboman/mason-lspconfig.nvim',
        dependencies = { 'williamboman/mason.nvim', 'neovim/nvim-lspconfig' },
        config = function()
            require('mason-lspconfig').setup({
                ensure_installed = { 'angularls', 'html', 'lua_ls', 'eslint', 'cssls', 'ts_ls', 'pyright', 'ruff' },
                automatic_enable = true,
            })
        end,
    },
    {
        'pmizio/typescript-tools.nvim',
        dependencies = { 'nvim-lua/plenary.nvim', 'neovim/nvim-lspconfig' },
        ft = { 'typescript', 'typescriptreact' },
        config = function()
            require('typescript-tools').setup({
                on_attach = function(_, bufnr)
                    vim.keymap.set('n', '<leader>ro', '<cmd>TSToolsOrganizeImports<cr>', { buffer = bufnr, desc = 'Organize Imports' })
                    vim.keymap.set('n', '<leader>ri', '<cmd>TSToolsAddMissingImports<cr>', { buffer = bufnr, desc = 'Add Missing Imports' })
                    vim.api.nvim_create_autocmd('BufWritePre', {
                        pattern = '*.ts*',
                        command = ':TSToolsOrganizeImports sync',
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
    },
}
