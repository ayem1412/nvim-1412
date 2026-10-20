require('nvim-treesitter-textobjects').setup {
  select = { lookahead = true },
  move = { set_jumps = true },
}

local move = require 'nvim-treesitter-textobjects.move'
local map = vim.keymap.set
map({ 'n', 'x', 'o' }, ']f', function() move.goto_next_start '@function.outer' end, { desc = 'Next function' })
map({ 'n', 'x', 'o' }, '[f', function() move.goto_previous_start '@function.outer' end, { desc = 'Prev function' })
map({ 'n', 'x', 'o' }, ']c', function() move.goto_next_start '@class.outer' end, { desc = 'Next class' })
map({ 'n', 'x', 'o' }, '[c', function() move.goto_previous_start '@class.outer' end, { desc = 'Prev class' })
