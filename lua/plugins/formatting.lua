return {
  {
    "stevearc/conform.nvim",
    event = "BufWritePre",
    cmd = "ConformInfo",
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
    init = function()
      vim.g.autoformat = true
      vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
    end,
    opts = {
      formatters_by_ft = {
        lua = { "stylua" },
        rust = { "rustfmt" }, -- comes with rustup
        sh = { "shfmt" },
        javascript = { "prettierd", "prettier", stop_after_first = true },
        typescript = { "prettierd", "prettier", stop_after_first = true },
        javascriptreact = { "prettierd", "prettier", stop_after_first = true },
        typescriptreact = { "prettierd", "prettier", stop_after_first = true },
        vue = { "prettierd", "prettier", stop_after_first = true },
        html = { "prettierd", "prettier", stop_after_first = true },
        css = { "prettierd", "prettier", stop_after_first = true },
        scss = { "prettierd", "prettier", stop_after_first = true },
        json = { "prettierd", "prettier", stop_after_first = true },
        jsonc = { "prettierd", "prettier", stop_after_first = true },
        yaml = { "prettierd", "prettier", stop_after_first = true },
        markdown = { "prettierd", "prettier", stop_after_first = true },
        -- java and php: no auto-format (legacy code, keep diffs small).
        -- Use <leader>cf to format via LSP when you want it.
      },
      default_format_opts = { lsp_format = "fallback" },
      format_on_save = function(bufnr)
        if not vim.g.autoformat or vim.b[bufnr].autoformat == false then return end
        local ft = vim.bo[bufnr].filetype
        if ft == "java" or ft == "php" or ft == "sql" then return end
        return { timeout_ms = 1000, lsp_format = "fallback" }
      end,
    },
  },
}
