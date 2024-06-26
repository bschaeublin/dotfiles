return {
    "nvim-tree/nvim-tree.lua",
    lazy = false,
    dependencies = {
        "nvim-tree/nvim-web-devicons",
    },
    opts = {
        view = {
            side = "right",
            width = 40,
        },
        actions = {
            open_file = {
                window_picker = {
                    enable = false,
                },
            },
        },
    },
    config = function(_, opts)
        -- Recommended settings to disable default netrw file explorer
        vim.g.loaded_netrw = 1
        vim.g.loaded_netrwPlugin = 1
        require("nvim-tree").setup(opts)
    end,
}
