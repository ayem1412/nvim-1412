require("setup.lsp_keymaps") -- set up before servers start

-- Shared settings for every server
vim.lsp.config("*", {
  capabilities = require("blink.cmp").get_lsp_capabilities(),
})

-- Lua (for this config)
vim.lsp.config("lua_ls", {
  settings = {
    Lua = {
      workspace = { checkThirdParty = false },
      completion = { callSnippet = "Replace" },
      diagnostics = { globals = { "vim", "Snacks" } },
    },
  },
})

-- PHP: intelephense. Default PHP version is 5.6 (legacy WAMP projects).
-- Override per project with a `.nvim.lua` file (see README).
vim.lsp.config("intelephense", {
  settings = {
    intelephense = {
      environment = { phpVersion = "5.6.40" },
      files = { maxSize = 5000000, exclude = { "**/vendor/**/{Tests,tests}/**", "**/node_modules/**", "**/cache/**" } },
      telemetry = { enabled = false },
    },
  },
})

-- TypeScript / JavaScript / Vue (vtsls + Vue plugin)
local vue_plugin_path = vim.fn.expand("$MASON/packages/vue-language-server/node_modules/@vue/language-server")
vim.lsp.config("vtsls", {
  filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact", "vue" },
  settings = {
    complete_function_calls = true,
    vtsls = {
      enableMoveToFileCodeAction = true,
      autoUseWorkspaceTsdk = true,
      tsserver = {
        globalPlugins = {
          {
            name = "@vue/typescript-plugin",
            location = vue_plugin_path,
            languages = { "vue" },
            configNamespace = "typescript",
            enableForWorkspaceTypeScriptVersions = true,
          },
        },
      },
    },
    typescript = {
      updateImportsOnFileMove = { enabled = "always" },
      inlayHints = {
        parameterNames = { enabled = "literals" },
        variableTypes = { enabled = false },
        functionLikeReturnTypes = { enabled = true },
      },
    },
  },
})

-- JSON / YAML with schemas (package.json, tsconfig, docker-compose, GitHub workflows...)
vim.lsp.config("jsonls", {
  settings = {
    json = { schemas = require("schemastore").json.schemas(), validate = { enable = true } },
  },
})
vim.lsp.config("yamlls", {
  settings = {
    yaml = {
      schemaStore = { enable = false, url = "" },
      schemas = require("schemastore").yaml.schemas(),
    },
  },
})

require("mason-lspconfig").setup({
  ensure_installed = {
    "lua_ls",
    "intelephense",
    "vtsls", "vue_ls",
    "html", "cssls", "emmet_language_server",
    "jsonls", "yamlls", "lemminx", -- lemminx = XML (pom.xml)
    "jdtls", -- installed here, started by nvim-jdtls (ftplugin/java.lua)
  },
  -- jdtls: handled by nvim-jdtls. rust_analyzer: handled by rustaceanvim.
  automatic_enable = { exclude = { "jdtls", "rust_analyzer" } },
})
