-- Preview Markdown in the browser, styled like GitHub, updating live as you type.
-- Also works for HTML and SVG files. No Node.js or build step needed.
return {
  'brianhuster/live-preview.nvim',
  cmd = 'LivePreview',
  dependencies = { 'folke/snacks.nvim' },
  opts = { sync_scroll = true },
  keys = {
    { '<leader>cp', '<cmd>LivePreview start<cr>', desc = 'Preview in browser' },
    { '<leader>cP', '<cmd>LivePreview close<cr>', desc = 'Stop browser preview' },
  },
}
