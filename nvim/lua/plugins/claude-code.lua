return {
    {
        'coder/claudecode.nvim',
        dependencies = { 'folke/snacks.nvim' },
        config = true,
        keys = {
            { '<leader>ac', '<cmd>ClaudeCode<cr>', desc = 'Toggle Claude' },
            { '<leader>af', '<cmd>ClaudeCodeFocus<cr>', desc = 'Focus Claude' },
            { '<leader>as', '<cmd>ClaudeCodeSend<cr>', mode = 'v', desc = 'Send to Claude' },
            { '<leader>as', '<cmd>ClaudeCodeTreeAdd<cr>', desc = 'Add file', ft = { 'oil' } },
            { '<leader>aa', '<cmd>ClaudeCodeDiffAccept<cr>', desc = 'Accept diff' },
            { '<leader>ad', '<cmd>ClaudeCodeDiffDeny<cr>', desc = 'Deny diff' },
            { '<leader>ab', '<cmd>ClaudeCodeAdd %<cr>', desc = 'Add current buffer' },
        },
    },
}
