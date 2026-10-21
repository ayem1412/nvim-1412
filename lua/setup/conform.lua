-- Biome: fast, but only for the file types it fully handles.
-- (It refuses HTML, skips Vue without a word, and markdown support depends on its version.)
local biome = { 'biome', 'prettierd', 'prettier', stop_after_first = true }
-- Prettier for everything else.
local prettier = { 'prettierd', 'prettier', stop_after_first = true }

require('conform').setup {
  formatters_by_ft = {
    lua = { 'stylua' },
    rust = { 'rustfmt' }, -- comes with rustup
    sh = { 'shfmt' },
    javascript = biome,
    typescript = biome,
    javascriptreact = biome,
    typescriptreact = biome,
    json = biome,
    jsonc = biome,
    css = biome,
    scss = prettier,
    vue = prettier,
    html = prettier,
    yaml = prettier,
    markdown = prettier,
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
