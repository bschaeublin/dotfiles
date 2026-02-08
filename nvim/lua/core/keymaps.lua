-- Move between split / vsplt panels
vim.keymap.set('n', '<C-h>', '<C-w>h', { desc = "Jump to left panel", remap = true })
vim.keymap.set('n', '<C-j>', '<C-w>j', { desc = "Jump to lower panel", remap = true })
vim.keymap.set('n', '<C-k>', '<C-w>k', { desc = "Jump to upper panel", remap = true })
vim.keymap.set('n', '<C-l>', '<C-w>l', { desc = "Jump to right panel", remap = true })
vim.keymap.set('t', '<C-h>', '<C-\\><C-n><C-w>h', { desc = "Jump to left panel from terminal" })
vim.keymap.set('t', '<C-j>', '<C-\\><C-n><C-w>j', { desc = "Jump to lower panel from terminal" })
vim.keymap.set('t', '<C-k>', '<C-\\><C-n><C-w>k', { desc = "Jump to upper panel from terminal" })
vim.keymap.set('t', '<C-l>', '<C-\\><C-n><C-w>l', { desc = "Jump to right panel from terminal" })

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

vim.keymap.set({ "i", "x", "n", "s" }, "<C-s>", "<cmd>w<cr><esc>", { desc = "Save File" })

-- LSP Bindings
vim.api.nvim_create_autocmd('LspAttach', {
    desc = 'LSP Actions',
    callback = function(event)
        local attach_opts = { buffer = event.buf, remap = false }
        -- Diagnostics mappings
        vim.keymap.set('n', '<leader>k', function()
            vim.diagnostic.open_float({ scope = 'line' })
        end, vim.tbl_extend('error', attach_opts, { desc = '[LSP] Open diagnostics'}))
        vim.keymap.set('n', '<leader>kn', function()
            vim.diagnostic.goto_next()
        end, vim.tbl_extend('error', attach_opts, { desc = '[LSP] Next diagnostic'}))
        vim.keymap.set('n', '<leader>kp', function()
            vim.diagnostic.goto_prev()
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
            local prompt_opts = {
                prompt = "New Name: ",
                default = vim.fn.expand("<cword>"),
            }
            vim.ui.input(prompt_opts, function(input)
            if not input or #input == 0 then
              return
            end

            vim.lsp.buf.rename(input)
            end)
        end, vim.tbl_extend('error', attach_opts, { desc = '[LSP] [R]ename [r]efac otor'}))
        vim.keymap.set('n', '<leader>.', function()
            vim.lsp.buf.code_action()
        end, vim.tbl_extend('error', attach_opts, { desc = '[LSP] Code action'}))
        vim.keymap.set('n', '<leader>rf', function()
            vim.lsp.buf.format()
        end, vim.tbl_extend('error', attach_opts, { desc = '[LSP] [R]e[f]ormat'}))

        vim.keymap.set('n', '<leader>cn', ':cnext<CR>')
        vim.keymap.set('n', '<leader>cp', ':cprev<CR>')

    end
})

-- Snacks Picker
vim.keymap.set('n', '<leader>f?', function() Snacks.picker.recent() end, { desc = "Find recently opened files" })
vim.keymap.set('n', '<leader>ff', function() Snacks.picker.files({ hidden = true }) end, { desc = "Find Files" })
vim.keymap.set('n', '<leader>fg', function() Snacks.picker.grep({ hidden = true }) end, { desc = "Find by Grep" })
vim.keymap.set('n', '<leader>fb', function() Snacks.picker.buffers() end, { desc = "Find Buffers" })
vim.keymap.set('n', '<leader>fB', function() Snacks.picker.git_branches() end, { desc = "Find Branches" })
vim.keymap.set('n', '<leader>ds', function() Snacks.picker.lsp_symbols() end, { desc = "Document Symbols" })

-- Angular
vim.keymap.set('n', '<leader>st', ':e %:r.ts<CR>', { desc = "Switch to Component", silent = true })
vim.keymap.set('n', '<leader>sh', ':e %:r.html<CR>', { desc = "Switch to HTML", silent = true })
vim.keymap.set('n', '<leader>sc', ':e %:r.scss<CR>', { desc = "Switch to SCSS", silent = true })

-- Oil
vim.keymap.set('n', '<leader>o', ':Oil --float<CR>', { desc = "Open Parent Directory", silent = true })
vim.keymap.set('n', '<F5>', '<C-l>', { desc = "Refresh Oil", silent = true, remap = true })

-- Terminal
vim.keymap.set('n', '<A-i>', function() Snacks.terminal.toggle() end, { desc = "Toggle Floating Terminal" })
vim.keymap.set('t', '<A-i>', function() Snacks.terminal.toggle() end, { desc = "Toggle Floating Terminal" })

-- Surround
vim.keymap.set('n', '<leader>)', 'ysiw)', { desc = "Surround with Parentheses" })
vim.keymap.set('n', '<leader>}', 'ysiw}', { desc = "Surround with Curly Braces" })
vim.keymap.set('n', '<leader>]', 'ysiw]', { desc = "Surround with Square Brackets" })

