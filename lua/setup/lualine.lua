-- Slanted statusline (same slant shape as the tabs at the top)
local SL, SR = '\u{e0bc}', '\u{e0ba}' -- slants for the left / right sections

local mode_icons = {
  NORMAL = '\u{e7c5}', -- vim logo
  INSERT = '\u{f040}',
  VISUAL = '\u{f0489}',
  ['V-LINE'] = '\u{f0489}',
  ['V-BLOCK'] = '\u{f0489}',
  COMMAND = '\u{f120}',
  TERMINAL = '\u{f489}',
  REPLACE = '\u{f0b9b}',
}

local function mode()
  local m = require('lualine.utils.mode').get_mode()
  return (mode_icons[m] or '\u{e7c5}') .. ' ' .. m
end

-- Shows "@q" while you record a macro
local function recording()
  local reg = vim.fn.reg_recording()
  return reg ~= '' and '\u{f044a} @' .. reg or ''
end

local function lsp_names()
  local names = {}
  for _, c in ipairs(vim.lsp.get_clients { bufnr = 0 }) do
    table.insert(names, c.name)
  end
  return #names > 0 and '\u{f085} ' .. table.concat(names, ' ') or ''
end

local function dap_status()
  if not package.loaded['dap'] then return '' end
  local s = require('dap').status()
  return s ~= '' and '\u{f188} ' .. s or ''
end

-- Theme: tokyonight, but with a see-through middle so the bubbles stand out
local theme = require 'lualine.themes.tokyonight'
for _, m in pairs(theme) do
  if m.c then m.c.bg = 'NONE' end
end

require('lualine').setup {
  options = {
    theme = theme,
    globalstatus = true,
    component_separators = '',
    section_separators = { left = SL, right = SR },
    disabled_filetypes = { statusline = { 'snacks_dashboard' } },
  },
  sections = {
    lualine_a = { mode },
    lualine_b = {
      { 'branch', icon = '\u{e725}' },
    },
    lualine_c = {
      { 'diff', symbols = { added = '\u{f457} ', modified = '\u{f459} ', removed = '\u{f458} ' } },
      { 'filetype', icon_only = true, separator = '', padding = { left = 1, right = 0 } },
      { 'filename', path = 1, symbols = { modified = ' \u{25cf}', readonly = ' \u{f023}', unnamed = '[No Name]' } },
      { recording, color = { fg = '#ff9e64', gui = 'bold' } },
    },
    lualine_x = {
      {
        'diagnostics',
        symbols = { error = '\u{f057} ', warn = '\u{f071} ', info = '\u{f05a} ', hint = '\u{f0eb} ' },
      },
      { dap_status, color = { fg = '#ff9e64' } },
      { lsp_names, color = { fg = '#7aa2f7' } },
    },
    lualine_y = {
      { 'progress', padding = { left = 1, right = 0 } },
      { 'location', padding = { left = 1, right = 1 } },
    },
    lualine_z = {
      function() return '\u{f017} ' .. os.date '%H:%M' end,
    },
  },
  extensions = { 'lazy', 'quickfix', 'nvim-dap-ui', 'trouble' },
}
