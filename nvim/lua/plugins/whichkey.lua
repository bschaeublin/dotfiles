return {
    {
        "folke/which-key.nvim",
        event = "VeryLazy",
        opts = {
            delay = 300,
            icons = {
                separator = "→",
            },
            spec = {
                { "<leader>f", group = "Find" },
                { "<leader>g", group = "Go to" },
                { "<leader>r", group = "Refactor" },
                { "<leader>k", group = "Diagnostics" },
                { "<leader>s", group = "Switch" },
                { "<leader>d", group = "Document" },
                { "<leader>c", group = "Quickfix" },
            },
        },
    },
}
