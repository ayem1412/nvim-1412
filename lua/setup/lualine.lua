local function dap_status() return '\u{f188} ' .. require('dap').status() end

local function lsp_names()
  local clients = vim.lsp.get_clients { bufnr = 0 }
  if #clients == 0 then return '' end
  return '\u{f085} ' .. table.concat(vim.tbl_map(function(c) return c.name end, clients), ',')
end

require('lualine').setup {
  options = {
    theme = 'tokyonight',
    globalstatus = true,
    component_separators = { left = '\u{e0b1}', right = '\u{e0b3}' },
    section_separators = { left = '\u{e0b0}', right = '\u{e0b2}' },
    disabled_filetypes = { statusline = { 'snacks_dashboard' } },
  },
  sections = {
    lualine_a = { 'mode' },
    lualine_b = { 'branch' },
    lualine_c = {
      { 'diagnostics', symbols = { error = '\u{f057} ', warn = '\u{f071} ', info = '\u{f05a} ', hint = '\u{f0eb} ' } },
      { 'filetype', icon_only = true, separator = '', padding = { left = 1, right = 0 } },
      { 'filename', path = 1, symbols = { modified = ' \u{f040}', readonly = ' \u{f023}', unnamed = '[No Name]' } },
    },
    lualine_x = {
      { dap_status, cond = function() return package.loaded['dap'] and require('dap').status() ~= '' end },
      { 'diff', symbols = { added = '\u{f457} ', modified = '\u{f459} ', removed = '\u{f458} ' } },
      { lsp_names },
    },
    lualine_y = {
      { 'progress', separator = ' ', padding = { left = 1, right = 0 } },
      { 'location', padding = { left = 0, right = 1 } },
    },
    lualine_z = { function() return '\u{f017} ' .. os.date '%R' end },
  },
  extensions = { 'lazy', 'quickfix', 'nvim-dap-ui' },
}
