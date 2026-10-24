-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local out = vim.fn.system {
    'git',
    'clone',
    '--filter=blob:none',
    '--branch=stable',
    'https://github.com/folke/lazy.nvim.git',
    lazypath,
  }
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({ { 'Failed to clone lazy.nvim:\n' .. out, 'ErrorMsg' } }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- Turn off git "submodules" for every plugin.
-- Why: after cloning, git runs its submodule step with Git's sh.exe. On some Windows PCs
-- sh.exe crashes ("sh.exe: *** fatal error - add_item ... errno 1") and the install fails.
-- None of these plugins use submodules, so nothing is lost.
local function no_submodules(spec)
  if type(spec) == 'string' then return { spec, submodules = false } end
  if type(spec[1]) == 'string' then spec.submodules = false end
  for i, s in ipairs(spec) do -- a list of specs
    if type(s) == 'table' then spec[i] = no_submodules(s) end
  end
  if spec.dependencies then
    local deps = type(spec.dependencies) == 'string' and { spec.dependencies } or spec.dependencies
    for i, d in ipairs(deps) do
      deps[i] = no_submodules(d)
    end
    spec.dependencies = deps
  end
  return spec
end

-- Load every file in lua/plugins/
local function plugin_specs()
  local specs = { { 'folke/lazy.nvim', submodules = false } }
  for name in vim.fs.dir(vim.fn.stdpath 'config' .. '/lua/plugins') do
    if name:match '%.lua$' then table.insert(specs, no_submodules(require('plugins.' .. name:sub(1, -5)))) end
  end
  return specs
end

require('lazy').setup {
  spec = plugin_specs(),
  defaults = { lazy = true, version = false },
  install = { colorscheme = { 'tokyonight', 'habamax' } },
  checker = { enabled = false }, -- no background update checks: update only with :Lazy sync
  change_detection = { notify = false },
  ui = { border = 'rounded' },
  performance = {
    rtp = {
      disabled_plugins = {
        'gzip',
        'matchit',
        'matchparen',
        'netrwPlugin',
        'tarPlugin',
        'tohtml',
        'tutor',
        'zipPlugin',
        'rplugin',
        'spellfile',
        'osc52',
      },
    },
  },
}
