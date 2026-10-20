-- Connections are saved in ~/.local/share/nvim/db_ui (add them with :DBUIAddConnection)
vim.g.db_ui_use_nerd_fonts = 1
vim.g.db_ui_show_database_icon = 1
vim.g.db_ui_winwidth = 35
vim.g.db_ui_execute_on_save = 0 -- run queries with <leader>S, not on every save
vim.g.db_ui_save_location = vim.fn.stdpath("data") .. "/db_ui"
