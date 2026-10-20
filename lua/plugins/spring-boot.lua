-- Spring Boot: completion in application.yml / application.properties,
-- plus Spring-aware help in .java files (works through jdtls, see ftplugin/java.lua)
return {
  'JavaHello/spring-boot.nvim',
  ft = { 'java', 'yaml', 'jproperties' },
  dependencies = { 'mfussenegger/nvim-jdtls', 'mason-org/mason.nvim' },
  opts = function()
    -- Use the server jar inside Mason's package folder: it loads its libraries from the
    -- `lib/` folder next to it. (The copy Mason puts in $MASON/share has no `lib/`.)
    local dir = vim.fn.expand '$MASON/packages/vscode-spring-boot-tools/extension/language-server'
    local jars = vim.fn.glob(dir .. '/spring-boot-language-server*.jar', true, true)
    return { ls_path = jars[1] }
  end,
}
