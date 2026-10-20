-- Pick the right comment style by where the cursor is
-- (e.g. <!-- --> in a Vue template, // in its <script>, {/* */} in JSX)
vim.g.skip_ts_context_commentstring_module = true
require('ts_context_commentstring').setup { enable_autocmd = false }

-- Default keymaps:
--   gcc / gbc        toggle line / block comment on the current line
--   gc{motion} / gb{motion}
--   visual: gc / gb
require('Comment').setup {
  pre_hook = require('ts_context_commentstring.integrations.comment_nvim').create_pre_hook(),
}
