return {
  'nvim-treesitter/nvim-treesitter-textobjects',
  branch = 'main',
  event = 'VeryLazy',
  config = function() require 'setup.treesitter_textobjects' end,
}
