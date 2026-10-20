-- JSON with schemas: package.json, tsconfig.json, composer.json, .eslintrc...
return {
  settings = {
    json = { schemas = require('schemastore').json.schemas(), validate = { enable = true } },
  },
}
