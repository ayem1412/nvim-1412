-- TypeScript / JavaScript / Vue (with the Vue plugin from vue-language-server)
local vue_plugin = vim.fn.expand '$MASON/packages/vue-language-server/node_modules/@vue/language-server'

return {
  filetypes = { 'javascript', 'javascriptreact', 'typescript', 'typescriptreact', 'vue' },
  settings = {
    complete_function_calls = true,
    vtsls = {
      enableMoveToFileCodeAction = true,
      autoUseWorkspaceTsdk = true,
      tsserver = {
        globalPlugins = {
          {
            name = '@vue/typescript-plugin',
            location = vue_plugin,
            languages = { 'vue' },
            configNamespace = 'typescript',
            enableForWorkspaceTypeScriptVersions = true,
          },
        },
      },
    },
    typescript = {
      updateImportsOnFileMove = { enabled = 'always' },
      inlayHints = {
        parameterNames = { enabled = 'literals' },
        variableTypes = { enabled = false },
        functionLikeReturnTypes = { enabled = true },
      },
    },
  },
}
