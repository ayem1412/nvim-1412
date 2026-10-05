return {
  -- Jump anywhere with s + 2 chars
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    opts = {},
    keys = {
      { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
      { "S", mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
      { "r", mode = "o", function() require("flash").remote() end, desc = "Remote Flash" },
      { "R", mode = { "o", "x" }, function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
    },
  },

  -- Git signs in the gutter + hunk actions
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      signs = {
        add = { text = "▎" }, change = { text = "▎" }, delete = { text = "\u{2581}" },
        topdelete = { text = "\u{2594}" }, changedelete = { text = "▎" }, untracked = { text = "▎" },
      },
      on_attach = function(buffer)
        local gs = package.loaded.gitsigns
        local function map(mode, l, r, desc)
          vim.keymap.set(mode, l, r, { buffer = buffer, desc = desc })
        end
        map("n", "]h", function() gs.nav_hunk("next") end, "Next hunk")
        map("n", "[h", function() gs.nav_hunk("prev") end, "Prev hunk")
        map({ "n", "v" }, "<leader>ghs", ":Gitsigns stage_hunk<CR>", "Stage hunk")
        map({ "n", "v" }, "<leader>ghr", ":Gitsigns reset_hunk<CR>", "Reset hunk")
        map("n", "<leader>ghS", gs.stage_buffer, "Stage buffer")
        map("n", "<leader>ghR", gs.reset_buffer, "Reset buffer")
        map("n", "<leader>ghp", gs.preview_hunk_inline, "Preview hunk")
        map("n", "<leader>ghb", function() gs.blame_line({ full = true }) end, "Blame line")
        map("n", "<leader>ghd", gs.diffthis, "Diff this")
        map("n", "<leader>ub", gs.toggle_current_line_blame, "Toggle line blame")
        map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", "Select hunk")
      end,
    },
  },

  -- Small, fast editing helpers
  {
    "nvim-mini/mini.pairs",
    event = "InsertEnter",
    opts = { modes = { insert = true, command = true, terminal = false } },
  },
  {
    "nvim-mini/mini.surround",
    event = "VeryLazy",
    opts = {}, -- sa (add), sd (delete), sr (replace) + text object
  },
  {
    "nvim-mini/mini.ai",
    event = "VeryLazy",
    opts = function()
      local ai = require("mini.ai")
      return {
        n_lines = 500,
        custom_textobjects = {
          o = ai.gen_spec.treesitter({
            a = { "@block.outer", "@conditional.outer", "@loop.outer" },
            i = { "@block.inner", "@conditional.inner", "@loop.inner" },
          }),
          f = ai.gen_spec.treesitter({ a = "@function.outer", i = "@function.inner" }),
          c = ai.gen_spec.treesitter({ a = "@class.outer", i = "@class.inner" }),
          a = ai.gen_spec.treesitter({ a = "@parameter.outer", i = "@parameter.inner" }),
        },
      }
    end,
  },

  -- TODO / FIXME / HACK highlighting + search
  {
    "folke/todo-comments.nvim",
    event = { "BufReadPost", "BufNewFile" },
    opts = { signs = false },
    keys = {
      { "]t", function() require("todo-comments").jump_next() end, desc = "Next todo" },
      { "[t", function() require("todo-comments").jump_prev() end, desc = "Prev todo" },
      { "<leader>st", function() Snacks.picker.todo_comments() end, desc = "Todo comments" },
    },
  },

  -- Better diagnostics / references / quickfix lists
  {
    "folke/trouble.nvim",
    cmd = "Trouble",
    opts = { focus = true },
    keys = {
      { "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", desc = "Diagnostics (Trouble)" },
      { "<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", desc = "Buffer diagnostics (Trouble)" },
      { "<leader>xs", "<cmd>Trouble symbols toggle<cr>", desc = "Symbols (Trouble)" },
      { "<leader>xr", "<cmd>Trouble lsp toggle<cr>", desc = "LSP refs/defs (Trouble)" },
      { "<leader>xQ", "<cmd>Trouble qflist toggle<cr>", desc = "Quickfix (Trouble)" },
    },
  },

  -- Session restore (used by dashboard "s" key)
  {
    "folke/persistence.nvim",
    event = "BufReadPre",
    opts = {},
    keys = {
      { "<leader>qs", function() require("persistence").load() end, desc = "Restore session" },
      { "<leader>ql", function() require("persistence").load({ last = true }) end, desc = "Restore last session" },
      { "<leader>qd", function() require("persistence").stop() end, desc = "Don't save this session" },
    },
  },
}
