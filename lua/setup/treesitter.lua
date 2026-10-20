-- Treesitter ("main" branch). Needs the `tree-sitter` CLI and a C compiler.
local parsers = {
  -- core
  "lua", "luadoc", "vim", "vimdoc", "query", "regex", "bash", "markdown", "markdown_inline",
  "json", "jsonc", "yaml", "toml", "xml", "diff", "gitcommit", "git_rebase", "dockerfile",
  -- work
  "java", "php", "phpdoc", "javascript", "typescript", "tsx", "vue", "html", "css", "scss", "sql",
  "properties", -- application.properties
  -- personal
  "rust", "c",
}

local ts = require("nvim-treesitter")
ts.setup({ install_dir = vim.fn.stdpath("data") .. "/site" })

-- Install what's missing (does nothing if all are there)
local installed = ts.get_installed("parsers")
local missing = vim.tbl_filter(function(p) return not vim.tbl_contains(installed, p) end, parsers)
if #missing > 0 then ts.install(missing) end

-- Turn on highlighting + indentation when a parser exists for the file
vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("cfg_treesitter", { clear = true }),
  callback = function(ev)
    local lang = vim.treesitter.language.get_lang(ev.match)
    if not lang or not pcall(vim.treesitter.start, ev.buf, lang) then return end
    vim.bo[ev.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
  end,
})
