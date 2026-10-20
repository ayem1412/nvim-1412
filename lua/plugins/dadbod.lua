-- Database client: SQL Server (needs `sqlcmd`) and SQLite (needs `sqlite3`)
return {
  "kristijanhusak/vim-dadbod-ui",
  dependencies = {
    { "tpope/vim-dadbod", lazy = true },
    { "kristijanhusak/vim-dadbod-completion", ft = { "sql", "mysql", "plsql" }, lazy = true },
  },
  cmd = { "DBUI", "DBUIToggle", "DBUIAddConnection", "DBUIFindBuffer" },
  init = function() require("setup.dadbod") end,
  keys = {
    { "<leader>Du", "<cmd>DBUIToggle<cr>", desc = "Toggle DB UI" },
    { "<leader>Df", "<cmd>DBUIFindBuffer<cr>", desc = "Find DB buffer" },
  },
}
