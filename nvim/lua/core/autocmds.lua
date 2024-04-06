local function augroup(name)
  return vim.api.nvim_create_augroup(name, { clear = true })
end

-- resize splits if window got resized
vim.api.nvim_create_autocmd({ "VimResized" }, {
  group = augroup("resize_splits"),
  callback = function()
    local current_tab = vim.fn.tabpagenr()
    vim.cmd("tabdo wincmd =")
    vim.cmd("tabnext " .. current_tab)
  end,
})

-- close some filetypes with ESC
vim.api.nvim_create_autocmd("FileType", {
  group = augroup("close_with_esc"),
  pattern = {
    "help",
    "dap-float",
    "lspinfo",
    "checkhealth",
    "oil",
  },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.keymap.set("n", "<ESC>", "<cmd>close<cr>", { buffer = event.buf, silent = true })
  end,
})

 -- Autoformat autocmd
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*",
  callback = function(args)
    require("conform").format({ bufnr = args.buf })
  end,
})


