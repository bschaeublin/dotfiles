return {
    {
        'zbirenbaum/copilot.lua',
        cmd = 'Copilot',
        event = 'InsertEnter',
        opts = {
            suggestion = {
                auto_trigger = true,
                keymap = {
                    accept = '<M-l>',
                    next = '<M-j>',
                    prev = '<M-k>',
                },
            },
        },
    },
}
