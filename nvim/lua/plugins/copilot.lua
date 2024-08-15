return {
    {
        "zbirenbaum/copilot.lua",
        cmd = "Copilot",
        event = "InsertEnter",
        config = function()
            require("copilot").setup({
                suggestion = {
                    auto_trigger = true,
                    keymap = {
                        accept = "<M-l>",
                        next = "<M-j>",
                        prev = "<M-k>",
                    }
                }
            })
        end,
        -- enabled = function()
        --     -- -- only run in private setup
        --     -- return vim.fn.hostname() == 'DESKTOP-F76LQQS'
        -- end,
    }
}
