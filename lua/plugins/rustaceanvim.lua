-- Rust: LSP + debugging (codelldb). Loads itself when you open a Rust file.
return {
  "mrcjkb/rustaceanvim",
  version = "^6",
  lazy = false,
  init = function() require("setup.rustaceanvim") end,
}
