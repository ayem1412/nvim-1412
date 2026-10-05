local function augroup(name)
  return vim.api.nvim_create_augroup("cfg_" .. name, { clear = true })
end

-- Highlight on yank
vim.api.nvim_create_autocmd("TextYankPost", {
  group = augroup("highlight_yank"),
  callback = function() vim.hl.on_yank() end,
})

-- Resize splits when the window is resized
vim.api.nvim_create_autocmd("VimResized", {
  group = augroup("resize_splits"),
  callback = function()
    local tab = vim.fn.tabpagenr()
    vim.cmd("tabdo wincmd =")
    vim.cmd("tabnext " .. tab)
  end,
})

-- Go back to the last cursor position when opening a file
vim.api.nvim_create_autocmd("BufReadPost", {
  group = augroup("last_loc"),
  callback = function(ev)
    local exclude = { gitcommit = true }
    local buf = ev.buf
    if exclude[vim.bo[buf].filetype] or vim.b[buf].last_loc_done then return end
    vim.b[buf].last_loc_done = true
    local mark = vim.api.nvim_buf_get_mark(buf, '"')
    local lcount = vim.api.nvim_buf_line_count(buf)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

-- Close some filetypes with <q>
vim.api.nvim_create_autocmd("FileType", {
  group = augroup("close_with_q"),
  pattern = { "help", "lspinfo", "man", "qf", "query", "checkhealth", "dap-float", "dbout" },
  callback = function(ev)
    vim.bo[ev.buf].buflisted = false
    vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = ev.buf, silent = true })
  end,
})

-- Create missing directories when saving a file
vim.api.nvim_create_autocmd("BufWritePre", {
  group = augroup("auto_create_dir"),
  callback = function(ev)
    if ev.match:match("^%w%w+:[\\/][\\/]") then return end
    local file = vim.uv.fs_realpath(ev.match) or ev.match
    vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
  end,
})

-- Per-filetype indentation
vim.api.nvim_create_autocmd("FileType", {
  group = augroup("indent"),
  pattern = { "lua", "javascript", "typescript", "javascriptreact", "typescriptreact", "vue", "html", "css", "scss", "json", "jsonc", "yaml" },
  callback = function()
    vim.bo.shiftwidth = 2
    vim.bo.tabstop = 2
    vim.bo.softtabstop = 2
  end,
})
