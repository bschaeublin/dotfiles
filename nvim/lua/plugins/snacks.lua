return {
    {
        'folke/snacks.nvim',
        priority = 1000,
        lazy = false,
        opts = {
            picker = {
                layout = 'vertical',
                hidden = true,
            },
            terminal = {
                win = {
                    height = 0.7,
                    width = 0.6,
                    border = 'rounded',
                },
            },
            dashboard = {
                sections = {
                    { section = 'header' },
                    { icon = ' ', title = 'Recent Files', section = 'recent_files', indent = 2, padding = 1 },
                    { icon = ' ', title = 'Projects', section = 'projects', indent = 2, padding = 1 },
                    { section = 'startup' },
                },
            },
        },
    },
}
