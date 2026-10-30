-- Treesitter ("main" branch). Needs the `tree-sitter` CLI and a C compiler.
local parsers = {
  'bash',
  'c',
  'css',
  'diff',
  'dockerfile',
  'git_rebase',
  'gitcommit',
  'gitignore',
  'html',
  'java',
  'javascript',
  'jsdoc',
  'json',
  'lua',
  'luadoc',
  'luadoc',
  'markdown',
  'markdown_inline',
  'php',
  'phpdoc',
  'properties',
  'query',
  'regex',
  'rust',
  'scss',
  'sql',
  'toml',
  'tsx',
  'twig',
  'typescript',
  'vim',
  'vimdoc',
  'vue',
  'xml',
  'yaml',
}

local ts = require 'nvim-treesitter'
ts.setup { install_dir = vim.fn.stdpath 'data' .. '/site' }

-- Install what's missing (does nothing if all are there)
local installed = ts.get_installed 'parsers'
local missing = vim.tbl_filter(function(p) return not vim.tbl_contains(installed, p) end, parsers)
if #missing > 0 then ts.install(missing) end

-- Volt (Phalcon templates) looks almost like Twig, so use the Twig parser for its colors
vim.treesitter.language.register('twig', 'volt')

-- Turn on highlighting + indentation when a parser exists for the file
vim.api.nvim_create_autocmd('FileType', {
  group = vim.api.nvim_create_augroup('cfg_treesitter', { clear = true }),
  callback = function(ev)
    local lang = vim.treesitter.language.get_lang(ev.match)
    if not lang or not pcall(vim.treesitter.start, ev.buf, lang) then return end
    vim.bo[ev.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
  end,
})
