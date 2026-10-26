-- Pick the right comment style by where the cursor is
-- (e.g. <!-- --> in a Vue template, // in its <script>, {/* */} in JSX)
vim.g.skip_ts_context_commentstring_module = true
require('ts_context_commentstring').setup { enable_autocmd = false }

-- Default keymaps:
--   gcc / gbc        toggle line / block comment on the current line
--   gc{motion} / gb{motion}
--   visual: gc / gb
local context_hook = require('ts_context_commentstring.integrations.comment_nvim').create_pre_hook()
local comment_ft = require 'Comment.ft'

require('Comment').setup {
  pre_hook = function(ctx)
    -- File without a treesitter parser: Comment.nvim (not updated since 2024) crashes on
    -- Neovim 0.12 in that case and does nothing. So give it the comment style ourselves.
    if not vim.treesitter.get_parser(0, nil, { error = false }) then
      return comment_ft.get(vim.bo.filetype, ctx.ctype) or vim.bo.commentstring
    end
    return context_hook(ctx)
  end,
}
