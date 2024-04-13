return {
    {
        'pwntester/octo.nvim',
        event = "VeryLazy",
        requires = {
            'nvim-lua/plenary.nvim',
            'nvim-telescope/telescope.nvim',
            'nvim-tree/nvim-web-devicons',
        },
        config = function ()
            require "octo".setup({
                 mappings_disable_default = true,
            })
        end
    }
}
