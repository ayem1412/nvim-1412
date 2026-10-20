return {
  'folke/todo-comments.nvim',
  event = { 'BufReadPost', 'BufNewFile' },
  opts = { signs = false },
  keys = {
    { ']t', function() require('todo-comments').jump_next() end, desc = 'Next todo' },
    { '[t', function() require('todo-comments').jump_prev() end, desc = 'Prev todo' },
    { '<leader>st', function() Snacks.picker.todo_comments() end, desc = 'Todo comments' },
  },
}
