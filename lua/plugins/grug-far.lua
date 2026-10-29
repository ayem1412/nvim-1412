-- Search and replace across the project (or one file), with a preview before changing anything
return {
  'MagicDuck/grug-far.nvim',
  cmd = 'GrugFar',
  opts = { headerMaxWidth = 80 },
  keys = {
    {
      '<leader>sr',
      function() require('grug-far').open { prefills = { search = vim.fn.expand '<cword>' } } end,
      desc = 'Search & replace (project)',
    },
    {
      '<leader>sr',
      function() require('grug-far').with_visual_selection() end,
      mode = 'x',
      desc = 'Search & replace selection (project)',
    },
    {
      '<leader>sf',
      function()
        require('grug-far').open { prefills = { search = vim.fn.expand '<cword>', paths = vim.fn.expand '%' } }
      end,
      desc = 'Search & replace (this file)',
    },
  },
}
