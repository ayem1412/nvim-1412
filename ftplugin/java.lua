-- Runs for every Java buffer. Starts (or re-attaches to) jdtls for the project.
local ok, jdtls = pcall(require, 'jdtls')
if not ok then return end

local mason = vim.fn.expand '$MASON/packages'
local jdtls_pkg = mason .. '/jdtls'
local is_win = vim.fn.has 'win32' == 1

-- Project root and a separate workspace folder per project
local root = vim.fs.root(0, { 'mvnw', 'gradlew', 'pom.xml', 'build.gradle', '.git' }) or vim.fn.getcwd()
local project_name = vim.fn.fnamemodify(root, ':p:h:t')
local workspace = vim.fn.stdpath 'cache' .. '/jdtls/' .. project_name

-- Debug + test bundles (java-debug-adapter, java-test from Mason)
local bundles = {}
local function add_jars(glob)
  for _, jar in ipairs(vim.split(vim.fn.glob(glob, true), '\n')) do
    if jar ~= '' then table.insert(bundles, jar) end
  end
end
add_jars(mason .. '/java-debug-adapter/extension/server/com.microsoft.java.debug.plugin-*.jar')
add_jars(mason .. '/java-test/extension/server/*.jar')

-- Spring Boot extension jars (from spring-boot.nvim + Mason's vscode-spring-boot-tools)
local has_spring, spring = pcall(require, 'spring_boot')
if has_spring then vim.list_extend(bundles, spring.java_extensions()) end

-- Lombok (Spring Boot projects use it a lot). Mason ships it with jdtls.
local lombok = jdtls_pkg .. '/lombok.jar'
local cmd = { is_win and 'jdtls.cmd' or 'jdtls', '-data', workspace }
if vim.uv.fs_stat(lombok) then table.insert(cmd, 2, '--jvm-arg=-javaagent:' .. lombok) end

jdtls.start_or_attach {
  cmd = cmd,
  root_dir = root,
  capabilities = require('blink.cmp').get_lsp_capabilities(),
  init_options = { bundles = bundles },
  settings = {
    java = {
      eclipse = { downloadSources = true },
      maven = { downloadSources = true },
      references = { includeDecompiledSources = true },
      signatureHelp = { enabled = true },
      implementationsCodeLens = { enabled = true },
      referencesCodeLens = { enabled = true },
      inlayHints = { parameterNames = { enabled = 'all' } },
      format = { enabled = true },
      completion = {
        favoriteStaticMembers = {
          'org.junit.jupiter.api.Assertions.*',
          'org.mockito.Mockito.*',
          'org.assertj.core.api.Assertions.*',
        },
        importOrder = { 'java', 'javax', 'jakarta', 'org', 'com' },
      },
      sources = { organizeImports = { starThreshold = 9999, staticStarThreshold = 9999 } },
      codeGeneration = {
        toString = { template = '${object.className}{${member.name()}=${member.value}, ${otherMembers}}' },
        useBlocks = true,
      },
      -- Uncomment to pin JDKs if `java` on PATH is not the one you want:
      -- configuration = {
      --   runtimes = {
      --     { name = "JavaSE-17", path = "/usr/lib/jvm/java-17-openjdk" },
      --     { name = "JavaSE-21", path = "/usr/lib/jvm/java-21-openjdk" },
      --   },
      -- },
    },
  },
  on_attach = function(_, bufnr)
    -- Debug: wire jdtls into nvim-dap and discover main classes
    jdtls.setup_dap { hotcodereplace = 'auto' }
    require('jdtls.dap').setup_dap_main_class_configs()

    local function map(lhs, rhs, desc, mode) vim.keymap.set(mode or 'n', lhs, rhs, { buffer = bufnr, desc = desc }) end
    map('<leader>co', jdtls.organize_imports, 'Organize imports')
    map('<leader>cv', jdtls.extract_variable, 'Extract variable')
    map('<leader>cv', function() jdtls.extract_variable(true) end, 'Extract variable', 'v')
    map('<leader>cC', jdtls.extract_constant, 'Extract constant')
    map('<leader>cM', function() jdtls.extract_method(true) end, 'Extract method', 'v')
    map('<leader>dn', jdtls.test_nearest_method, 'Debug nearest test method')
    map('<leader>dT', jdtls.test_class, 'Debug test class')
  end,
}
