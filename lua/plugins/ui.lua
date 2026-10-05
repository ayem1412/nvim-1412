return {
  -- Colorscheme
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    opts = {
      style = "moon",
      transparent = false,
      styles = { sidebars = "dark", floats = "dark" },
    },
    config = function(_, opts)
      require("tokyonight").setup(opts)
      vim.cmd.colorscheme("tokyonight")
    end,
  },

  -- Icons
  { "nvim-tree/nvim-web-devicons", lazy = true },

  -- Statusline
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    opts = function()
      return {
        options = {
          theme = "tokyonight",
          globalstatus = true,
          component_separators = { left = "\u{e0b1}", right = "\u{e0b3}" },
          section_separators = { left = "\u{e0b0}", right = "\u{e0b2}" },
          disabled_filetypes = { statusline = { "snacks_dashboard" } },
        },
        sections = {
          lualine_a = { "mode" },
          lualine_b = { "branch" },
          lualine_c = {
            { "diagnostics", symbols = { error = "\u{f057} ", warn = "\u{f071} ", info = "\u{f05a} ", hint = "\u{f0eb} " } },
            { "filetype", icon_only = true, separator = "", padding = { left = 1, right = 0 } },
            { "filename", path = 1, symbols = { modified = " \u{f040}", readonly = " \u{f023}", unnamed = "[No Name]" } },
          },
          lualine_x = {
            {
              function() return "\u{f188} " .. require("dap").status() end,
              cond = function() return package.loaded["dap"] and require("dap").status() ~= "" end,
            },
            { "diff", symbols = { added = "\u{f457} ", modified = "\u{f459} ", removed = "\u{f458} " } },
            {
              function()
                local clients = vim.lsp.get_clients({ bufnr = 0 })
                if #clients == 0 then return "" end
                return "\u{f085} " .. table.concat(vim.tbl_map(function(c) return c.name end, clients), ",")
              end,
            },
          },
          lualine_y = { { "progress", separator = " ", padding = { left = 1, right = 0 } }, { "location", padding = { left = 0, right = 1 } } },
          lualine_z = { function() return "\u{f017} " .. os.date("%R") end },
        },
        extensions = { "lazy", "quickfix", "nvim-dap-ui" },
      }
    end,
  },

  -- Keymap hints
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      preset = "helix",
      spec = {
        { "<leader>b", group = "buffer" },
        { "<leader>c", group = "code" },
        { "<leader>d", group = "debug" },
        { "<leader>D", group = "database" },
        { "<leader>f", group = "file/find" },
        { "<leader>g", group = "git" },
        { "<leader>q", group = "quit" },
        { "<leader>s", group = "search" },
        { "<leader>u", group = "ui/toggle" },
        { "<leader>w", group = "window" },
        { "<leader>x", group = "diagnostics/lists" },
        { "<leader><tab>", group = "tabs" },
        { "[", group = "prev" },
        { "]", group = "next" },
        { "g", group = "goto" },
        { "z", group = "fold" },
      },
    },
  },

  -- Snacks: picker, explorer, notifications, dashboard, indent guides, lazygit, terminal
  {
    "folke/snacks.nvim",
    lazy = false,
    priority = 900,
    opts = {
      bigfile = { enabled = true }, -- disables heavy stuff on huge files
      quickfile = { enabled = true },
      notifier = { enabled = true, timeout = 3000 },
      input = { enabled = true },
      indent = { enabled = true, animate = { enabled = false } },
      words = { enabled = true }, -- highlight references under cursor
      statuscolumn = { enabled = true },
      scroll = { enabled = false },
      picker = {
        sources = {
          explorer = { hidden = true, ignored = false },
          files = { hidden = true },
          grep = { hidden = true },
        },
      },
      explorer = { enabled = true },
      dashboard = {
        preset = {
          header = [[
███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗
████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║
██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║
██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║
██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║
╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝]],
          keys = {
            { icon = "\u{f002} ", key = "f", desc = "Find File", action = ":lua Snacks.picker.files()" },
            { icon = "\u{f15b} ", key = "n", desc = "New File", action = ":ene | startinsert" },
            { icon = "\u{f0e7} ", key = "g", desc = "Find Text", action = ":lua Snacks.picker.grep()" },
            { icon = "\u{f017} ", key = "r", desc = "Recent Files", action = ":lua Snacks.picker.recent()" },
            { icon = "\u{f013} ", key = "c", desc = "Config", action = ":lua Snacks.picker.files({cwd = vim.fn.stdpath('config')})" },
            { icon = "\u{f0e2} ", key = "s", desc = "Restore Session", section = "session" },
            { icon = "󰒲 ", key = "l", desc = "Lazy", action = ":Lazy" },
            { icon = "\u{f011} ", key = "q", desc = "Quit", action = ":qa" },
          },
        },
        sections = {
          { section = "header" },
          { section = "keys", gap = 1, padding = 1 },
          { section = "recent_files", icon = "\u{f017} ", title = "Recent Files", indent = 2, padding = 1 },
          { section = "projects", icon = "\u{f07b} ", title = "Projects", indent = 2, padding = 1 },
          { section = "startup" },
        },
      },
    },
    keys = {
      -- Files
      { "<leader><space>", function() Snacks.picker.smart() end, desc = "Smart find files" },
      { "<leader>ff", function() Snacks.picker.files() end, desc = "Find files" },
      { "<leader>fr", function() Snacks.picker.recent() end, desc = "Recent files" },
      { "<leader>fb", function() Snacks.picker.buffers() end, desc = "Buffers" },
      { "<leader>fc", function() Snacks.picker.files({ cwd = vim.fn.stdpath("config") }) end, desc = "Config files" },
      { "<leader>fp", function() Snacks.picker.projects() end, desc = "Projects" },
      { "<leader>e", function() Snacks.explorer() end, desc = "File explorer" },
      -- Search
      { "<leader>/", function() Snacks.picker.grep() end, desc = "Grep" },
      { "<leader>sg", function() Snacks.picker.grep() end, desc = "Grep" },
      { "<leader>sw", function() Snacks.picker.grep_word() end, desc = "Grep word under cursor", mode = { "n", "x" } },
      { "<leader>sb", function() Snacks.picker.lines() end, desc = "Buffer lines" },
      { "<leader>sh", function() Snacks.picker.help() end, desc = "Help pages" },
      { "<leader>sk", function() Snacks.picker.keymaps() end, desc = "Keymaps" },
      { "<leader>sc", function() Snacks.picker.command_history() end, desc = "Command history" },
      { "<leader>sd", function() Snacks.picker.diagnostics() end, desc = "Diagnostics (workspace)" },
      { "<leader>sD", function() Snacks.picker.diagnostics_buffer() end, desc = "Diagnostics (buffer)" },
      { "<leader>ss", function() Snacks.picker.lsp_symbols() end, desc = "LSP symbols" },
      { "<leader>sS", function() Snacks.picker.lsp_workspace_symbols() end, desc = "LSP workspace symbols" },
      { "<leader>su", function() Snacks.picker.undo() end, desc = "Undo history" },
      { "<leader>sq", function() Snacks.picker.qflist() end, desc = "Quickfix" },
      { "<leader>sR", function() Snacks.picker.resume() end, desc = "Resume last picker" },
      { "<leader>uC", function() Snacks.picker.colorschemes() end, desc = "Colorschemes" },
      -- Git
      { "<leader>gg", function() Snacks.lazygit() end, desc = "Lazygit" },
      { "<leader>gl", function() Snacks.picker.git_log() end, desc = "Git log" },
      { "<leader>gs", function() Snacks.picker.git_status() end, desc = "Git status" },
      { "<leader>gb", function() Snacks.picker.git_branches() end, desc = "Git branches" },
      { "<leader>gB", function() Snacks.gitbrowse() end, desc = "Open in browser" },
      -- Buffers / misc
      { "<leader>bd", function() Snacks.bufdelete() end, desc = "Delete buffer" },
      { "<leader>bo", function() Snacks.bufdelete.other() end, desc = "Delete other buffers" },
      { "<leader>cR", function() Snacks.rename.rename_file() end, desc = "Rename file" },
      { "<leader>n", function() Snacks.notifier.show_history() end, desc = "Notification history" },
      { "<leader>un", function() Snacks.notifier.hide() end, desc = "Dismiss notifications" },
      { "<C-/>", function() Snacks.terminal() end, desc = "Toggle terminal", mode = { "n", "t" } },
      { "<C-_>", function() Snacks.terminal() end, desc = "Toggle terminal (tty)", mode = { "n", "t" } },
      { "]]", function() Snacks.words.jump(vim.v.count1) end, desc = "Next reference", mode = { "n", "t" } },
      { "[[", function() Snacks.words.jump(-vim.v.count1) end, desc = "Prev reference", mode = { "n", "t" } },
    },
    init = function()
      vim.api.nvim_create_autocmd("User", {
        pattern = "VeryLazy",
        callback = function()
          -- Toggles
          Snacks.toggle.option("spell", { name = "Spelling" }):map("<leader>us")
          Snacks.toggle.option("wrap", { name = "Wrap" }):map("<leader>uw")
          Snacks.toggle.option("relativenumber", { name = "Relative Number" }):map("<leader>uL")
          Snacks.toggle.line_number():map("<leader>ul")
          Snacks.toggle.diagnostics():map("<leader>ud")
          Snacks.toggle.inlay_hints():map("<leader>uh")
          Snacks.toggle.indent():map("<leader>ug")
          Snacks.toggle.dim():map("<leader>uD")
          Snacks.toggle.treesitter():map("<leader>uT")
        end,
      })
    end,
  },
}
