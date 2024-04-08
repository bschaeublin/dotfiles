--- @param trunc_width number trunctates component when screen width is less then trunc_width
--- @param trunc_len number truncates component to trunc_len number of chars
--- @param hide_width number hides component when window width is smaller then hide_width
--- @param no_ellipsis boolean whether to disable adding '...' at end after truncation
--- return function that can format the component accordingly
local function trunc(trunc_width, trunc_len, hide_width, no_ellipsis)
    return function(str)
        local win_width = vim.fn.winwidth(0)
        if hide_width and win_width < hide_width then return ''
        elseif trunc_width and trunc_len and win_width < trunc_width and #str > trunc_len then
            return str:sub(1, trunc_len) .. (no_ellipsis and '' or '...')
        end
        return str
    end
end

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
            lualine_b = { "buffers" },
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
            lualine_b = {
                {
                    "branch",
                    fmt = trunc(150,50,nil),
                }
            },
            lualine_c = { 
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
            lualine_x = {},
            lualine_y = { "fileformat", "filetype" },
            lualine_z = { "location", "progress" },
        },
    },
}
