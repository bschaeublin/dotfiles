return {
    "nvim-lualine/lualine.nvim",
    lazy = false,
    opts = {
        options = {
            theme = "catppuccin",
            globalstatus = true,
            disabled_filetypes = { statusline = { 'dashboard' }}
        },
        sections = {
            lualine_a = { "mode" },
            lualine_b = { 
                {
                    "filename",
                    symbols = {
                        modified = "󰧞",
                        readonly = "",
                        new = "",
                        unnamed = "",
                    },
                }
            },
            lualine_c = {},
            lualine_x = {},
            lualine_y = {},
            lualine_z = {
                {
                    "diagnostics",
                    sources = { 'nvim_lsp'},
                    symbols = { error = " ", warn = " ", info = " ", hint = " ",},
                    colored = false,
                }
            },
        },
        inactive_sections = {
            lualine_a = {},
            lualine_b = {},
            lualine_c = { "filename" },
            lualine_x = { "location" },
            lualine_y = {},
            lualine_z = {},
        },
        tabline = {      
            lualine_b = {"branch"},
            lualine_c = { "buffers" 
            },
            lualine_x = {},
            lualine_y = { "fileformat", "filetype" },
            lualine_z = { "location", "progress" },
        },
    },
}
