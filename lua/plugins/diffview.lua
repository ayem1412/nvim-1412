-- Git: side-by-side diffs, file history, and a 3-panel view for merge conflicts
local function toggle(cmd)
  return function()
    if require('diffview.lib').get_current_view() then
      vim.cmd 'DiffviewClose'
    else
      vim.cmd(cmd)
    end
  end
end

return {
  'sindrets/diffview.nvim',
  cmd = { 'DiffviewOpen', 'DiffviewFileHistory', 'DiffviewClose' },
  opts = { enhanced_diff_hl = true },
  keys = {
    { '<leader>gd', toggle 'DiffviewOpen', desc = 'Diff: all changes (toggle)' },
    { '<leader>gf', toggle 'DiffviewFileHistory %', desc = 'History of this file (toggle)' },
    { '<leader>gF', toggle 'DiffviewFileHistory', desc = 'History of the repo (toggle)' },
  },
}
