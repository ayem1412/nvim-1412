-- Lua (for this config)
return {
  settings = {
    Lua = {
      workspace = { checkThirdParty = false },
      completion = { callSnippet = 'Replace' },
      diagnostics = { globals = { 'vim', 'Snacks' } },
    },
  },
}
