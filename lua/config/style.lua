-- Make the editor follow the project's own style files: indentation and line width.
-- (The ruler on the right follows the line width.)
--
--   .editorconfig            Neovim reads it by itself (indent_style, indent_size, max_line_length)
--   biome.json(c)            lineWidth, indentWidth, indentStyle  -> for js/ts/jsx/tsx/json/css
--   .prettierrc(.json/.yaml) printWidth, tabWidth, useTabs        -> for vue/html/scss/yaml/markdown
--                                                                    (and js/ts/... if no biome.json)
-- Biome's or Prettier's file wins over .editorconfig, like the tools themselves do.
-- With none of them, the line width stays at 120.

local biome_ft = { 'javascript', 'typescript', 'javascriptreact', 'typescriptreact', 'json', 'jsonc', 'css' }
local prettier_ft = { 'vue', 'html', 'scss', 'yaml', 'markdown' }

local function find(names, buf)
  local file = vim.api.nvim_buf_get_name(buf)
  if file == '' then return nil end
  local path = vim.fs.find(names, { upward = true, path = vim.fs.dirname(file) })[1]
  if not path then return nil end
  local f = io.open(path, 'r')
  if not f then return nil end
  local text = f:read '*a'
  f:close()
  return text
end

-- Works for JSON and YAML: finds `key: 4`, `"key": 4`, `"key": "tab"`, `key: true`
local function get(text, key) return text:match('["\']?' .. key .. '["\']?%s*:%s*["\']?([%w]+)') end

local function apply(buf)
  local ft = vim.bo[buf].filetype
  local style -- { width, indent, tabs }

  if vim.tbl_contains(biome_ft, ft) then
    local biome = find({ 'biome.json', 'biome.jsonc' }, buf)
    if biome then
      -- Biome's defaults: 80 wide, tabs, 2
      style = {
        width = tonumber(get(biome, 'lineWidth')) or 80,
        indent = tonumber(get(biome, 'indentWidth')) or 2,
        tabs = (get(biome, 'indentStyle') or 'tab') == 'tab',
      }
    end
  end

  if not style and (vim.tbl_contains(biome_ft, ft) or vim.tbl_contains(prettier_ft, ft)) then
    local prettier = find({ '.prettierrc', '.prettierrc.json', '.prettierrc.yaml', '.prettierrc.yml' }, buf)
    if prettier then
      -- Prettier's defaults: 80 wide, spaces, 2
      style = {
        width = tonumber(get(prettier, 'printWidth')) or 80,
        indent = tonumber(get(prettier, 'tabWidth')) or 2,
        tabs = get(prettier, 'useTabs') == 'true',
      }
    end
  end

  if not style then return end
  local bo = vim.bo[buf]
  bo.textwidth = style.width
  bo.expandtab = not style.tabs
  bo.shiftwidth = style.indent
  bo.tabstop = style.indent
  bo.softtabstop = style.indent
end

vim.api.nvim_create_autocmd('FileType', {
  group = vim.api.nvim_create_augroup('cfg_project_style', { clear = true }),
  -- scheduled: runs after .editorconfig is applied, so these files win
  callback = function(ev)
    vim.schedule(function()
      if vim.api.nvim_buf_is_valid(ev.buf) then apply(ev.buf) end
    end)
  end,
})
