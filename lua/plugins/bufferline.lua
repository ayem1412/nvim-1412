-- Tabs at the top (one per open file)
local keys = {
  { '<A-.>', '<cmd>BufferLineCycleNext<cr>', desc = 'Next tab' },
  { '<A-,>', '<cmd>BufferLineCyclePrev<cr>', desc = 'Prev tab' },
  { '<S-l>', '<cmd>BufferLineCycleNext<cr>', desc = 'Next tab' },
  { '<S-h>', '<cmd>BufferLineCyclePrev<cr>', desc = 'Prev tab' },
  { '<A-Right>', '<cmd>BufferLineMoveNext<cr>', desc = 'Move tab right' },
  { '<A-Left>', '<cmd>BufferLineMovePrev<cr>', desc = 'Move tab left' },
  { '<A-0>', '<cmd>BufferLineGoToBuffer -1<cr>', desc = 'Go to last tab' },
  { '<A-p>', '<cmd>BufferLineTogglePin<cr>', desc = 'Pin / unpin tab' },
  { '<A-n>', '<cmd>enew<cr>', desc = 'New empty tab' },
  { '<A-x>', function() Snacks.bufdelete() end, desc = 'Close tab' },
  { '<leader>bp', '<cmd>BufferLinePick<cr>', desc = 'Pick tab' },
  { '<leader>bl', '<cmd>BufferLineCloseLeft<cr>', desc = 'Close tabs to the left' },
  { '<leader>br', '<cmd>BufferLineCloseRight<cr>', desc = 'Close tabs to the right' },
}
for i = 1, 9 do
  table.insert(keys, { '<A-' .. i .. '>', '<cmd>BufferLineGoToBuffer ' .. i .. '<cr>', desc = 'Go to tab ' .. i })
end

return {
  'akinsho/bufferline.nvim',
  version = '*',
  event = 'VeryLazy',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  config = function() require 'setup.bufferline' end,
  keys = keys,
}
