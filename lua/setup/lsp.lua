-- Server settings live in after/lsp/<server>.lua (Neovim loads them by itself).
-- This file only installs servers and turns them on.

require 'setup.lsp_keymaps' -- set up before servers start

-- Shared settings for every server
vim.lsp.config('*', {
  capabilities = require('blink.cmp').get_lsp_capabilities(),
})

require('mason-lspconfig').setup {
  ensure_installed = {
    'lua_ls',
    'intelephense', -- PHP
    'vtsls',
    'vue_ls', -- TS / JS / Vue / React
    'html',
    'cssls',
    'emmet_language_server',
    'jsonls',
    'yamlls',
    'taplo', -- JSON / YAML / TOML
    'lemminx', -- XML (pom.xml)
    'dockerls', -- Dockerfile
    'jdtls', -- installed here, started by nvim-jdtls (ftplugin/java.lua)
  },
  -- jdtls: started by nvim-jdtls. rust_analyzer: started by rustaceanvim.
  automatic_enable = { exclude = { 'jdtls', 'rust_analyzer' } },
}
