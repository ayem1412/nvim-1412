-- Completion
return {
  'saghen/blink.cmp',
  version = '1.*',
  event = 'InsertEnter',
  dependencies = { 'rafamadriz/friendly-snippets' },
  config = function() require 'setup.blink' end,
}
