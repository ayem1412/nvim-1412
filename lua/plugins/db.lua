-- Database client: SQL Server (needs `sqlcmd`) and SQLite (needs `sqlite3`)
-- Connections go in ~/.local/share/nvim/db_ui/connections.json or in vim.g.dbs (see README)
return {
  {
    "kristijanhusak/vim-dadbod-ui",
    dependencies = {
      { "tpope/vim-dadbod", lazy = true },
      { "kristijanhusak/vim-dadbod-completion", ft = { "sql", "mysql", "plsql" }, lazy = true },
    },
    cmd = { "DBUI", "DBUIToggle", "DBUIAddConnection", "DBUIFindBuffer" },
    keys = {
      { "<leader>Du", "<cmd>DBUIToggle<cr>", desc = "Toggle DB UI" },
      { "<leader>Df", "<cmd>DBUIFindBuffer<cr>", desc = "Find DB buffer" },
    },
    init = function()
      vim.g.db_ui_use_nerd_fonts = 1
      vim.g.db_ui_show_database_icon = 1
      vim.g.db_ui_winwidth = 35
      vim.g.db_ui_execute_on_save = 0 -- run with <leader>S instead of on every save
      vim.g.db_ui_save_location = vim.fn.stdpath("data") .. "/db_ui"
    end,
  },
}
