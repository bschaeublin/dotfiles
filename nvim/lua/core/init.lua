require 'core.settings'

-- Set leader key to space
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

require 'core.lazy'
require 'core.keymaps'
require 'core.autocmds'
