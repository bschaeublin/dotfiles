return {
    {
        'github/copilot.vim',
        event = 'InsertEnter',
        enabled = function()
            -- only run in private setup
            return vim.fn.hostname() == 'DESKTOP-F76LQQS'
        end,
    }
}
