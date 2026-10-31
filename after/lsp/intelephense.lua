--[[ -- PHP. The PHP version is picked per project, from its composer.json:
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
} ]]

-- PHP. The PHP version is picked per project, first match wins:
--   1. a `.php-version` file (one line, e.g. `8.3`) in the project folder or above
--   2. composer.json: "config.platform.php" (exact), else "require.php" (e.g. "^8.2" -> 8.2)
--   3. anything else -> 8.5 (newest)
-- For an old PHP 5 project, put a `.php-version` file with `5.6` in it.
-- `.php-version` also marks the project root, so projects without composer.json or git
-- still get full project features (jump to classes in other files, etc.).

local LATEST = '8.5.0'

local function find_up(name, dir) return vim.fs.find(name, { upward = true, path = dir })[1] end

local function read(path)
  local f = io.open(path, 'r')
  if not f then return nil end
  local text = f:read '*a'
  f:close()
  return text
end

-- "8.3" -> "8.3.0", "^8.2 || ^8.3" -> "8.2.0", "8.2.12" -> "8.2.12"
local function normalize(text)
  local major, minor, patch = tostring(text or ''):match '(%d+)%.(%d+)%.?(%d*)'
  if not major then return nil end
  return ('%s.%s.%s'):format(major, minor, patch ~= '' and patch or '0')
end

local function php_version(dir)
  local pv = find_up('.php-version', dir)
  if pv then
    local v = normalize(read(pv))
    if v then return v end
  end

  local composer = find_up('composer.json', dir)
  if not composer then return LATEST end
  local ok, json = pcall(vim.json.decode, read(composer) or '')
  if not ok or type(json) ~= 'table' then return LATEST end
  return normalize(vim.tbl_get(json, 'config', 'platform', 'php') or vim.tbl_get(json, 'require', 'php')) or LATEST
end

return {
  root_markers = { '.php-version', 'composer.json', '.git' },
  settings = {
    intelephense = {
      environment = { phpVersion = LATEST },
      files = { maxSize = 5000000, exclude = { '**/vendor/**/{Tests,tests}/**', '**/node_modules/**', '**/cache/**' } },
      telemetry = { enabled = false },
    },
  },
  -- After the server starts: set this project's PHP version and send it to the server
  on_init = function(client)
    local dir = client.root_dir or vim.fs.dirname(vim.api.nvim_buf_get_name(0))
    client.settings = vim.tbl_deep_extend('force', client.settings, {
      intelephense = { environment = { phpVersion = php_version(dir) } },
    })
    client:notify('workspace/didChangeConfiguration', { settings = client.settings })
  end,
}
