-- Spring Boot: completion in application.yml / application.properties,
-- plus Spring-aware help in .java files (works through jdtls, see ftplugin/java.lua)
return {
  'JavaHello/spring-boot.nvim',
  ft = { 'java', 'yaml', 'jproperties' },
  dependencies = { 'mfussenegger/nvim-jdtls' },
  opts = {},
}
