local web = { 'prettierd', 'prettier', stop_after_first = true }

require('conform').setup {
  formatters_by_ft = {
    lua = { 'stylua' },
    rust = { 'rustfmt' }, -- comes with rustup
    sh = { 'shfmt' },
    javascript = web,
    typescript = web,
    javascriptreact = web,
    typescriptreact = web,
    vue = web,
    html = web,
    css = web,
    scss = web,
    json = web,
    jsonc = web,
    yaml = web,
    markdown = web,
    -- java and php: no format on save (legacy code, keeps diffs small). <leader>cf formats via LSP.
  },
  default_format_opts = { lsp_format = 'fallback' },
  format_on_save = function(bufnr)
    if not vim.g.autoformat or vim.b[bufnr].autoformat == false then return end
    local ft = vim.bo[bufnr].filetype
    if ft == 'java' or ft == 'php' or ft == 'sql' then return end
    return { timeout_ms = 1000, lsp_format = 'fallback' }
  end,
}
