-- Snippet engine. Neovim's built-in one can't read many common snippets
-- (text mixed with a nested placeholder, like PHP's foreach), LuaSnip can.
return {
  'L3MON4D3/LuaSnip',
  version = 'v2.*',
  lazy = true,
  dependencies = { 'rafamadriz/friendly-snippets' },
  config = function() require('luasnip.loaders.from_vscode').lazy_load() end,
}
