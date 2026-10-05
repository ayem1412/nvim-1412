-- Treesitter (new "main" branch API: no more `configs.setup`)
local parsers = {
  -- core
  "lua", "luadoc", "vim", "vimdoc", "query", "regex", "bash", "markdown", "markdown_inline",
  "json", "jsonc", "yaml", "toml", "xml", "diff", "gitcommit", "git_rebase", "dockerfile",
  -- work
  "java", "php", "phpdoc", "javascript", "typescript", "tsx", "vue", "html", "css", "scss", "sql",
  "properties", -- application.properties
  -- personal
  "rust", "c",
}

return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    lazy = false,
    build = ":TSUpdate",
    config = function()
      local ts = require("nvim-treesitter")
      ts.setup({
        install_dir = vim.fn.stdpath("data") .. "/site",
      })

      -- Install anything missing (no-op if already there)
      local installed = ts.get_installed("parsers")
      local missing = vim.tbl_filter(function(p)
        return not vim.tbl_contains(installed, p)
      end, parsers)
      if #missing > 0 then
        ts.install(missing)
      end

      -- Start highlighting + indentation when a parser is available
      vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("cfg_treesitter", { clear = true }),
        callback = function(ev)
          local lang = vim.treesitter.language.get_lang(ev.match)
          if not lang then return end
          if not pcall(vim.treesitter.start, ev.buf, lang) then return end
          vim.bo[ev.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end,
      })
    end,
  },

  -- Text objects (functions, classes, parameters...) used by mini.ai
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    branch = "main",
    event = "VeryLazy",
    opts = { select = { lookahead = true }, move = { set_jumps = true } },
    config = function(_, opts)
      require("nvim-treesitter-textobjects").setup(opts)
      local move = require("nvim-treesitter-textobjects.move")
      local map = vim.keymap.set
      map({ "n", "x", "o" }, "]f", function() move.goto_next_start("@function.outer") end, { desc = "Next function" })
      map({ "n", "x", "o" }, "[f", function() move.goto_previous_start("@function.outer") end, { desc = "Prev function" })
      map({ "n", "x", "o" }, "]c", function() move.goto_next_start("@class.outer") end, { desc = "Next class" })
      map({ "n", "x", "o" }, "[c", function() move.goto_previous_start("@class.outer") end, { desc = "Prev class" })
    end,
  },

  -- Auto close / rename HTML, Vue, JSX tags
  {
    "windwp/nvim-ts-autotag",
    event = { "BufReadPre", "BufNewFile" },
    opts = {},
  },
}
