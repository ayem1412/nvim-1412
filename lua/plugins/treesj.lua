-- Split / join blocks (objects, arrays, arguments, functions...)
-- <space>m toggle, <space>j join. (<space>s is taken by the search keys)
return {
  'Wansmer/treesj',
  dependencies = { 'nvim-treesitter/nvim-treesitter' },
  opts = { use_default_keymaps = false, max_join_length = 150 },
  keys = {
    { '<leader>m', function() require('treesj').toggle() end, desc = 'Split/join toggle' },
    { '<leader>j', function() require('treesj').join() end, desc = 'Join block' },
  },
}
