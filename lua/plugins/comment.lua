-- gcc / gc{motion} = line comment, gbc / gb{motion} = block comment (visual: gc / gb)
return {
  "numToStr/Comment.nvim",
  event = { "BufReadPost", "BufNewFile" },
  dependencies = { "JoosepAlviste/nvim-ts-context-commentstring" }, -- right comment style inside Vue/TSX
  config = function() require("setup.comment") end,
}
