return {
    {
        'nvim-treesitter/nvim-treesitter',
        lazy = false,
        dependencies = {
            "nvim-treesitter/nvim-treesitter-textobjects",
            "JoosepAlviste/nvim-ts-context-commentstring",
        },
        event = { "BufReadPre", "BufNewFile" },
        build = ":TSUpdate",
        config = function()
            require('nvim-treesitter.configs').setup {
                -- Add languages to be installed here that you want installed for treesitter
                ensure_installed = { "lua", "typescript", "javascript", "markdown", "html", "css", "vimdoc", "diff", "xml", "json", "yaml", },

                highlight = {
                    enable = true, -- false will disable the whole extension
                },
                incremental_selection = {
                    enable = true,
                    keymaps = {
                        init_selection = "<c-=>",
                        node_incremental = "<c-=>",
                        scope_incremental = "<c-s>",
                        node_decremental = "<c-backspace>",
                    },
                },
                indent = {
                    enable = true,
                },
                textobjects = {
                    select = {
                        enable = true,
                        lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
                        keymaps = {
                            -- You can use the capture groups defined in textobjects.scm
                            ['aa'] = '@parameter.outer',
                            ['ia'] = '@parameter.inner',
                            ['af'] = '@function.outer',
                            ['if'] = '@function.inner',
                            ['ac'] = '@class.outer',
                            ['ic'] = '@class.inner',
                        },
                    },
                    move = {
                        enable = true,
                        set_jumps = true, -- whether to set jumps in the jumplist
                        goto_next_start = {
                            [']m'] = '@function.outer',
                            [']]'] = '@class.outer',
                        },
                        goto_next_end = {
                            [']M'] = '@function.outer',
                            [']['] = '@class.outer',
                        },
                        goto_previous_start = {
                            ['[m'] = '@function.outer',
                            ['[['] = '@class.outer',
                        },
                        goto_previous_end = {
                            ['[M'] = '@function.outer',
                            ['[]'] = '@class.outer',
                        },
                    },
                    swap = {
                        enable = true,
                        swap_next = {
                            ['<leader>a'] = '@parameter.inner',
                        },
                        swap_previous = {
                            ['<leader>A'] = '@parameter.inner',
                        },
                    },
                },
            }
        end,
    }
}
