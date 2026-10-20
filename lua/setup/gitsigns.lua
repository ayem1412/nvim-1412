require('gitsigns').setup {
  signs = {
    add = { text = '▎' },
    change = { text = '▎' },
    delete = { text = '\u{2581}' },
    topdelete = { text = '\u{2594}' },
    changedelete = { text = '▎' },
    untracked = { text = '▎' },
  },
  on_attach = function(buffer)
    local gs = require 'gitsigns'
    local function map(mode, l, r, desc) vim.keymap.set(mode, l, r, { buffer = buffer, desc = desc }) end
    map('n', ']h', function() gs.nav_hunk 'next' end, 'Next hunk')
    map('n', '[h', function() gs.nav_hunk 'prev' end, 'Prev hunk')
    map({ 'n', 'v' }, '<leader>ghs', ':Gitsigns stage_hunk<CR>', 'Stage hunk')
    map({ 'n', 'v' }, '<leader>ghr', ':Gitsigns reset_hunk<CR>', 'Reset hunk')
    map('n', '<leader>ghS', gs.stage_buffer, 'Stage buffer')
    map('n', '<leader>ghR', gs.reset_buffer, 'Reset buffer')
    map('n', '<leader>ghp', gs.preview_hunk_inline, 'Preview hunk')
    map('n', '<leader>ghb', function() gs.blame_line { full = true } end, 'Blame line')
    map('n', '<leader>ghd', gs.diffthis, 'Diff this')
    map('n', '<leader>ub', gs.toggle_current_line_blame, 'Toggle line blame')
    map({ 'o', 'x' }, 'ih', ':<C-U>Gitsigns select_hunk<CR>', 'Select hunk')
  end,
}
