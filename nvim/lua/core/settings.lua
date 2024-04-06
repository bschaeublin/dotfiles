-- highlight line the cursor is in
vim.opt.cursorline = true
vim.opt.cursorlineopt = 'screenline'

-- show line numbers
vim.opt.nu = true
vim.opt.relativenumber = true

--Set highlight on search
vim.o.hlsearch = false

-- Search
vim.o.incsearch = true -- starts searching as soon as typing, without enter needed
vim.o.ignorecase = true -- ignore letter case when searching
vim.o.smartcase = true -- case insentive unless capitals used in searcher

-- keep visited buffers open
vim.opt.hidden = true

-- mute vim
vim.opt.errorbells = false

-- disable word wrap
vim.opt.wrap = false

-- tab behavior
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.smartindent = true

-- no backup/autosave files
vim.opt.swapfile = false
vim.opt.backup = false

-- when scrolling keep distance to edge of screen
vim.opt.scrolloff = 8
vim.opt.sidescrolloff = 8

-- rulers
vim.opt.colorcolumn = "140"

-- keep a side column for addons
vim.opt.signcolumn = "no"

-- more space for displaying messages
vim.opt.cmdheight = 1

-- dont show mode in cmdline
vim.opt.showmode = false

-- short update time (default is 4000ms)
vim.opt.updatetime = 50

-- Set completeopt to have a better completion experience
vim.o.completeopt = 'menu,menuone,noselect'

--Set colorscheme (order is important here)
vim.o.termguicolors = true

-- Show virtual text
vim.diagnostic.config({virtual_text = true})
