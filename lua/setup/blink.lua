require('blink.cmp').setup {
  keymap = {
    preset = 'none',
    -- Tab / Shift+Tab: move down / up in the menu. With no menu: jump in a snippet, or a normal Tab.
    ['<Tab>'] = { 'select_next', 'snippet_forward', 'fallback' },
    ['<S-Tab>'] = { 'select_prev', 'snippet_backward', 'fallback' },
    -- Enter: apply the selected item. Nothing selected: a normal Enter (new line).
    ['<CR>'] = { 'accept', 'fallback' },
    ['<C-space>'] = { 'show', 'show_documentation', 'hide_documentation' },
    ['<C-e>'] = { 'hide', 'fallback' },
    ['<C-b>'] = { 'scroll_documentation_up', 'fallback' },
    ['<C-f>'] = { 'scroll_documentation_down', 'fallback' },
  },
  appearance = { nerd_font_variant = 'mono' },
  completion = {
    -- Nothing selected when the menu opens, and moving in the menu doesn't change your text
    list = { selection = { preselect = false, auto_insert = false } },
    accept = { auto_brackets = { enabled = true } },
    menu = {
      border = 'rounded',
      draw = {
        treesitter = { 'lsp' },
        columns = { { 'kind_icon' }, { 'label', 'label_description', gap = 1 }, { 'kind' } },
      },
    },
    documentation = { auto_show = true, auto_show_delay_ms = 200, window = { border = 'rounded' } },
    ghost_text = { enabled = false },
  },
  signature = { enabled = true, window = { border = 'rounded' } },
  sources = {
    default = { 'lsp', 'path', 'snippets', 'buffer' },
    per_filetype = {
      sql = { 'dadbod', 'buffer' },
      mysql = { 'dadbod', 'buffer' },
      plsql = { 'dadbod', 'buffer' },
    },
    providers = {
      dadbod = { name = 'Dadbod', module = 'vim_dadbod_completion.blink' },
    },
  },
  fuzzy = { implementation = 'prefer_rust_with_warning' },
  cmdline = { enabled = false },
}
