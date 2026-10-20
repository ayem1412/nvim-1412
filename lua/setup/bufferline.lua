local bufferline = require 'bufferline'
local groups = require 'bufferline.groups'

local icons = { error = '\u{f057} ', warning = '\u{f071} ' }

bufferline.setup {
  options = {
    mode = 'buffers',
    separator_style = 'slant',
    indicator = { style = 'none' },
    always_show_bufferline = true,
    show_close_icon = false,
    show_buffer_close_icons = true,
    modified_icon = '\u{25cf}',
    -- Small position number on each tab (matches Alt+1..9)
    numbers = function(o) return o.raise(o.ordinal) end,
    -- Error / warning count on the tab
    diagnostics = 'nvim_lsp',
    diagnostics_indicator = function(_, _, diag)
      local s = {}
      if diag.error then table.insert(s, icons.error .. diag.error) end
      if diag.warning then table.insert(s, icons.warning .. diag.warning) end
      return table.concat(s, ' ')
    end,
    -- Mouse: left click opens, middle click closes, right click pins / unpins
    close_command = function(n) Snacks.bufdelete(n) end,
    middle_mouse_command = function(n) Snacks.bufdelete(n) end,
    right_mouse_command = function(n)
      vim.api.nvim_set_current_buf(n)
      vim.cmd 'BufferLineTogglePin'
    end,
    hover = { enabled = true, delay = 120, reveal = { 'close' } },
    -- Pinned tabs stay on the left with a pin icon
    groups = { items = { groups.builtin.pinned:with { icon = '\u{f435}' } } },
    -- Leave room above the file explorer
    offsets = {
      { filetype = 'snacks_layout_box', text = '\u{f07b} Explorer', highlight = 'Directory', separator = true },
    },
  },
}
