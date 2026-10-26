require('snacks').setup {
  -- Turn off heavy features only for files over 1.5 MB. (The default also does it for files
  -- with very long lines, which caught small one-line templates.)
  bigfile = { enabled = true, line_length = math.huge },
  quickfile = { enabled = true },
  notifier = { enabled = true, timeout = 3000 },
  input = { enabled = true },
  indent = { enabled = true, animate = { enabled = false } },
  words = { enabled = true }, -- highlight other uses of the word under cursor
  statuscolumn = { enabled = true },
  scroll = { enabled = false },
  explorer = { enabled = true },
  picker = {
    sources = {
      explorer = { hidden = true, ignored = false },
      files = { hidden = true },
      grep = { hidden = true },
    },
  },
  dashboard = {
    preset = {
      header = [[
███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗
████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║
██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║
██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║
██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║
╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝]],
      keys = {
        { icon = '\u{f002} ', key = 'f', desc = 'Find File', action = ':lua Snacks.picker.files()' },
        { icon = '\u{f15b} ', key = 'n', desc = 'New File', action = ':ene | startinsert' },
        { icon = '\u{f0e7} ', key = 'g', desc = 'Find Text', action = ':lua Snacks.picker.grep()' },
        { icon = '\u{f017} ', key = 'r', desc = 'Recent Files', action = ':lua Snacks.picker.recent()' },
        {
          icon = '\u{f013} ',
          key = 'c',
          desc = 'Config',
          action = ":lua Snacks.picker.files({cwd = vim.fn.stdpath('config')})",
        },
        { icon = '\u{f0e2} ', key = 's', desc = 'Restore Session', section = 'session' },
        { icon = '\u{f04b2} ', key = 'l', desc = 'Lazy', action = ':Lazy' },
        { icon = '\u{f011} ', key = 'q', desc = 'Quit', action = ':qa' },
      },
    },
    sections = {
      { section = 'header' },
      { section = 'keys', gap = 1, padding = 1 },
      { section = 'recent_files', icon = '\u{f017} ', title = 'Recent Files', indent = 2, padding = 1 },
      { section = 'projects', icon = '\u{f07b} ', title = 'Projects', indent = 2, padding = 1 },
      { section = 'startup' },
    },
  },
}

-- Toggles (<leader>u...). Set up after startup so they don't slow it down.
vim.api.nvim_create_autocmd('User', {
  pattern = 'VeryLazy',
  once = true,
  callback = function()
    Snacks.toggle.option('spell', { name = 'Spelling' }):map '<leader>us'
    Snacks.toggle.option('wrap', { name = 'Wrap' }):map '<leader>uw'
    Snacks.toggle.option('relativenumber', { name = 'Relative Number' }):map '<leader>uL'
    Snacks.toggle.line_number():map '<leader>ul'
    Snacks.toggle.diagnostics():map '<leader>ud'
    Snacks.toggle.inlay_hints():map '<leader>uh'
    Snacks.toggle.indent():map '<leader>ug'
    Snacks.toggle.dim():map '<leader>uD'
    Snacks.toggle.treesitter():map '<leader>uT'
  end,
})
