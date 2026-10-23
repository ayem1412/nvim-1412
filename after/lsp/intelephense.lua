-- PHP. The PHP version is picked per project, from its composer.json:
--   1. "config": { "platform": { "php": "8.2.12" } }   (exact version, if set)
--   2. "require": { "php": "^8.2" }                    (the first version in it)
--   3. no composer.json → 5.6 (old WAMP projects)
--   4. composer.json without a PHP version → 8.5 (newest)
-- To force a version for one project, use a `.nvim.lua` file (see README).

local LEGACY, LATEST = '5.6.40', '8.5.0'

local function php_version(root)
  if not root then return LEGACY end
  local f = io.open(root .. '/composer.json', 'r')
  if not f then return LEGACY end
  local ok, json = pcall(vim.json.decode, f:read '*a')
  f:close()
  if not ok or type(json) ~= 'table' then return LATEST end

  local platform = vim.tbl_get(json, 'config', 'platform', 'php')
  local required = vim.tbl_get(json, 'require', 'php')
  local major, minor, patch = tostring(platform or required or ''):match '(%d+)%.(%d+)%.?(%d*)'
  if not major then return LATEST end
  return ('%s.%s.%s'):format(major, minor, patch ~= '' and patch or '0')
end

return {
  settings = {
    intelephense = {
      environment = { phpVersion = LEGACY },
      files = { maxSize = 5000000, exclude = { '**/vendor/**/{Tests,tests}/**', '**/node_modules/**', '**/cache/**' } },
      telemetry = { enabled = false },
    },
  },
  -- After the server starts: set this project's PHP version and send it to the server
  on_init = function(client)
    client.settings = vim.tbl_deep_extend('force', client.settings, {
      intelephense = { environment = { phpVersion = php_version(client.root_dir) } },
    })
    client:notify('workspace/didChangeConfiguration', { settings = client.settings })
  end,
}
