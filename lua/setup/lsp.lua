-- Server settings live in after/lsp/<server>.lua (Neovim loads them by itself).
-- This file only installs servers and turns them on.

require 'setup.lsp_keymaps' -- set up before servers start

-- Shared settings for every server
vim.lsp.config('*', {
  capabilities = require('blink.cmp').get_lsp_capabilities(),
})

require('mason-lspconfig').setup {
  ensure_installed = {
    'biome',
    'cssls',
    'dockerls', -- Dockerfile
    'emmet_language_server',
    'html',
    'intelephense', -- PHP
    'jdtls', -- installed here, started by nvim-jdtls (ftplugin/java.lua)
    'jsonls',
    'lemminx', -- XML (pom.xml)
    'lua_ls',
    'taplo', -- JSON / YAML / TOML
    'vtsls',
    'vue_ls', -- TS / JS / Vue / React
    'yamlls',
  },
  -- jdtls: started by nvim-jdtls. rust_analyzer: started by rustaceanvim.
  automatic_enable = { exclude = { 'jdtls', 'rust_analyzer' } },
}
