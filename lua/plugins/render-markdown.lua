-- Shows Markdown files (READMEs) rendered inside Neovim: headings, tables, checkboxes, code blocks.
-- The raw text comes back on the line your cursor is on, so you can still edit.
return {
  'MeanderingProgrammer/render-markdown.nvim',
  ft = { 'markdown' },
  dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' },
  opts = { completions = { blink = { enabled = true } } },
  keys = {
    {
      '<leader>um',
      function() require('render-markdown').toggle() end,
      ft = 'markdown',
      desc = 'Toggle Markdown view',
    },
  },
}
