-- Debug adapters and launch configs.
--   Rust  -> codelldb (set up by rustaceanvim)
--   Java  -> java-debug-adapter + java-test (set up by nvim-jdtls, see ftplugin/java.lua)
--   PHP   -> php-debug-adapter + Xdebug (port 9003, or 9000 for Xdebug 2 on PHP 5)
--   JS/TS -> js-debug-adapter (node + chrome)
local dap, dapui = require 'dap', require 'dapui'

-- Signs
local signs = {
  DapBreakpoint = { '●', 'DiagnosticError' },
  DapBreakpointCondition = { '◆', 'DiagnosticWarn' },
  DapBreakpointRejected = { '○', 'DiagnosticError' },
  DapLogPoint = { '◇', 'DiagnosticInfo' },
  DapStopped = { '▶', 'DiagnosticOk', 'DapStoppedLine' },
}
vim.api.nvim_set_hl(0, 'DapStoppedLine', { default = true, link = 'Visual' })
for name, s in pairs(signs) do
  vim.fn.sign_define(name, { text = s[1], texthl = s[2], linehl = s[3], numhl = s[2] })
end

-- UI opens/closes with the session
dapui.setup {
  layouts = {
    {
      elements = {
        { id = 'scopes', size = 0.4 },
        { id = 'watches', size = 0.2 },
        { id = 'stacks', size = 0.2 },
        { id = 'breakpoints', size = 0.2 },
      },
      size = 40,
      position = 'left',
    },
    { elements = { { id = 'repl', size = 0.5 }, { id = 'console', size = 0.5 } }, size = 10, position = 'bottom' },
  },
  floating = { border = 'rounded' },
}
dap.listeners.after.event_initialized['dapui_config'] = function() dapui.open {} end
dap.listeners.before.event_terminated['dapui_config'] = function() dapui.close {} end
dap.listeners.before.event_exited['dapui_config'] = function() dapui.close {} end

local mason = vim.fn.expand '$MASON/packages'
local is_win = vim.fn.has 'win32' == 1

-------------------------------------------------------------------------
-- PHP (Xdebug)
-------------------------------------------------------------------------
dap.adapters.php = {
  type = 'executable',
  command = 'node',
  args = { mason .. '/php-debug-adapter/extension/out/phpDebug.js' },
}
dap.configurations.php = {
  {
    name = 'Listen for Xdebug 3 (port 9003)',
    type = 'php',
    request = 'launch',
    port = 9003,
    -- If the server runs elsewhere (docker, VM), map paths here:
    -- pathMappings = { ["/var/www/html"] = "${workspaceFolder}" },
  },
  {
    name = 'Listen for Xdebug 2 (PHP 5 / WAMP, port 9000)',
    type = 'php',
    request = 'launch',
    port = 9000,
  },
}

-------------------------------------------------------------------------
-- JavaScript / TypeScript (node + chrome) via js-debug-adapter
-------------------------------------------------------------------------
local js_debug = mason .. '/js-debug-adapter/js-debug/src/dapDebugServer.js'
for _, adapter in ipairs { 'pwa-node', 'pwa-chrome' } do
  dap.adapters[adapter] = {
    type = 'server',
    host = 'localhost',
    port = '${port}',
    executable = { command = 'node', args = { js_debug, '${port}' } },
  }
end
for _, ft in ipairs { 'javascript', 'typescript', 'javascriptreact', 'typescriptreact', 'vue' } do
  dap.configurations[ft] = {
    {
      type = 'pwa-node',
      request = 'launch',
      name = 'Node: launch current file',
      program = '${file}',
      cwd = '${workspaceFolder}',
      runtimeExecutable = 'node',
    },
    {
      type = 'pwa-node',
      request = 'attach',
      name = 'Node: attach to process',
      processId = require('dap.utils').pick_process,
      cwd = '${workspaceFolder}',
    },
    {
      type = 'pwa-chrome',
      request = 'launch',
      name = 'Chrome: launch against dev server',
      url = function() return vim.fn.input('URL: ', 'http://localhost:5173') end,
      webRoot = '${workspaceFolder}',
      sourceMaps = true,
    },
  }
end

-------------------------------------------------------------------------
-- codelldb (C / C++ fallback; Rust uses rustaceanvim which configures this itself)
-------------------------------------------------------------------------
dap.adapters.codelldb = {
  type = 'executable',
  command = mason .. '/codelldb/extension/adapter/codelldb' .. (is_win and '.exe' or ''),
}
dap.configurations.c = {
  {
    name = 'Launch executable',
    type = 'codelldb',
    request = 'launch',
    program = function() return vim.fn.input('Executable: ', vim.fn.getcwd() .. '/', 'file') end,
    cwd = '${workspaceFolder}',
    stopOnEntry = false,
  },
}
dap.configurations.cpp = dap.configurations.c

-- Load a project-local .vscode/launch.json if present
pcall(
  function()
    require('dap.ext.vscode').load_launchjs(nil, {
      php = { 'php' },
      ['pwa-node'] = { 'javascript', 'typescript' },
      ['pwa-chrome'] = { 'javascript', 'typescript', 'vue' },
      codelldb = { 'rust', 'c', 'cpp' },
    })
  end
)
