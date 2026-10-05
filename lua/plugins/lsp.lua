return {
  -- Installer for LSPs, DAPs, formatters, linters
  {
    "mason-org/mason.nvim",
    cmd = "Mason",
    keys = { { "<leader>cm", "<cmd>Mason<cr>", desc = "Mason" } },
    opts = {
      ui = { border = "rounded" },
      -- Non-LSP tools. LSP servers are listed in mason-lspconfig below.
      ensure_installed = {
        "stylua", "prettierd", "shfmt",
        "codelldb", "php-debug-adapter", "js-debug-adapter", "java-debug-adapter", "java-test",
      },
    },
    config = function(_, opts)
      require("mason").setup(opts)
      local registry = require("mason-registry")
      registry.refresh(function()
        for _, name in ipairs(opts.ensure_installed) do
          local ok, pkg = pcall(registry.get_package, name)
          if ok and not pkg:is_installed() then
            pkg:install()
          end
        end
      end)
    end,
  },

  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "mason-org/mason.nvim",
      "mason-org/mason-lspconfig.nvim",
      "saghen/blink.cmp",
      "b0o/SchemaStore.nvim",
    },
    config = function()
      -- Shared settings for every server
      vim.lsp.config("*", {
        capabilities = require("blink.cmp").get_lsp_capabilities(),
      })

      -- Lua (for this config)
      vim.lsp.config("lua_ls", {
        settings = {
          Lua = {
            workspace = { checkThirdParty = false },
            completion = { callSnippet = "Replace" },
            diagnostics = { globals = { "vim", "Snacks" } },
          },
        },
      })

      -- PHP: intelephense. Default PHP version is 5.6 (legacy WAMP projects).
      -- Override per project with a `.nvim.lua` file (see README).
      vim.lsp.config("intelephense", {
        settings = {
          intelephense = {
            environment = { phpVersion = "5.6.40" },
            files = { maxSize = 5000000, exclude = { "**/vendor/**/{Tests,tests}/**", "**/node_modules/**", "**/cache/**" } },
            telemetry = { enabled = false },
          },
        },
      })

      -- TypeScript / JavaScript / Vue (vtsls + Vue plugin)
      local vue_plugin_path = vim.fn.expand("$MASON/packages/vue-language-server/node_modules/@vue/language-server")
      vim.lsp.config("vtsls", {
        filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact", "vue" },
        settings = {
          complete_function_calls = true,
          vtsls = {
            enableMoveToFileCodeAction = true,
            autoUseWorkspaceTsdk = true,
            tsserver = {
              globalPlugins = {
                {
                  name = "@vue/typescript-plugin",
                  location = vue_plugin_path,
                  languages = { "vue" },
                  configNamespace = "typescript",
                  enableForWorkspaceTypeScriptVersions = true,
                },
              },
            },
          },
          typescript = {
            updateImportsOnFileMove = { enabled = "always" },
            inlayHints = {
              parameterNames = { enabled = "literals" },
              variableTypes = { enabled = false },
              functionLikeReturnTypes = { enabled = true },
            },
          },
        },
      })

      -- JSON / YAML with schemas (package.json, tsconfig, docker-compose, GitHub workflows...)
      vim.lsp.config("jsonls", {
        settings = {
          json = { schemas = require("schemastore").json.schemas(), validate = { enable = true } },
        },
      })
      vim.lsp.config("yamlls", {
        settings = {
          yaml = {
            schemaStore = { enable = false, url = "" },
            schemas = require("schemastore").yaml.schemas(),
          },
        },
      })

      require("mason-lspconfig").setup({
        ensure_installed = {
          "lua_ls",
          "intelephense",
          "vtsls", "vue_ls",
          "html", "cssls", "emmet_language_server",
          "jsonls", "yamlls", "lemminx", -- lemminx = XML (pom.xml)
          "jdtls", -- installed here, started by nvim-jdtls (ftplugin/java.lua)
        },
        -- jdtls: handled by nvim-jdtls. rust_analyzer: handled by rustaceanvim.
        automatic_enable = { exclude = { "jdtls", "rust_analyzer" } },
      })

      -- Keymaps when a server attaches
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("cfg_lsp_attach", { clear = true }),
        callback = function(ev)
          local client = vim.lsp.get_client_by_id(ev.data.client_id)
          local function map(lhs, rhs, desc, mode)
            vim.keymap.set(mode or "n", lhs, rhs, { buffer = ev.buf, desc = desc })
          end
          map("gd", function() Snacks.picker.lsp_definitions() end, "Goto definition")
          map("gD", function() Snacks.picker.lsp_declarations() end, "Goto declaration")
          map("gr", function() Snacks.picker.lsp_references() end, "References")
          map("gI", function() Snacks.picker.lsp_implementations() end, "Goto implementation")
          map("gy", function() Snacks.picker.lsp_type_definitions() end, "Goto type definition")
          map("K", function() vim.lsp.buf.hover({ border = "rounded" }) end, "Hover")
          map("gK", function() vim.lsp.buf.signature_help({ border = "rounded" }) end, "Signature help")
          map("<C-k>", function() vim.lsp.buf.signature_help({ border = "rounded" }) end, "Signature help", "i")
          map("<leader>ca", vim.lsp.buf.code_action, "Code action", { "n", "v" })
          map("<leader>cr", vim.lsp.buf.rename, "Rename")
          map("<leader>cl", "<cmd>checkhealth vim.lsp<cr>", "LSP info")

          -- Inlay hints off by default, toggle with <leader>uh
          if client and client:supports_method("textDocument/inlayHint") then
            vim.lsp.inlay_hint.enable(false, { bufnr = ev.buf })
          end
        end,
      })
    end,
  },

  -- Rust: LSP + DAP (codelldb) all in one, no extra setup
  {
    "mrcjkb/rustaceanvim",
    version = "^6",
    lazy = false, -- plugin lazy-loads itself by filetype
    init = function()
      vim.g.rustaceanvim = {
        server = {
          default_settings = {
            ["rust-analyzer"] = {
              cargo = { allFeatures = true },
              check = { command = "clippy" },
              inlayHints = { lifetimeElisionHints = { enable = "always" } },
            },
          },
        },
      }
    end,
  },

  -- Java: smarter jdtls wrapper (started in ftplugin/java.lua)
  {
    "mfussenegger/nvim-jdtls",
    ft = "java",
  },

  { "b0o/SchemaStore.nvim", lazy = true },
}
