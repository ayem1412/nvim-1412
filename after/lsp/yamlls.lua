-- YAML with schemas: docker-compose.yml, GitHub workflows, GitLab CI, k8s...
-- (Spring's application.yml keys come from the spring-boot server, not this one)
return {
  settings = {
    yaml = {
      schemaStore = { enable = false, url = '' }, -- use SchemaStore.nvim's list instead
      schemas = require('schemastore').yaml.schemas(),
    },
  },
}
