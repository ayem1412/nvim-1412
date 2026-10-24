local o = vim.opt

-- UI
o.number = true
o.relativenumber = true
o.signcolumn = 'yes'
o.cursorline = true
-- Block cursor in insert mode too (same as normal/visual). Replace stays an underline.
o.guicursor = 'n-v-c-sm-i-ci-ve:block,r-cr-o:hor20,t:block-blinkon500-blinkoff500-TermCursor'
o.termguicolors = true
o.scrolloff = 8
o.sidescrolloff = 8
o.wrap = false
o.showmode = false -- lualine shows it
o.laststatus = 3 -- one global statusline
o.cmdheight = 1
o.pumheight = 12
o.winminwidth = 5
o.splitright = true
o.splitbelow = true
o.splitkeep = 'screen'
o.list = true
-- Show whitespace: · = space at the start of a line, ──→ = tab, • = space at the end of a line,
-- ␣ = non-breaking space. They use the dim "Whitespace" color, so they stay in the background.
o.listchars = { lead = '·', tab = '──→', trail = '•', nbsp = '␣', extends = '›', precedes = '‹' }
o.fillchars = { eob = ' ', fold = ' ', foldopen = '▾', foldclose = '▸', foldsep = ' ' }
o.conceallevel = 0

-- Editing
o.expandtab = true
o.shiftwidth = 4
o.tabstop = 4
o.softtabstop = 4
o.shiftround = true
o.smartindent = true
o.breakindent = true
o.virtualedit = 'block'
o.completeopt = 'menu,menuone,noselect'
o.formatoptions = 'jcroqlnt'

-- Search
o.ignorecase = true
o.smartcase = true
o.inccommand = 'split'
o.grepprg = 'rg --vimgrep --smart-case'
o.grepformat = '%f:%l:%c:%m'

-- Files
o.undofile = true
o.undolevels = 10000
o.swapfile = false
o.backup = false
o.writebackup = false
o.autowrite = true
o.confirm = true
o.fileformats = 'unix,dos' -- keep LF unless the file is already CRLF
o.exrc = true -- load a trusted .nvim.lua from the project root (per-project overrides)

-- Performance
o.updatetime = 200
o.timeoutlen = 300
o.redrawtime = 1500
o.synmaxcol = 300

-- Folds (treesitter based)
o.foldmethod = 'expr'
o.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
o.foldlevel = 99
o.foldtext = ''

-- Clipboard: yank (y) stays inside Neovim. Use <leader>y to copy to the system clipboard.

-- Windows: use PowerShell so :! and terminals behave
if vim.fn.has 'win32' == 1 then
  local pwsh = vim.fn.executable 'pwsh' == 1 and 'pwsh' or 'powershell'
  o.shell = pwsh
  o.shellcmdflag = '-NoLogo -NoProfile -ExecutionPolicy RemoteSigned -Command '
    .. '[Console]::InputEncoding=[Console]::OutputEncoding=[System.Text.UTF8Encoding]::new();'
    .. "$PSDefaultParameterValues['Out-File:Encoding']='utf8';"
  o.shellredir = '2>&1 | %%{ "$_" } | Out-File %s; exit $LastExitCode'
  o.shellpipe = '2>&1 | %%{ "$_" } | tee %s; exit $LastExitCode'
  o.shellquote = ''
  o.shellxquote = ''
end

-- Diagnostics look
vim.diagnostic.config {
  severity_sort = true,
  update_in_insert = false,
  float = { border = 'rounded', source = 'if_many' },
  underline = { severity = { min = vim.diagnostic.severity.WARN } },
  virtual_text = { spacing = 2, prefix = '●' },
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = '\u{f057} ',
      [vim.diagnostic.severity.WARN] = '\u{f071} ',
      [vim.diagnostic.severity.INFO] = '\u{f05a} ',
      [vim.diagnostic.severity.HINT] = '\u{f0eb} ',
    },
  },
}
