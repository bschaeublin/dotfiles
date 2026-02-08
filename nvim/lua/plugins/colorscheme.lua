return {
  { 
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = false,
    priority = 1000,
    config = function(cfg)
       require("catppuccin").setup({
                flavour = 'macchiato',
                integrations = {
                    blink_cmp = true,
                    gitsigns = true,
                    treesitter = true,
                    snacks = true,
                    mason = true,
                    native_lsp = {
                        enabled = true,
                        virtual_text = {
                            errors = { "italic" },
                            hints = { "italic" },
                            warnings = { "italic" },
                            information = { "italic" },
                        },
                        underlines = {
                            errors = { "underline" },
                            hints = { "underline" },
                            warnings = { "underline" },
                            information = { "underline" },
                        },
                        inlay_hints = {
                            background = true,
                        },
                    },
                }
        })

       -- setup must be called before loading
       vim.cmd.colorscheme "catppuccin"
    end,
  },
}
