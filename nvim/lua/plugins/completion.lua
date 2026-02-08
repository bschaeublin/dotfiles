return {
    {
        'saghen/blink.cmp',
        version = '1.*',
        dependencies = { 'rafamadriz/friendly-snippets' },
        event = 'InsertEnter',
        opts = {
            keymap = {
                preset = 'none',
                ['<CR>'] = { 'accept', 'fallback' },
                ['<C-Space>'] = { 'show' },
                ['<C-u>'] = { 'scroll_documentation_up' },
                ['<C-d>'] = { 'scroll_documentation_down' },
                ['<C-e>'] = { 'cancel' },
                ['<C-n>'] = { 'select_next', 'fallback' },
                ['<C-p>'] = { 'select_prev', 'fallback' },
            },
            sources = {
                default = { 'lsp', 'path', 'snippets', 'buffer' },
            },
            completion = {
                documentation = { auto_show = true },
            },
        },
    },
}
