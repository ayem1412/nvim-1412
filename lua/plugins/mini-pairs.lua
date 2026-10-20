-- Auto close brackets and quotes
return {
  'nvim-mini/mini.pairs',
  event = 'InsertEnter',
  opts = { modes = { insert = true, command = true, terminal = false } },
}
