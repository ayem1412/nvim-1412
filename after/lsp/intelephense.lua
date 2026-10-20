-- PHP. Default PHP version is 5.6 (legacy WAMP projects).
-- Override per project with a `.nvim.lua` file (see README).
return {
  settings = {
    intelephense = {
      environment = { phpVersion = '5.6.40' },
      files = { maxSize = 5000000, exclude = { '**/vendor/**/{Tests,tests}/**', '**/node_modules/**', '**/cache/**' } },
      telemetry = { enabled = false },
    },
  },
}
