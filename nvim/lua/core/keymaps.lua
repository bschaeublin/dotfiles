-- Move between split / vsplt panels
vim.keymap.set('n', '<C-h>', '<C-w>h', { desc = "Jump to left panel", remap = true })
vim.keymap.set('n', '<C-j>', '<C-w>j', { desc = "Jump to lower panel", remap = true })
vim.keymap.set('n', '<C-k>', '<C-w>k', { desc = "Jump to upper panel", remap = true })
vim.keymap.set('n', '<C-l>', '<C-w>l', { desc = "Jump to right panel", remap = true })

-- buffers
vim.keymap.set("n", "<A-h>", "<cmd>bprevious<cr>", { desc = "Prev Buffer", silent = true })
vim.keymap.set("n", "<A-l>", "<cmd>bnext<cr>", { desc = "Next Buffer", silent = true })
vim.keymap.set("n", "<A-q>", "<cmd>bd<cr>", { desc = "Close Buffer", silent = true })

-- Scroll up and down
vim.keymap.set("n", "U", "<c-u>zz")
vim.keymap.set("n", "D", "<c-d>zz")

-- Scroll while Search
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- better indenting
vim.keymap.set("v", "<", "<gv")
vim.keymap.set("v", ">", ">gv")

-- Move selected block up / down
vim.keymap.set('v', 'J', ':m \'>+1<CR>gv=gv', { desc = "Move block down"})
vim.keymap.set('v', 'K', ':m \'<-2<CR>gv=gv', { desc = "Move block up"})

-- LSP Bindings
require('lsp-zero').on_attach(function(client, bufnr)
    local attach_opts = { buffer = bufnr, remap = false }
    -- Diagnostics mappings
    vim.keymap.set('n', '<leader>k', function()
    	vim.lsp.diagnostic.open_float(0, { scope='line' })
    end, vim.tbl_extend('error', attach_opts, { desc = '[LSP] Open diagnostics'}))
    vim.keymap.set('n', '<leader>kn', function()
        vim.lsp.diagnostic.goto_next()
    end, vim.tbl_extend('error', attach_opts, { desc = '[LSP] Next diagnostic'}))
    vim.keymap.set('n', '<leader>kp', function()
        vim.lsp.diagnostic.goto_prev()
    end, vim.tbl_extend('error', attach_opts, { desc = '[LSP] Previous diagnostic'}))

    -- Code navigation and Discovering
    vim.keymap.set('n', '<leader>gi', function()
        vim.lsp.buf.implementation()
    end, vim.tbl_extend('error', attach_opts, { desc = '[LSP] [G]o to [i]mplementation'}))
    vim.keymap.set('n', '<leader>gD',  function()
        vim.lsp.buf.declaration()
    end, vim.tbl_extend('error', attach_opts, { desc = '[LSP] [G]o to [D]eclaration'}))
    vim.keymap.set('n', '<leader>gd',  function()
        vim.lsp.buf.definition()
    end, vim.tbl_extend('error', attach_opts, { desc = '[LSP] [G]o to [d]efinition'}))
    vim.keymap.set('n', '<leader>gr', function()
        vim.lsp.buf.references()
    end, vim.tbl_extend('error', attach_opts, { desc = '[LSP] Find References'}))
    vim.keymap.set('n', '<leader>gh', function()
        vim.lsp.buf.hover()
    end, vim.tbl_extend('error', attach_opts, { desc = '[LSP] Hover'}))
    vim.keymap.set('n', '<leader>gH', function()
        vim.lsp.buf.signature_help()
    end, vim.tbl_extend('error', attach_opts, { desc = '[LSP] Signature Help'}))

    -- Refactorings
    vim.keymap.set('n', '<leader>rr', function()
        vim.lsp.buf.rename()
    end, vim.tbl_extend('error', attach_opts, { desc = '[LSP] [R]ename [r]efac otor'}))
    vim.keymap.set('n', '<leader>.', function()
        vim.lsp.buf.code_action()
    end, vim.tbl_extend('error', attach_opts, { desc = '[LSP] Code action'}))
    vim.keymap.set('n', '<leader>rf', function()
        vim.lsp.buf.formatting()
    end, vim.tbl_extend('error', attach_opts, { desc = '[LSP] [R]e[f]ormat'}))

    vim.keymap.set('n', '<leader>cn', ':cnext<CR>')
    vim.keymap.set('n', '<leader>cp', ':cprev<CR>')
end)

-- Telescope
vim.keymap.set('n', '<leader>f?', require('telescope.builtin').oldfiles, { desc = "[?] Find recently opened files" })
vim.keymap.set('n', '<leader>ff', function()
	require('telescope.builtin').find_files({ hidden = true })
end, { desc = "[F]ind [F]iles" })
vim.keymap.set('n', '<leader>fg', function()
	require('telescope.builtin').live_grep({ 
        glob_pattern= "!package-lock.json",
        additional_args = { "--hidden" }
    })
end, { desc = "[F]ind by [G]rep" })
vim.keymap.set('n', '<leader>fb', require('telescope.builtin').buffers, { desc = "[F]ind [B]uffers" })
vim.keymap.set('n', '<leader>fb', require('telescope.builtin').git_branches, { desc = "[F]ind [B]ranches" })
vim.keymap.set('n', '<leader>ds', require('telescope.builtin').lsp_document_symbols, { desc = "[D]ocument [S]ymbols" })

-- Angular
vim.keymap.set('n', '<leader>st', ':e %:r.ts<CR>', { desc = "Switch to Component", silent = true })
vim.keymap.set('n', '<leader>sh', ':e %:r.html<CR>', { desc = "Switch to HTML", silent = true })
vim.keymap.set('n', '<leader>sc', ':e %:r.scss<CR>', { desc = "Switch to SCSS", silent = true })

-- Oil
vim.keymap.set('n', '<leader>o', ':Oil --float<CR>', { desc = "Open Parent Directory", silent = true })

-- FTerm
vim.keymap.set('n', '<A-i>', require('FTerm').toggle, { desc = "Show Floating Terminal" })
vim.keymap.set('t', '<A-i>', '<C-\\><C-n>:lua require("FTerm").toggle()<CR>', { desc = "Close Floating Terminal" })

-- Surround
vim.keymap.set('n', '<leader>)', 'ysiw)', { desc = "Surround with Parentheses" })
vim.keymap.set('n', '<leader>}', 'ysiw}', { desc = "Surround with Curly Braces" })
vim.keymap.set('n', '<leader>]', 'ysiw]', { desc = "Surround with Square Brackets" })
