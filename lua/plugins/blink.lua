-- Completion
return {
  'saghen/blink.cmp',
  version = '1.*',
  event = 'InsertEnter',
  dependencies = { 'rafamadriz/friendly-snippets', 'L3MON4D3/LuaSnip' },
  config = function() require 'setup.blink' end,
}
