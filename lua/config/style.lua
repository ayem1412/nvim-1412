-- Make the editor follow the project's own style files: indentation and line width.
-- (The ruler on the right follows the line width.)
--
--   .editorconfig            Neovim reads it by itself (indent_style, indent_size, max_line_length)
--   biome.json(c)            lineWidth, indentWidth, indentStyle  -> for js/ts/jsx/tsx/json/css
--   .prettierrc(.json/.yaml) printWidth, tabWidth, useTabs        -> for vue/html/scss/yaml/markdown
--                                                                    (and js/ts/... if no biome.json)
-- A value set in biome.json / .prettierrc wins over .editorconfig, like the tools themselves do.
-- A value they don't set comes from .editorconfig if there is one (Biome and Prettier read it
-- too), otherwise from the tool's own default. With none of these files, the width stays at 120.

local biome_ft = { 'javascript', 'typescript', 'javascriptreact', 'typescriptreact', 'json', 'jsonc', 'css' }
local prettier_ft = { 'vue', 'html', 'scss', 'yaml', 'markdown' }

local function find(names, buf)
  local file = vim.api.nvim_buf_get_name(buf)
  if file == '' then return nil end
  return vim.fs.find(names, { upward = true, path = vim.fs.dirname(file) })[1]
end

local function read(path)
  local f = io.open(path, 'r')
  if not f then return nil end
  local text = f:read '*a'
  f:close()
  return text
end

-- Works for JSON and YAML: finds `key: 4`, `"key": 4`, `"key": "tab"`, `key: true`
local function get(text, key) return text:match('["\']?' .. key .. '["\']?%s*:%s*["\']?([%w]+)') end

-- Reads one tool's config. Missing values stay nil when .editorconfig can fill them.
-- keys: { width, indent, tabs = { key, tab_value } }, defaults: the tool's own defaults
local function read_style(text, keys, defaults, has_editorconfig)
  local width = tonumber(get(text, keys.width))
  local indent = tonumber(get(text, keys.indent))
  local tabs_raw = get(text, keys.tabs[1])
  local tabs = nil
  if tabs_raw then tabs = tabs_raw == keys.tabs[2] end

  if not has_editorconfig then
    width = width or defaults.width
    indent = indent or defaults.indent
    if tabs == nil then tabs = defaults.tabs end
  end
  return { width = width, indent = indent, tabs = tabs }
end

local function apply(buf)
  local ft = vim.bo[buf].filetype
  local is_biome_ft = vim.tbl_contains(biome_ft, ft)
  if not is_biome_ft and not vim.tbl_contains(prettier_ft, ft) then return end

  local has_editorconfig = find({ '.editorconfig' }, buf) ~= nil
  local style

  local biome = is_biome_ft and find({ 'biome.json', 'biome.jsonc' }, buf)
  if biome then
    style = read_style(
      read(biome) or '',
      { width = 'lineWidth', indent = 'indentWidth', tabs = { 'indentStyle', 'tab' } },
      { width = 80, indent = 2, tabs = true },
      has_editorconfig
    )
  else
    local prettier = find({ '.prettierrc', '.prettierrc.json', '.prettierrc.yaml', '.prettierrc.yml' }, buf)
    if prettier then
      style = read_style(
        read(prettier) or '',
        { width = 'printWidth', indent = 'tabWidth', tabs = { 'useTabs', 'true' } },
        { width = 80, indent = 2, tabs = false },
        has_editorconfig
      )
    end
  end

  if not style then return end
  local bo = vim.bo[buf]
  if style.width then bo.textwidth = style.width end
  if style.tabs ~= nil then bo.expandtab = not style.tabs end
  if style.indent then
    bo.shiftwidth = style.indent
    bo.tabstop = style.indent
    bo.softtabstop = style.indent
  end
end

vim.api.nvim_create_autocmd('FileType', {
  group = vim.api.nvim_create_augroup('cfg_project_style', { clear = true }),
  -- scheduled: runs after .editorconfig is applied, so values set in these files win
  callback = function(ev)
    vim.schedule(function()
      if vim.api.nvim_buf_is_valid(ev.buf) then apply(ev.buf) end
    end)
  end,
})
