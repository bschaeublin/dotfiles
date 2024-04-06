return {
    {
        'nvimdev/dashboard-nvim',
        event = 'VimEnter',
        opts = {
            theme = 'hyper',
            config = {
                week_header = {
                    enable = true,
                },
                shortcut = {
                    { 
                        desc = '󰊳 Update',
                        group = '@property',
                        action = 'Lazy update',
                        key = 'u'
                    },
                    {
                        icon = ' ',
                        icon_hl = '@variable',
                        desc = 'Files',
                        group = 'Label',
                        action = 'Telescope find_files',
                        key = 'f',
                    },
                    {
                        desc = '🖹 Config',
                        group = 'Number',
                        action = 'e ~/AppData/Local/nvim/init.lua',
                        key = 'e',
                    },
                    {
                        desc = '⌨ Keymap',
                        group = 'Number',
                        action = 'e ~/AppData/Local/nvim/lua/core/keymaps.lua',
                        key = 's',
                    },
                },
                footer = {}, -- footer
            },
        },
        config = function(_, opts)
            require('dashboard').setup(opts)
        end,
    },
}
