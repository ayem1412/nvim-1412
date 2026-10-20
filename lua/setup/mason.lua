-- Tools that are not language servers (those are listed in setup/lsp.lua)
local tools = {
  "stylua", "prettierd", "shfmt",
  "codelldb", "php-debug-adapter", "js-debug-adapter", "java-debug-adapter", "java-test",
}

require("mason").setup({ ui = { border = "rounded" } })

local registry = require("mason-registry")
registry.refresh(function()
  for _, name in ipairs(tools) do
    local ok, pkg = pcall(registry.get_package, name)
    if ok and not pkg:is_installed() then pkg:install() end
  end
end)
