require("blink.cmp").setup({
  keymap = {
    preset = "default", -- <C-y> accept, <C-n>/<C-p> move, <C-space> open, <C-e> close
    ["<Tab>"] = { "snippet_forward", "fallback" },
    ["<S-Tab>"] = { "snippet_backward", "fallback" },
  },
  appearance = { nerd_font_variant = "mono" },
  completion = {
    accept = { auto_brackets = { enabled = true } },
    menu = {
      border = "rounded",
      draw = {
        treesitter = { "lsp" },
        columns = { { "kind_icon" }, { "label", "label_description", gap = 1 }, { "kind" } },
      },
    },
    documentation = { auto_show = true, auto_show_delay_ms = 200, window = { border = "rounded" } },
    ghost_text = { enabled = false },
  },
  signature = { enabled = true, window = { border = "rounded" } },
  sources = {
    default = { "lsp", "path", "snippets", "buffer" },
    per_filetype = {
      sql = { "dadbod", "buffer" },
      mysql = { "dadbod", "buffer" },
      plsql = { "dadbod", "buffer" },
    },
    providers = {
      dadbod = { name = "Dadbod", module = "vim_dadbod_completion.blink" },
    },
  },
  fuzzy = { implementation = "prefer_rust_with_warning" },
  cmdline = { enabled = false },
})
