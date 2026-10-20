-- Formatting
return {
  "stevearc/conform.nvim",
  event = "BufWritePre",
  cmd = "ConformInfo",
  init = function()
    vim.g.autoformat = true
    vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
  end,
  config = function() require("setup.conform") end,
  keys = {
    { "<leader>cf", function() require("conform").format({ async = true }) end, mode = { "n", "v" }, desc = "Format" },
    {
      "<leader>uf",
      function()
        vim.g.autoformat = not vim.g.autoformat
        vim.notify("Format on save: " .. (vim.g.autoformat and "on" or "off"))
      end,
      desc = "Toggle format on save",
    },
  },
}
