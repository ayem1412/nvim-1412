-- On the work PC (Windows), hide file and project names: work code stays private.
-- Discord then shows only the language ("Editing Java"). Set to false to show everything.
local private = vim.fn.has 'win32' == 1

local function language(opts) return opts.name or opts.filetype end

require('cord').setup {
  editor = { tooltip = 'Neovim' },
  idle = { enabled = true, timeout = 300000 }, -- "idle" after 5 minutes without activity
  text = private and {
    workspace = 'Working on a project',
    viewing = function(opts) return 'Reading ' .. language(opts) end,
    editing = function(opts) return 'Editing ' .. language(opts) end,
  } or nil,
}
