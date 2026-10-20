-- Installer for language servers, debuggers, formatters
return {
  "mason-org/mason.nvim",
  cmd = "Mason",
  keys = { { "<leader>cm", "<cmd>Mason<cr>", desc = "Mason" } },
  config = function() require("setup.mason") end,
}
